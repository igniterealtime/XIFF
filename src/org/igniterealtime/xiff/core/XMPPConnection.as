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
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	import org.igniterealtime.xiff.auth.*;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.data.auth.AuthExtension;
	import org.igniterealtime.xiff.data.bind.BindExtension;
	import org.igniterealtime.xiff.data.forms.FormExtension;
	import org.igniterealtime.xiff.data.ping.PingExtension;
	import org.igniterealtime.xiff.data.register.RegisterExtension;
	import org.igniterealtime.xiff.data.session.SessionExtension;
	import org.igniterealtime.xiff.events.*;

	/**
	 * Dispatched when a password change is successful.
	 *
	 * @eventType org.igniterealtime.xiff.events.ChangePasswordSuccessEvent.PASSWORD_SUCCESS
	 */
	[Event( name="changePasswordSuccess", type="org.igniterealtime.xiff.events.ChangePasswordSuccessEvent" )]
	/**
	 * Dispatched when the connection is successfully made to the server.
	 *
	 * @eventType org.igniterealtime.xiff.events.ConnectionSuccessEvent.CONNECT_SUCCESS
	 */
	[Event( name="connection", type="org.igniterealtime.xiff.events.ConnectionSuccessEvent" )]
	/**
	 * Dispatched when there is a disconnection from the server.
	 *
	 * @eventType org.igniterealtime.xiff.events.DisconnectionEvent.DISCONNECT
	 */
	[Event( name="disconnection", type="org.igniterealtime.xiff.events.DisconnectionEvent" )]
	/**
	 * Dispatched when there is some type of XMPP error.
	 *
	 * @eventType org.igniterealtime.xiff.events.XIFFErrorEvent.XIFF_ERROR
	 */
	[Event( name="error", type="org.igniterealtime.xiff.events.XIFFErrorEvent" )]
	/**
	 * Dispatched whenever there is incoming XML data.
	 *
	 * @eventType org.igniterealtime.xiff.events.IncomingDataEvent.INCOMING_DATA
	 */
	[Event( name="incomingData", type="org.igniterealtime.xiff.events.IncomingDataEvent" )]
	/**
	 * Dispatched on successful authentication (login) with the server.
	 *
	 * @eventType org.igniterealtime.xiff.events.LoginEvent.LOGIN
	 */
	[Event( name="login", type="org.igniterealtime.xiff.events.LoginEvent" )]
	/**
	 * Dispatched on incoming messages.
	 *
	 * @eventType org.igniterealtime.xiff.events.MessageEvent.MESSAGE
	 */
	[Event( name="message", type="org.igniterealtime.xiff.events.MessageEvent" )]
	/**
	 * Dispatched whenever data is sent to the server.
	 *
	 * @eventType org.igniterealtime.xiff.events.OutgoingDataEvent.OUTGOING_DATA
	 */
	[Event( name="outgoingData", type="org.igniterealtime.xiff.events.OutgoingDataEvent" )]
	/**
	 * Dispatched on incoming presence data.
	 *
	 * @eventType org.igniterealtime.xiff.events.PresenceEvent.PRESENCE
	 */
	[Event( name="presence", type="org.igniterealtime.xiff.events.PresenceEvent" )]
	/**
	 * Dispatched on when new user account registration is successful.
	 *
	 * @eventType org.igniterealtime.xiff.events.RegistrationSuccessEvent.REGISTRATION_SUCCESS
	 */
	[Event( name="registrationSuccess", type="org.igniterealtime.xiff.events.RegistrationSuccessEvent" )]

	/**
	 * This class is used to connect to and manage data coming from an XMPP server.
	 * Use one instance of this class per connection.
	 */
	public class XMPPConnection extends EventDispatcher implements IXMPPConnection
	{
		/**
		 * Stream type lets user set opening/closing tag.
		 * <code>&lt;stream:stream&gt;</code>
		 */
		public static const STREAM_TYPE_STANDARD:uint = 0;

		/**
		 * Stream type lets user set opening/closing tag.
		 * <code>&lt;stream:stream /&gt;</code>
		 */
		public static const STREAM_TYPE_STANDARD_TERMINATED:uint = 1;

		/**
		 * Stream type lets user set opening/closing tag.
		 * <code>&lt;flash:stream&gt;</code>
		 */
		public static const STREAM_TYPE_FLASH:uint = 2;

		/**
		 * Stream type lets user set opening/closing tag.
		 * <code>&lt;flash:stream /&gt;</code>
		 */
		public static const STREAM_TYPE_FLASH_TERMINATED:uint = 3;

		/**
		 * @private
		 *
		 * The types of SASL mechanisms available.
		 * @see org.igniterealtime.xiff.auth.Anonymous
		 * @see org.igniterealtime.xiff.auth.DigestMD5
		 * @see org.igniterealtime.xiff.auth.External
		 * @see org.igniterealtime.xiff.auth.Plain
		 */
		protected static const SASL_MECHANISMS:Object = {
			"ANONYMOUS": Anonymous,
			"DIGEST-MD5": DigestMD5,
			"EXTERNAL": External,
			"PLAIN": Plain
		};

		/**
		 * @private
		 */
		protected static var _openConnections:Array = [];

		/**
		 * @private
		 */
		protected var auth:SASLAuth;

		/**
		 * @private
		 */
		protected var openingStreamTag:String;
		
		/**
		 * @private
		 * Depending of the STREAM_TYPE_* used in the <code>connect()</code> method,
		 * this variable will contain a matching closing element for it.
		 * <code>parseDataReceived()</code> method will use this value.
		 */
		protected var closingStreamTag:String;

		/**
		 * @private
		 * Depending of the STREAM_TYPE_* used in the <code>connect()</code> method,
		 * the name of the opening tag for stream is saved in this variable, such as
		 * <code>stream:stream</code> or <code>flash:stream</code>.
		 * Default value matches the default value of <code>connect()</code> method,
		 * which is STREAM_TYPE_STANDARD.
		 */
		protected var openingStreamTagSearch:String = "stream:stream";
		
		/**
		 * @private
		 * True if both sides of the connected parties have accepted the zlib compression.
		 */
		protected var compressionNegotiated:Boolean = false;

		/**
		 * Once received data from the socket, should the closing tag be seached?
		 * Initially this should be <code>true</code> as for the first incoming data
		 * there might be an error available.
		 * @private
		 */
		protected var expireTagSearch:Boolean = false;

		/**
		 * @private
		 * Save the previously received data if it was incomplete.
		 */
		protected var incompleteRawXML:String = "";

		/**
		 * @private
		 */
		protected var loggedIn:Boolean = false;

		/**
		 * @private
		 * Hash to hold callbacks for IQs
		 */
		protected var pendingIQs:Object = {};

		/**
		 * @private
		 * @see http://xmpp.org/extensions/xep-0199.html
		 * @see org.igniterealtime.xiff.data.ping.PingExtension
		 */
		protected var pingNotSupported:Boolean;

		/**
		 * @private
		 */
		protected var presenceQueue:Array = [];

		/**
		 * @private
		 */
		protected var presenceQueueTimer:Timer;

		/**
		 * @private
		 */
		protected var sessionID:String;

		/**
		 * Binary socket used to connect to the XMPP server.
		 */
		protected var socket:Socket;

		/**
		 * @private
		 * One of the STREAM_TYPE_.. constants.
		 * @default STREAM_TYPE_STANDARD
		 */
		protected var streamType:uint = 0;

		/**
		 * @private
		 */
		protected var _active:Boolean = false;

		/**
		 * @private
		 */
		protected var _compress:Boolean = false;

		/**
		 * @private
		 * User domain. Used as the server unless <code>server</code> is specifically set to something different.
		 * @exampleText gmail.com
		 */
		protected var _domain:String;

		/**
		 * @private
		 * @default true
		 */
		protected var _ignoreWhitespace:Boolean = true;

		/**
		 * @private
		 */
		protected var _incomingBytes:uint = 0;

		/**
		 * @private
		 */
		protected var _outgoingBytes:uint = 0;

		/**
		 * @private
		 */
		protected var _password:String;

		/**
		 * @private
		 * @default 5222
		 */
		protected var _port:uint = 5222;

		/**
		 * @private
		 */
		protected var _queuePresences:Boolean = true;

		/**
		 * @private
		 * @default xiff
		 */
		protected var _resource:String = "xiff";

		/**
		 * Server to connect, could be different of the login domain.
		 * @exampleText talk.google.com
		 */
		protected var _server:String;

		/**
		 * @private
		 */
		protected var _useAnonymousLogin:Boolean = false;

		/**
		 * @private
		 */
		protected var _username:String;

		/**
		 * Constructor.
		 */
		public function XMPPConnection()
		{
			AuthExtension.enable();
			BindExtension.enable();
			SessionExtension.enable();
			RegisterExtension.enable();
			FormExtension.enable();
			PingExtension.enable();
		}

		/**
		 * Remove a SASL mechanism.
		 *
		 * @param	name
		 */
		public static function disableSASLMechanism( name:String ):void
		{
			SASL_MECHANISMS[ name ] = null;
		}

		/**
		 * Add a SASL mechanism.
		 *
		 * @param	name
		 * @param	authClass
		 */
		public static function registerSASLMechanism( name:String, authClass:Class ):void
		{
			SASL_MECHANISMS[ name ] = authClass;
		}

		/**
		 * Changes the user's account password on the server. If the password change is successful,
		 * the class will broadcast a <code>ChangePasswordSuccessEvent.PASSWORD_SUCCESS</code> event.
		 *
		 * @param	password The new password
		 */
		public function changePassword( password:String ):void
		{
			var passwordIQ:IQ = new IQ( new EscapedJID( domain ), IQ.TYPE_SET,
									  IQ.generateID( "pswd_change_" ), changePassword_response );
			var ext:RegisterExtension = new RegisterExtension( passwordIQ.xml );

			ext.username = jid.escaped.bareJID;
			ext.password = password;

			passwordIQ.addExtension( ext );
			send( passwordIQ );
		}

		/**
		 * Connects to the server. Use one of the STREAM_TYPE_.. constants.
		 * Possible options are:
		 * <ul>
		 * <li>standard (default)</li>
		 * <li>standard terminated</li>
		 * <li>flash</li>
		 * <li>flash terminated</li>
		 * </ul>
		 * Some servers, like Jabber, Inc.'s XCP and Jabberd 1.4 expect &lt;flash:stream&gt; from
		 * a Flash client instead of the standard &lt;stream:stream&gt;.
		 *
		 * @param	streamType Any of the STREAM_TYPE_.. constants.
		 *
		 * @return A boolean indicating whether the server was found.
		 */
		public function connect( streamType:uint=0 ):Boolean
		{
			createSocket();
			this.streamType = streamType;

			active = false;
			loggedIn = false;

			chooseStreamTags( streamType );

			socket.connect( server, port );
			return true;
		}

		/**
		 * Disconnects from the server if currently connected. After disconnect,
		 * a <code>DisconnectionEvent.DISCONNECT</code> event is broadcast.
		 * @see org.igniterealtime.xiff.events.DisconnectionEvent
		 */
		public function disconnect():void
		{
			if ( isActive() )
			{
				sendXML( closingStreamTag );

				if ( socket && socket.connected )
				{
					socket.close();
				}
				active = false;
				loggedIn = false;

				var disconnectionEvent:DisconnectionEvent = new DisconnectionEvent();
				dispatchEvent( disconnectionEvent );
			}
		}

		/**
		 * Issues a request for the information that must be submitted for registration with the server.
		 * When the data returns, a <code>RegistrationFieldsEvent.REG_FIELDS</code> event is dispatched
		 * containing the requested data.
		 */
		public function getRegistrationFields():void
		{
			var regIQ:IQ = new IQ( new EscapedJID( domain ), IQ.TYPE_GET,
								   IQ.generateID( "reg_info_" ), getRegistrationFields_response );
			regIQ.addExtension( new RegisterExtension( regIQ.xml ) );

			send( regIQ );
		}

		/**
		 * Determines whether the connection with the server is currently active. (Not necessarily logged in.
		 * For login status, use the <code>isLoggedIn()</code> method.)
		 *
		 * @return A boolean indicating whether the connection is active.
		 * @see	org.igniterealtime.xiff.core.XMPPConnection#isLoggedIn
		 */
		public function isActive():Boolean
		{
			return active;
		}

		/**
		 * Determines whether the user is connected and logged into the server.
		 *
		 * @return A boolean indicating whether the user is logged in.
		 * @see	org.igniterealtime.xiff.core.XMPPConnection#isActive
		 */
		public function isLoggedIn():Boolean
		{
			return loggedIn;
		}

		/**
		 * Sends data to the server. If the data to send cannot be serialized properly,
		 * this method throws a <code>SerializeException</code>.
		 *
		 * @param	data The data to send. This must be an instance of a class that implements the ISerializable interface.
		 * @see	org.igniterealtime.xiff.data.ISerializable
		 * @example	The following example sends a basic chat message to the user with the
		 * JID "sideshowbob&#64;springfieldpenitentiary.gov".<br />
		 * <code>var message:Message = new Message( "sideshowbob&#64;springfieldpenitentiary.gov", null, "Hi Bob.",
		 * "<b>Hi Bob.</b>", Message.TYPE_CHAT );
		 * myXMPPConnection.send( message );</code>
		 */
		public function send( data:IXMPPStanza ):void
		{
			if ( isActive() )
			{
				if ( data is IQ )
				{
					var iq:IQ = data as IQ;

					if ( iq.callback != null || iq.errorCallback != null )
					{
						addIQCallbackToPending( iq.id, iq.callback, iq.errorCallback );
					}
				}
				
				sendXML( data.toString() );

			}
		}

		/**
		 * Sends ping to server in order to keep the connection alive.
		 */
		public function sendKeepAlive():void
		{
			if ( pingNotSupported )
			{
				return;
			}

			var iq:IQ = new IQ( new EscapedJID( server ), IQ.TYPE_GET, null, sendKeepAlive_response, sendKeepAlive_error );
			iq.addExtension( new PingExtension() );
			send( iq );
		}

		/**
		 * Registers a new account with the server, sending the registration data as specified in the fieldMap@paramter.
		 *
		 * @param	fieldMap An object map containing the data to use for registration. The map should be composed of
		 * attribute:value pairs for each registration data item.
		 * @param	key (Optional) If a key was passed in the "data" field of the "registrationFields" event,
		 * that key must also be passed here.
		 * required field needed for registration.
		 */
		public function sendRegistrationFields( fieldMap:Object, key:String ):void
		{
			var regIQ:IQ = new IQ( new EscapedJID( domain ), IQ.TYPE_SET,
								   IQ.generateID( "reg_attempt_" ), sendRegistrationFields_response );
			var ext:RegisterExtension = new RegisterExtension( regIQ.xml );

			for ( var i:String in fieldMap )
			{
				ext.setField( i, fieldMap[ i ] );
			}

			if ( key != null )
			{
				ext.key = key;
			}

			regIQ.addExtension( ext );
			send( regIQ );
		}

		/**
		 * @private
		 *
		 * @param	id
		 * @param	callback
		 * @param	errorCallback
		 */
		protected function addIQCallbackToPending( id:String, callback:Function, errorCallback:Function ):void
		{
			pendingIQs[ id ] = { func: callback, errorFunc: errorCallback };
		}

		/**
		 * @private
		 */
		protected function beginAuthentication():void
		{
			if ( auth != null )
			{
				sendXML( auth.request.toXMLString() );
			}
			else
			{
				// We did not have a suitable auth method for this connection.
			}
		}

		/**
		 * Upon being so informed that resource binding is required, the client
		 * MUST bind a resource to the stream by sending to the server an IQ
		 * stanza of type "set" (see IQ Semantics (Section 9.2.3)) containing
		 * data qualified by the 'urn:ietf:params:xml:ns:xmpp-bind' namespace.
		 *
		 * <p>If the client wishes to allow the server to generate the resource
		 * identifier on its behalf, it sends an IQ stanza of type "set" that
		 * contains an empty <bind/> element.</p>
		 *
		 * Client asks server to bind a resource:
		 * <pre>
		 * <iq type='set' id='bind_1'>
		 *  <bind xmlns='urn:ietf:params:xml:ns:xmpp-bind'/>
		 * </iq>
		 * </pre>
		 */
		protected function bindConnection():void
		{
			var bindIQ:IQ = new IQ( null, IQ.TYPE_SET );

			var bindExt:BindExtension = new BindExtension();
			
			if ( resource )
			{
				bindExt.resource = resource;
			}

			bindIQ.addExtension( bindExt );

			bindIQ.callback = bindConnection_response;
			bindIQ.errorCallback = bindConnection_error;

			send( bindIQ );
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function bindConnection_response( iq:IQ ):void
		{
			var bind:BindExtension = iq.getExtension( "bind" ) as BindExtension;
			var jid:EscapedJID = bind.jid;
			
			if (jid != null)
			{
				_resource = jid.unescaped.resource;
				_username = jid.unescaped.node;
				_domain = jid.unescaped.domain;
				
				establishSession();
			}
			else
			{
				dispatchError("bind-failed", "BindExtension came without a JID", null, 401);
			}
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function bindConnection_error( iq:IQ ):void
		{
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function changePassword_response( iq:IQ ):void
		{
			if ( iq.type == IQ.TYPE_RESULT )
			{
				var event:ChangePasswordSuccessEvent = new ChangePasswordSuccessEvent();
				dispatchEvent( event );
			}
			else
			{
				// We weren't expecting this
				dispatchError( "unexpected-request", "Unexpected Request", "wait", 400 );
			}
		}

		/**
		 * @private
		 * Choose the stream start and ending tags based on the given type.
		 *
		 * @param	type	One of the <code>STREAM_TYPE_...</code> constants of this class.
		 */
		protected function chooseStreamTags( type:uint ):void
		{
			openingStreamTag = '<?xml version="1.0" encoding="UTF-8"?>';

			if ( type == STREAM_TYPE_FLASH || type == STREAM_TYPE_FLASH_TERMINATED )
			{
				openingStreamTagSearch = "flash:stream";
				openingStreamTag += '<flash';
				closingStreamTag = '</flash:stream>';
			}
			else
			{
				openingStreamTagSearch = "stream:stream";
				openingStreamTag += '<stream';
				closingStreamTag = '</stream:stream>';
			}

			openingStreamTag += ':stream xmlns="' + XMPPStanza.CLIENT_NAMESPACE + '" ';

			if ( type == STREAM_TYPE_FLASH || type == STREAM_TYPE_FLASH_TERMINATED )
			{
				openingStreamTag += 'xmlns:flash="' + XMPPStanza.NAMESPACE_FLASH + '"';
			}
			else
			{
				openingStreamTag += 'xmlns:stream="' + XMPPStanza.NAMESPACE_STREAM + '"';
			}
			openingStreamTag += ' to="' + domain + '"'
				+ ' xml:lang="' + XMPPStanza.XML_LANG + '"'
				+ ' version="' + XMPPStanza.CLIENT_VERSION + '"';

			if ( type == STREAM_TYPE_FLASH_TERMINATED || type == STREAM_TYPE_STANDARD_TERMINATED )
			{
				openingStreamTag += ' /';
			}

			openingStreamTag += '>';
		}

		/**
		 * @private
		 * Use the authentication which is first in the list (SASL_MECHANISMS) if possible.
		 *
		 * @param	mechanisms
		 * @see #SASL_MECHANISMS
		 */
		protected function configureAuthMechanisms( mechanisms:XML ):void
		{
			var AuthClass:Class = null;

			for each ( var mechanism:XML in mechanisms.children() )
			{
				var authName:String = mechanism.toString();
				
				AuthClass = SASL_MECHANISMS[ authName ];

				if ( useAnonymousLogin )
				{
					if ( AuthClass == Anonymous )
					{
						break;
					}
				}
				else
				{
					if ( AuthClass != Anonymous && AuthClass != null )
					{
						break;
					}
				}
			}

			if ( AuthClass == null )
			{
				dispatchError( "sasl-missing", "The server is not configured to support any available SASL mechanisms", "SASL", -1 );
			}
			else
			{
				auth = new AuthClass( this );
			}
		}

		/**
		 * <p>Ask the server to enable Zlib compression of the stream.</p>
		 * <p>Supported types in XMPP are <code>zlib</code> and <code>lzw</code>.
		 * XIFF however only supports <code>zlib</code> and only after the Adler32 checksum is somehow implemented.</p>
		 *
		 * <p>Flash Player code named "Dolores" (second half of 2012) might have LZMA ByteArray compression available...</p>
		 * @see http://www.adobe.com/devnet/flashplatform/whitepapers/roadmap.html
		 * @see http://xmpp.org/registrar/compress.html
		 */
		protected function configureStreamCompression( method:String = "zlib" ):void
		{
			var ask:String = "<compress xmlns='http://jabber.org/protocol/compress'><method>" + method + "</method></compress>";
			sendXML( ask );
		}

		/**
		 * @private
		 *
		 * @see flash.net.Socket
		 */
		protected function createSocket():void
		{
			socket = new Socket();
			socket.addEventListener( Event.CLOSE, onSocketClosed );
			socket.addEventListener( Event.CONNECT, onSocketConnected );
			socket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketDataReceived );
			socket.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
		}

		/**
		 * dispatchError("bind-failed", "BindExtension came without a JID", null, 401);
		 *
		 * @param	condition
		 * @param	message
		 * @param	type
		 * @param	code Legacy code
		 * @param	extension
		 */
		protected function dispatchError( condition:String, message:String, type:String, code:int = NaN, extension:Extension=null ):void
		{
			var event:XIFFErrorEvent = new XIFFErrorEvent();
			event.errorCondition = condition;
			event.errorMessage = message;
			event.errorType = type;
			event.errorCode = code;
			event.errorExt = extension;
			dispatchEvent( event );
		}

		/**
		 * @private
		 */
		protected function establishSession():void
		{
			var iq:IQ = new IQ( null, IQ.TYPE_SET );

			iq.addExtension( new SessionExtension() );

			iq.callback = establishSession_response;
			iq.errorCallback = establishSession_error;

			send( iq );
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function establishSession_response( iq:IQ ):void
		{
			dispatchEvent( new LoginEvent() );
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function establishSession_error( iq:IQ ):void
		{
		}

		/**
		 * @private
		 *
		 * @param	event
		 */
		protected function flushPresenceQueue( event:TimerEvent ):void
		{
			if ( presenceQueue.length > 0 )
			{
				var presenceEvent:PresenceEvent = new PresenceEvent();
				presenceEvent.data = presenceQueue;
				dispatchEvent( presenceEvent );
				presenceQueue = [];
			}
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function getRegistrationFields_response( iq:IQ ):void
		{
			try
			{
				var ext:RegisterExtension = iq.getAllExtensionsByNS( RegisterExtension.NS )[ 0 ];
				var fields:Array = ext.getRequiredFieldNames(); //TODO: Phase this out

				var event:RegistrationFieldsEvent = new RegistrationFieldsEvent();
				event.fields = fields;
				event.data = ext;

				dispatchEvent( event );
			}
			catch( err:Error )
			{
				trace( err.getStackTrace() );
			}
		}

		/**
		 * Upon receiving a success indication within the SASL negotiation, the
		 * client MUST send a new stream header to the server, to which the
		 * server MUST respond with a stream header as well as a list of
		 * available stream features.
		 *
		 * @param	response
		 */
		protected function handleAuthentication( response:XML ):void
		{
			var status:Object = auth.handleResponse( 0, response );

			if ( status.authComplete )
			{
				if ( status.authSuccess )
				{
					loggedIn = true;
					restartStream();
				}
				else
				{
					// ? dispatchError( "not-authorized", "Not Authorized", "auth", 401 );
					dispatchError( "not-authorized", "Authentication Error", "", 401 );
					disconnect();
				}
			}
		}

		/**
		 * @private
		 *
		 * @param	challenge
		 */
		protected function handleChallenge( challenge:XML ):void
		{
			var response:XML = auth.handleChallenge( 0, XML( challenge.toString() ) );
			sendXML( response.toXMLString() );
		}

		/**
		 * @private
		 *
		 * @param	node
		 */
		protected function handleIQ( node:XML ):IQ
		{
			var iq:IQ = new IQ( null, null, "temp" );
			iq.xml = node;

			// If it's an error, handle it
			var callbackInfo:Object;

			// Start the callback for this IQ if one exists
			if ( pendingIQs[ iq.id ] !== undefined )
			{
				callbackInfo = pendingIQs[ iq.id ];

				if ( callbackInfo.func != null && iq.type != IQ.TYPE_ERROR)
				{
					callbackInfo.func( iq );
				}
				else if ( callbackInfo.errorFunc != null )
				{
					callbackInfo.errorFunc( iq );
				}
				pendingIQs[ iq.id ] = null;
				delete pendingIQs[ iq.id ];
			}
				
			// Before XML migration, the IQEvent was only triggered if there was no error and no callback.
			if ( iq.type == IQ.TYPE_ERROR )
			{
				dispatchError( iq.errorCondition, iq.errorMessage, iq.errorType, iq.errorCode );
			}
			else
			{
				var exts:Array = iq.getAllExtensions();
				var len:uint = exts.length;

				for ( var i:uint = 0; i < len; ++i )
				{
					// Static type casting
					var ext:IExtension = exts[ i ] as IExtension;

					if ( ext != null )
					{
						var iqEvent:IQEvent = new IQEvent( ext.getNS() );
						iqEvent.data = ext;
						iqEvent.iq = iq;
						dispatchEvent( iqEvent );
					}
				}
			}
			
			return iq;
		}

		/**
		 * @private
		 *
		 * @param	node
		 */
		protected function handleMessage( node:XML ):Message
		{
			trace(getTimer() + " - handleMessage. node: " + node.toXMLString());
			
			var message:Message = new Message();
			message.xml = node;

			// ADDED in error handling for messages
			if ( message.type == Message.TYPE_ERROR )
			{
				var exts:Array = message.getAllExtensions();
				dispatchError( message.errorCondition, message.errorMessage,
							   message.errorType, message.errorCode, exts.length > 0 ? exts[ 0 ] : null );
			}
			else
			{
				var messageEvent:MessageEvent = new MessageEvent();
				messageEvent.data = message;
				dispatchEvent( messageEvent );
			}
			return message;
		}

		/**
		 * @private
		 * Calls a appropriate parser base on the nodeName.
		 *
		 * @param	node
		 */
		protected function handleNodeType( node:XML ):void
		{
			var nodeName:String = String(node.localName()).toLowerCase();
			
			trace(getTimer() + " - handleNodeType. nodeName: " + nodeName);

			switch( nodeName )
			{
				case "stream":
					expireTagSearch = false;
					handleStream( node );
					break;

				case "error":
					handleStreamError( node );
					break;

				case "features":
					handleStreamFeatures( node );
					break;

				case "iq":
					handleIQ( node );
					break;

				case "message":
					handleMessage( node );
					break;

				case "presence":
					handlePresence( node );
					break;

				case "challenge":
					handleChallenge( node );
					break;

				case "success":
					handleAuthentication( node );
					break;

				case "compressed":
					// This states that the other side has accepted to use compression.
					// Now the connection needs to be reopened.
					compressionNegotiated = true;
					restartStream();
					break;

				case "failure":
					// Authentication failed.
					// Might be also that the requested compression method is not available.
					handleAuthentication( node );
					break;

				default:
					// silently ignore lack of or unknown stanzas
					// if the app designer wishes to handle raw data they
					// can do it on "incomingData" event

					// Use case: received null byte, XMLSocket parses empty document
					// sends empty document

					// I am enabling this for debugging. Who?
					dispatchError( "undefined-condition", "Unknown Error", "modify", 500 );
					break;
			}
		}

		/**
		 * @private
		 *
		 * @param	node
		 */
		protected function handlePresence( node:XML ):Presence
		{
			if ( !presenceQueueTimer )
			{
				presenceQueueTimer = new Timer( 1, 1 );
				presenceQueueTimer.addEventListener( TimerEvent.TIMER_COMPLETE, flushPresenceQueue );
			}

			var presence:Presence = new Presence();
			presence.xml = node;
			

			if ( queuePresences )
			{
				presenceQueue.push( presence );

				presenceQueueTimer.reset();
				presenceQueueTimer.start();
			}
			else
			{
				var presenceEvent:PresenceEvent = new PresenceEvent();
				presenceEvent.data = [ presence ];
				dispatchEvent( presenceEvent );
			}

			return presence;
		}

		/**
		 * @private
		 *
		 * @param	node
		 */
		protected function handleStream( node:XML ):void
		{
			sessionID = node.@id;
			domain = node.@from;

			for each ( var child:XML in node.children() )
			{
				if ( child.localName() == "features" )
				{
					handleStreamFeatures( child );
				}
			}
		}

		/**
		 * Handle stream error related element.
		 *
		 * RFC 3920 (XMPP Core, published October 2004),
		 * in chapters 4.7. defines Stream Errors:
		 *
		 * MUST contain a child element corresponding to one of the defined
		 * stanza error conditions defined below; this element MUST be
		 * qualified by the 'urn:ietf:params:xml:ns:xmpp-streams' namespace.
		 *
		 * MAY contain a <text/> child containing XML character data that
		 * describes the error in more detail; this element MUST be qualified
		 * by the 'urn:ietf:params:xml:ns:xmpp-streams' namespace and SHOULD
		 * possess an 'xml:lang' attribute specifying the natural language of
		 * the XML character data.
		 *
		 * @param	node Error node
		 * @see http://xmpp.org/protocols/urn_ietf_params_xml_ns_xmpp-streams/
		 * @see http://www.ietf.org/rfc/rfc3920.txt
		 */
		protected function handleStreamError( node:XML ):void
		{
			var errorCondition:String = "service-unavailable";
			if (node.children().length() > 0)
			{
				// Something from section 4.7.3. Defined Conditions
				trace(getTimer() + " - handleStreamError. " + node.children()[0].localName());
				errorCondition = node.children()[0].localName();
			}
			// TODO: There could be other types of errors available...
			dispatchError( errorCondition, "Remote Server Error", "cancel", 502 );

			// Cancel everything by closing connection
			try
			{
				socket.close();
			}
			catch( error:Error )
			{

			}

			active = false;
			loggedIn = false;

			var disconnectionEvent:DisconnectionEvent = new DisconnectionEvent();
			dispatchEvent( disconnectionEvent );
		}

		/**
		 * Handle features that are available in the connected server.
		 *
		 * <table>
		 * <tbody>
		 * <tr>
		 * <th>Feature</th>
		 * <th>XML Element</th>
		 * <th>Description</th>
		 * <th>Documentation</th>
		 * </tr>
		 * <tr>
		 * <td>amp</td>
		 * <td>&lt;amp xmlns='http://jabber.org/features/amp'&gt;</td><td>Support for Advanced Message Processing</td>
		 * <td><a href="http://www.xmpp.org/extensions/xep-0079.html">XEP-0079: Advanced Message Processing</a></td>
		 * </tr>
		 * <tr>
		 * <td>compress</td>
		 * <td>&lt;compression xmlns='http://jabber.org/features/compress'&gt;</td>
		 * <td>Support for Stream Compression</td>
		 * <td><a href="http://www.xmpp.org/extensions/xep-0138.html">XEP-0138: Stream Compression</a></td>
		 * </tr>
		 * <tr>
		 * <td>iq-auth</td>
		 * <td>&lt;auth xmlns='http://jabber.org/features/iq-auth'&gt;</td>
		 * <td>Support for Non-SASL Authentication</td>
		 * <td><a href="http://www.xmpp.org/extensions/xep-0078.html">XEP-0078: Non-SASL Authentication</a></td>
		 * </tr>
		 * <tr>
		 * <td>iq-register</td>
		 * <td>&lt;register xmlns='http://jabber.org/features/iq-register'&gt;</td>
		 * <td>Support for In-Band Registration</td>
		 * <td><a href="http://www.xmpp.org/extensions/xep-0077.html">XEP-0077: In-Band Registration</a></td>
		 * </tr>
		 * <tr>
		 * <td>bind</td>
		 * <td>&lt;bind xmlns='urn:ietf:params:xml:ns:xmpp-bind'&gt;</td>
		 * <td>Support for Resource Binding</td>
		 * <td><a href="http://www.ietf.org/rfc/rfc6120.txt">RFC 6120: XMPP Core</a></td>
		 * </tr>
		 * <tr>
		 * <td>mechanisms</td>
		 * <td>&lt;mechanisms xmlns='urn:ietf:params:xml:ns:xmpp-sasl'&gt;</td>
		 * <td>Support for Simple Authentication and Security Layer (SASL)</td>
		 * <td><a href="http://www.ietf.org/rfc/rfc6120.txt">RFC 6120: XMPP Core</a></td>
		 * </tr>
		 * <tr>
		 * <td>session</td><td>&lt;session xmlns='urn:ietf:params:xml:ns:xmpp-session'&gt;</td>
		 * <td>Support for IM Session Establishment</td>
		 * <td><a href="http://www.ietf.org/rfc/rfc6121.txt">RFC 6121: XMPP IM</a></td>
		 * </tr>
		 * <tr>
		 * <td>starttls</td>
		 * <td>&lt;starttls xmlns='urn:ietf:params:xml:ns:xmpp-tls'&gt;</td>
		 * <td>Support for Transport Layer Security (TLS)</td>
		 * <td><a href="http://www.ietf.org/rfc/rfc6120.txt">RFC 6120: XMPP Core</a></td>
		 * </tr>
		 * <tr>
		 * <td>sm</td>
		 * <td>&lt;sm xmlns='urn:xmpp:sm:3'&gt;</td><td>Support for Stream Management</td>
		 * <td><a href="http://www.xmpp.org/extensions/xep-0198.html">XEP-0198: Stream Management</a></td>
		 * </tr>
		 * </tbody>
		 * </table>
		 *
		 * @param	node
		 *
		 * @see http://xmpp.org/registrar/stream-features.html
		 */
		protected function handleStreamFeatures( node:XML ):void
		{
			if ( !loggedIn )
			{
				for each ( var feature:XML in node.children() )
				{
					var localName:String = feature.localName();
					
					switch (localName)
					{
						case "amp": break;
						case "compression": break;
						case "auth": break;
						case "register": break;
						case "bind": break;
						case "mechanisms": break;
						case "session": break;
						case "starttls": break;
						case "sm": break;
					}
					
					if ( localName == "starttls" )
					{
						handleStreamTLS( feature );
					}
					else if ( localName == "mechanisms" )
					{
						configureAuthMechanisms( feature );
					}
					else if ( localName == "compression" )
					{
						// zlib is the most common and the one which is required to be implemented.
						if ( _compress )
						{
							configureStreamCompression();
						}
					}
				}

				if ( authenticationReady )
				{
					// TODO: Why is the username required here but it is not used at the backend?
					if ( useAnonymousLogin || ( username != null && username.length > 0 ) )
					{
						beginAuthentication();
					}
					else
					{
						getRegistrationFields();
					}
				}
			}
			else
			{
				bindConnection();
			}
		}

		/**
		 * @private
		 *
		 * @param	node The feature containing starttls tag.
		 */
		protected function handleStreamTLS( node:XML ):void
		{
			if ( node.hasOwnProperty("required") )
			{
				// No TLS support yet
				// policy-violation might be more proper condition...
				dispatchError( "tls-required", "The server requires TLS. Please use XMPPTLSConnection.", "cancel", 501 );
				disconnect();
				return;
			}
		}

		/**
		 * @private
		 * This fires the standard dispatchError method. need to add the appropriate error code
		 *
		 * @param	event
		 */
		protected function onIOError( event:IOErrorEvent ):void
		{
			dispatchError( "service-unavailable", "Service Unavailable", "cancel", 503 );
		}

		/**
		 * @private
		 *
		 * @param	event
		 */
		protected function onSecurityError( event:SecurityErrorEvent ):void
		{
			dispatchError( "not-authorized", "Not Authorized", "auth", 401 );
		}

		/**
		 * @private
		 *
		 * @param	event
		 */
		protected function onSocketClosed( event:Event ):void
		{
			active = false;
			loggedIn = false;

			var disconnectionEvent:DisconnectionEvent = new DisconnectionEvent();
			dispatchEvent( disconnectionEvent );
		}

		/**
		 * @private
		 *
		 * @param	event
		 */
		protected function onSocketConnected( event:Event ):void
		{
			active = true;
			sendXML( openingStreamTag );
			var connectionEvent:ConnectionSuccessEvent = new ConnectionSuccessEvent();
			dispatchEvent( connectionEvent );
		}

		/**
		 * @private
		 *
		 * @param	event
		 */
		protected function onSocketDataReceived( event:ProgressEvent ):void
		{
			var bytedata:ByteArray = new ByteArray();
			// The default value of 0 causes all available data to be read.
			socket.readBytes( bytedata );
			parseDataReceived( bytedata );
		}

		/**
		 * @private
		 * Parses the data which the socket just received.
		 * Used to simplify the overrides from classes extending this one.
		 *
		 * @param	bytedata
		 */
		protected function parseDataReceived( bytedata:ByteArray ):void
		{
			// Increase the incoming data counter.
			_incomingBytes += bytedata.length;

			if ( compressionNegotiated )
			{
				bytedata.uncompress();
			}
			bytedata.position = 0;
			var data:String = bytedata.readUTFBytes( bytedata.length );
			
			var rawXML:String = incompleteRawXML + data;
			
			var rawData:ByteArray = new ByteArray();
			rawData.writeUTFBytes( rawXML );

			// data comign in could also be parts of base64 encoded stuff.

			// parseXML is more strict in AS3 so we must check for the presence of flash:stream
			// the unterminated tag should be in the first string of xml data retured from the server
			
			// http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/RegExp.html
			var regExpOpen:RegExp = new RegExp( "<" + openingStreamTagSearch );
			var regExpOpenExec:Object = regExpOpen.exec( rawXML );
			
			var regExpClose:RegExp = new RegExp( closingStreamTag );
			var regExpCloseExec:Object = regExpClose.exec( rawXML );
			
			// Create qualified XML if needed.
			// Anything that is not wrapped to stream:stream will get wrapped to it.
			if ( regExpOpenExec == null )
			{
				rawXML = openingStreamTag + rawXML;
			}
			if ( regExpCloseExec == null )
			{
				// What about when the opening tag is the only, and self closing?
				rawXML = rawXML.concat( closingStreamTag );
			}
			
			var isComplete:Boolean = false;
			var xmlData:XML;

			//error handling to catch incomplete xml strings that have
			//been truncated by the socket
			try
			{
				xmlData = new XML( rawXML );
				isComplete = true;
				incompleteRawXML = '';
			}
			catch( err:Error )
			{
				trace(getTimer() + " - parseDataReceived. err: " + err.message);
			
				//concatenate the raw xml to the previous xml
				incompleteRawXML += data;
			}

			if ( isComplete )
			{
				// Add default namespace which is not usually included in XML from the server
				xmlData.setNamespace(XMLStanza.DEFAULT_NS);
				xmlData.normalize();
				
				var incomingEvent:IncomingDataEvent = new IncomingDataEvent();
				incomingEvent.data = rawData;
				dispatchEvent( incomingEvent );

				var len:uint = xmlData.children().length();

				for ( var i:int = 0; i < len; ++i )
				{
					// Read the data and send it to the appropriate parser
					var currentNode:XML = xmlData.children()[ i ];
					handleNodeType( currentNode );
				}
			}
		}

		/**
		 * @private
		 */
		protected function restartStream():void
		{
			sendXML( openingStreamTag );
		}

		/**
		 * @private
		 */
		private function sendKeepAlive_response( iq:IQ ):void
		{
		}

		/**
		 * @private
		 */
		private function sendKeepAlive_error( iq:IQ ):void
		{
			if( iq.errorType == "cancel" )
			{
				pingNotSupported = true;
			}
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function sendRegistrationFields_response( iq:IQ ):void
		{
			if ( iq.type == IQ.TYPE_RESULT )
			{
				var event:RegistrationSuccessEvent = new RegistrationSuccessEvent();
				dispatchEvent( event );
			}
			else
			{
				// We weren't expecting this
				dispatchError( "unexpected-request", "Unexpected Request", "wait", 400 );
			}
		}

		/**
		 * @private
		 *
		 * @param	data XML that is not always complete for a reason, like sending the closing element
		 */
		protected function sendXML( data:String ):void
		{
			var bytedata:ByteArray = new ByteArray();
			bytedata.writeUTFBytes( data );

			bytedata.position = 0;

			if ( compressionNegotiated )
			{
				bytedata.compress();
				bytedata.position = 0; // maybe not needed.
			}

			if ( socket && socket.connected )
			{
				socket.writeBytes( bytedata, 0, bytedata.length );
				socket.flush();
			}

			_outgoingBytes += bytedata.length;

			var event:OutgoingDataEvent = new OutgoingDataEvent();
			event.data = bytedata;
			dispatchEvent( event );
		}

		/**
		 * Reference to all active connections.
		 */
		public static function get openConnections():Array
		{
			return _openConnections;
		}

		/**
		 * Shall the zlib compression be allowed if the server supports it.
		 * @see http://xmpp.org/extensions/xep-0138.html
		 * @default false
		 */
		public function get compress():Boolean
		{
			return _compress;
		}
		public function set compress( value:Boolean ):void
		{
			_compress = value;
		}

		/**
		 * The XMPP domain to use with the server.
		 * User domain. Used as the server unless <code>server</code> is specifically set to something different.
		 * @exampleText gmail.com
		 */
		public function get domain():String
		{
			if ( !_domain )
			{
				return _server;
			}
			return _domain;
		}
		public function set domain( value:String ):void
		{
			_domain = value;
		}

		/**
		 * Determines whether whitespace will be ignored on incoming XML data.
		 * Behaves the same as <code>XML.ignoreWhitespace</code>
		 */
		public function get ignoreWhitespace():Boolean
		{
			return _ignoreWhitespace;
		}
		public function set ignoreWhitespace( value:Boolean ):void
		{
			_ignoreWhitespace = value;
			XML.ignoreWhitespace = value;
		}

		/**
		 * Get the total count of the received bytes in the current session.
		 * Mainly useful for tracking network traffic.
		 */
		public function get incomingBytes():uint
		{
			return _incomingBytes;
		}

		/**
		 * Gets the fully qualified unescaped JID of the user.
		 * A fully-qualified JID includes the resource. A bare JID does not.
		 * To get the bare JID, use the <code>bareJID</code> property of the UnescapedJID.
		 *
		 * @return The fully qualified unescaped JID
		 * @see	org.igniterealtime.xiff.core.UnescapedJID#bareJID
		 */
		public function get jid():UnescapedJID
		{
			return new UnescapedJID( _username + "@" + _domain + "/" + _resource );
		}

		/**
		 * Get the total count of the bytes sent in the current session.
		 * Mainly useful for tracking network traffic.
		 */
		public function get outgoingBytes():uint
		{
			return _outgoingBytes;
		}

		/**
		 * The password to use when logging in.
		 */
		public function get password():String
		{
			return _password;
		}
		public function set password( value:String ):void
		{
			_password = value;
		}

		/**
		 * The port to use when connecting. The default XMPP port is 5222.
		 */
		public function get port():uint
		{
			return _port;
		}
		public function set port( value:uint ):void
		{
			_port = value;
		}

		/**
		 * Should the connection queue presence events for a small interval so that it can send multiple in a batch?
		 * @default true To maintain original behavior -- has to be explicitly set to false to disable.
		 */
		public function get queuePresences():Boolean
		{
			return _queuePresences;
		}
		public function set queuePresences( value:Boolean ):void
		{
			if ( _queuePresences && !value )
			{
				// if we are disabling queueing, handle all queued presence
				if ( presenceQueueTimer )
				{
					presenceQueueTimer.stop();
				}

				flushPresenceQueue( null );
			}
			_queuePresences = value;
		}

		/**
		 * The resource to use when logging in. A resource is required (defaults to "XIFF") and
		 * allows a user to login using the same account simultaneously (most likely from multiple machines).
		 * Typical examples of the resource include "Home" or "Office" to indicate the user's current location.
		 */
		public function get resource():String
		{
			return _resource;
		}
		public function set resource( value:String ):void
		{
			if ( value.length > 0 )
			{
				_resource = value;
			}
		}

		/**
		 * The XMPP server to use for connection.
		 * Server to connect, could be different of the login/user domain.
		 * @exampleText talk.google.com
		 */
		public function get server():String
		{
			if ( !_server )
			{
				return _domain;
			}
			return _server;
		}
		public function set server( value:String ):void
		{
			_server = value;
		}

		/**
		 * Whether to use anonymous login or not.
		 */
		public function get useAnonymousLogin():Boolean
		{
			return _useAnonymousLogin;
		}
		public function set useAnonymousLogin( value:Boolean ):void
		{
			// Set only if not connected
			if ( !isActive() )
			{
				_useAnonymousLogin = value;
			}
		}

		/**
		 * The username to use for connection. If this property is null when <code>connect()</code> is called,
		 * the class will fetch registration field data rather than attempt to login.
		 */
		public function get username():String
		{
			return _username;
		}
		public function set username( value:String ):void
		{
			_username = value;
		}

		/**
		 * @private
		 * Specifies whether the socket is connected.
		 */
		protected function get active():Boolean
		{
			return _active;
		}
		protected function set active( value:Boolean ):void
		{
			if ( value )
			{
				_openConnections.push( this );
			}
			else
			{
				_openConnections.splice( _openConnections.indexOf( this ), 1 );
			}
			_active = value;
		}

		/**
		 * @private
		 */
		protected function get authenticationReady():Boolean
		{
			// Ready for authentication only after the possible compression
			return ( _compress && compressionNegotiated ) || !_compress;
		}
	}
}
