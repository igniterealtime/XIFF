/*
 * Copyright (C) 2003-2012 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
 *     Michael McCarthy <mikeycmccarthy@gmail.com>
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.igniterealtime.xiff.core
{
	import com.hurlant.crypto.tls.*;

	import flash.events.*;


	/**
	 * This class is used to connect to and manage data coming from an XMPP server that supports TLS.
	 * Use one instance of this class per connection.
	 *
	 * @see http://tools.ietf.org/html/rfc3920#section-5
	 */
	public class XMPPTLSConnection extends XMPPConnection implements IXMPPConnection
	{
		/**
		 * @private
		 */
		protected var tlsSocket:TLSSocket;

		/**
		 * @private
		 */
		protected var _config:TLSConfig;

		/**
		 * Constructor.
		 * <p>The connection socket created in XMPPConnection is used until the server responds as "proceed".</p>
		 */
		public function XMPPTLSConnection()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function connect( streamType:uint=0 ):void
		{
			if ( tlsEnabled )
			{
				removeTLSSocketEventListeners();
				tlsEnabled = false;
			}

			if ( active )
			{
				removeSocketEventListeners();
			}

			super.connect( streamType );
		}

		/**
		 * @inheritDoc
		 */
		override public function disconnect():void
		{
			if ( active )
			{
				if ( tlsEnabled )
				{
					removeTLSSocketEventListeners();
					tlsEnabled = false;
					tlsSocket.close();
				}

				removeSocketEventListeners();

				super.disconnect();
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function handleNodeType( node:XML ):void
		{
			var nodeName:String = String(node.localName()).toLowerCase();

			switch( nodeName )
			{
				case "proceed":
					startTLS();
					break;

				default:
					super.handleNodeType( node );
					break;
			}
		}

		/**
		 * In case the user or the server requires the use of TLS, this method
		 * will initiate the handshake.
		 */
		override protected function handleStreamTLS( node:XML ):void
		{
			trace("XMPPTLSConnection::handleStreamTLS. node: " + node.toXMLString());

			// If the user did not turn on TLS but the server requires it
			// TODO: user/developer should be notified somehow..
			if ( node.hasOwnProperty("required") )
			{
				tlsRequired = true;
			}

			// If the user turned on TLS or the server requires it.
			if ( tlsRequired )
			{
				sendXML( "<starttls xmlns='urn:ietf:params:xml:ns:xmpp-tls' />" );
			}
		}

		/**
		 * @see com.hurlant.crypto.tls.TLSSocket
		 */
		protected function configureTLSSocket():void
		{
			tlsSocket = new TLSSocket();
			tlsSocket.addEventListener( Event.CLOSE, onSocketClosed );
			tlsSocket.addEventListener( Event.CONNECT, onSocketConnected );
			tlsSocket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketDataReceived );
			tlsSocket.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			tlsSocket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			tlsSocket.addEventListener( TLSSocket.ACCEPT_PEER_CERT_PROMPT, onAcceptPeerCertPrompt );

			if ( _config != null )
			{
				tlsSocket.setTLSConfig( _config );
			}
		}

		/**
		 * Remove those listeners that the <code>configureTLSSocket</code> method added.
		 */
		protected function removeTLSSocketEventListeners():void
		{
			tlsSocket.removeEventListener( Event.CLOSE, onSocketClosed );
			tlsSocket.removeEventListener( Event.CONNECT, onSocketConnected );
			tlsSocket.removeEventListener( ProgressEvent.SOCKET_DATA, onSocketDataReceived );
			tlsSocket.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			tlsSocket.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			tlsSocket.removeEventListener( TLSSocket.ACCEPT_PEER_CERT_PROMPT, onAcceptPeerCertPrompt );
		}

		/**
		 * @private
		 *
		 * @param	event
		 */
		protected function onAcceptPeerCertPrompt( event:Event ):void
		{
			trace( 'onAcceptPeerCertPrompt', event.toString() );
		}

		/**
		 * @private
		 */
		protected function startTLS():void
		{
			// remove listeners from non-TLS socket
			removeSocketEventListeners();

			// add listeners to TLS socket
			configureTLSSocket();

			tlsSocket.startTLS( socket, server, _config );

			// overwrite super
			socket = tlsSocket;

			tlsEnabled = true;

			// we have tls. The socket is now wrapped as a TLSSocket
			// Create a new stream and continue
			sendXML( openingStreamTag );
		}

		/**
		 * TLS configuration.
		 */
		public function get config():TLSConfig
		{
			return _config;
		}
		public function set config( value:TLSConfig ):void
		{
			_config = value;

			if ( tlsSocket != null && _config != null )
			{
				// TODO: This might not be a good idea when the socket is active
				tlsSocket.setTLSConfig( _config );
			}
		}

		/**
		 * Specifies whether to enable TLS.
		 * @default false
		 */
		public function get tls():Boolean
		{
			return tlsRequired;
		}
		public function set tls( value:Boolean ):void
		{
			tlsRequired = value;
		}
	}
}
