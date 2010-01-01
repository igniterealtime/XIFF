/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
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
	import flash.net.Socket;
	import flash.events.*;
	import flash.utils.ByteArray;
	
	import org.igniterealtime.xiff.events.*;
	
	import com.hurlant.crypto.tls.*;
	
	/**
	 * TLS supporting connection. You need to have <a href="http://code.google.com/p/as3crypto/">AS3Crypto library</a>
	 * in order to use this class.
	 *
	 * <p>Work in progress. Not expected to work.</p>
	 *
	 * @see org.igniterealtime.xiff.core.XMPPConnection
	 */
	public class XMPPTLSConnection extends XMPPConnection
	{
		private var _config:TLSConfig;
		private var tlsSocket:TLSSocket;
		
		public function XMPPTLSConnection()
		{
			super();
		}
		
		/**
		 * @see com.hurlant.crypto.tls.TLSSocket
		 */
		override protected function createSocket():void
		{
			tlsSocket = new TLSSocket();
	        tlsSocket.addEventListener(Event.CLOSE, socketClosed);
	        tlsSocket.addEventListener(Event.CONNECT, socketConnected);
	        tlsSocket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			tlsSocket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataReceived);
	        tlsSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			tlsSocket.addEventListener(TLSSocket.ACCEPT_PEER_CERT_PROMPT, onAcceptPeerCertPrompt);
			if (_config != null)
			{
				tlsSocket.setTLSConfig(_config);
			}
	    }
		override public function connect( streamType:uint = 0 ):Boolean
		{
			createSocket();
			_streamType = streamType;

			active = false;
			loggedIn = false;

			chooseStreamTags(streamType);

			tlsSocket.connect( server, port );
			return true;
		}
		override public function disconnect():void
		{
			if ( isActive() )
			{
				sendXML( closingStreamTag ); // String
				if (tlsSocket)
				{
					tlsSocket.close();
				}
				active = false;
				loggedIn = false;

				var disconnectionEvent:DisconnectionEvent = new DisconnectionEvent();
				dispatchEvent(disconnectionEvent);
			}
		}
		override protected function socketDataReceived( event:ProgressEvent ):void
		{
			var bytedata:ByteArray = new ByteArray();
			// The default value of 0 causes all available data to be read.
			tlsSocket.readBytes(bytedata);
			parseDataReceived( bytedata );
		}
		override protected function sendXML( someData:* ):void
		{
			var bytedata:ByteArray = new ByteArray();
			bytedata.writeUTFBytes(someData);
			
			bytedata.position = 0;
			if (compressionNegotiated)
			{
				bytedata.compress();
				bytedata.position = 0; // maybe not needed.
			}
			tlsSocket.writeBytes( bytedata, 0, bytedata.length );
			tlsSocket.flush();
			
			_outgoingBytes += bytedata.length;

			var event:OutgoingDataEvent = new OutgoingDataEvent();
			event.data = bytedata;
			dispatchEvent( event );
		}
		
		/**
		 *
		 * @param	event
		 */
		private function onAcceptPeerCertPrompt(event:Event):void
		{
			trace("onAcceptPeerCertPrompt. " + event.toString());
		}
		
		/**
		 * TLS configuration. Set after creating the socket.
		 */
		public function get config():TLSConfig
		{
			return _config;
		}
		public function set config(value:TLSConfig):void
		{
			_config = value;
			if (tlsSocket != null && _config != null)
			{
				tlsSocket.setTLSConfig(_config);
			}
		}
	}
}
