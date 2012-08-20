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
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	import org.igniterealtime.xiff.core.*;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.events.*;

	/**
	 * XEP-0124: Bidirectional-streams Over Synchronous HTTP (BOSH) and
	 * XEP-0206: XMPP Over BOSH.
	 *
	 * <p>Using BOSH does not prevent your application from respecting
	 * Adobe Flash Player policy file issues. HTTP requests to your
	 * server must be authorized with a <code>crossdomain.xml</code> file
	 * in your webserver root.</p>
	 *
	 * <p>Warning: if you are using BOSH through HTTPS, your crossdomain
	 * policy file must also be served through HTTPS. Your application
	 * (if online) must also be served through HTTPS else you will
	 * have a crossdomain policy issue. This issue can be solved by
	 * using the secure property of the allow-access-from node in the
	 * crossdomain.xml file. But this is not recommended by Adobe.</p>
	 *
	 * <p>If your crossdomain policy file cannot
	 * be served by your server, this issue could be solved with an
	 * Apache proxy redirect so that any automatic Flash/Flex calls
	 * to an URL like <code>http://xmppserver:5280/crossdomain.xml</code> will be
	 * redirected as an URL of your choice such as
	 * <code>http://webserver/crossdomain.xml</code>.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0124.html
	 * @see http://xmpp.org/extensions/xep-0206.html
	 */
	public class XMPPBOSHConnection extends XMPPConnection implements IXMPPConnection
	{
		/**
		 * Current version of the BOSH defined in the XEP and the
		 * version which this class implements.
		 * @default 1.6
		 */
		public static const BOSH_VERSION:String = "1.6";

		/**
		 * Namespace used by BOSH body wrapper
		 */
		public static const BOSH_NS:String = "http://jabber.org/protocol/httpbind";

		/**
		 * The default port as per XMPP specification.
		 * @default 7070
		 */
		public static const HTTP_PORT:uint = 7070;

		/**
		 * The default secure port as per XMPP specification.
		 * @default 7443
		 */
		public static const HTTPS_PORT:uint = 7443;

		/**
		 * BOSH body wrapper element name
		 */
		public static const ELEMENT_NAME:String = "body";

		private var _boshPath:String = "http-bind/";

		/**
		 * Maximum number of requests kept on hold
		 */
		private var _hold:uint = 1;

		/**
		 * Value fecthed from the server
		 */
		private var _maxConcurrentRequests:uint = 2;

		/**
		 * Is the secure port used or not, according to the application developer
		 */
		private var _secure:Boolean;

		/**
		 * Seconds between traffic
		 */
		private var _wait:uint = 20;

		/**
		 * Polling interval, in seconds
		 */
		private var _boshPollingInterval:uint = 10;

		/**
		 * Inactivity time, in seconds
		 */
		private var _inactivity:uint;

		/**
		 * The most recent poll to the server occured at this time
		 */
		private var _lastPollTime:Date = null;

		/**
		 * Maximum pausing time, in seconds
		 */
		private var _maxPause:uint;

		/**
		 * Server had the 'maxpause' attribute in the initial connection
		 * openining element, thus supports pausing the connection.
		 */
		private var _pauseEnabled:Boolean = false;

		/**
		 * Connection is polling at the moment
		 */
		private var _pollingEnabled:Boolean = false;

		/**
		 * Counter for current outgoing requests.
		 * Once a request is being setn, this counter is increased.
		 * Once the request has been succesfuly received by the server,
		 * this value is degreased.
		 */
		private var _requestCount:int = 0;

		/**
		 * Outgoing XML requests
		 */
		private var _requestQueue:Array = []; // XML

		/**
		 * Incoming XML responses
		 */
		private var _responseQueue:Array = []; // XML

		/**
		 * Timer that triggers <code>processResponse</code> handler.
		 */
		private var _responseTimer:Timer;

		/**
		 * Optional, positive integer.
		 */
		private var _rid:uint;

		/**
		 * Session ID, as defined by the server
		 */
		private var _sid:String;

		/**
		 * Has the stream been restarted by <code>restartStream</code> method.
		 * For some "workaround" reason, <code>handleNodeType</code> has a sole purpose
		 * of setting this to <code>false</code> in case 'features' are available.
		 */
		private var _streamRestarted:Boolean;

		/**
		 * TLS compression (as defined in RFC 3920) and Stream Compression (as defined
		 * in Stream Compression [XEP-0138]) are NOT RECOMMENDED in BOSH since compression
		 * SHOULD be negotiated at the HTTP layer using the 'accept' attribute
		 * of the BOSH session creation response.
		 *
		 * <p>TLS compression and Stream Compression SHOULD NOT be used at
		 * the same time as HTTP content encoding.</p>
		 *
		 * @param	secure	Determines which port is used
		 */
		public function XMPPBOSHConnection( secure:Boolean = false ):void
		{
			super();
			this.secure = secure;
			_responseTimer = new Timer( 0.0, 1 );
			_responseTimer.addEventListener( TimerEvent.TIMER_COMPLETE, processResponse );

			// Default values for super class
			port = XMPPBOSHConnection.HTTP_PORT;
		}

		/**
		 * The first request from the client to the connection manager requests a new session.
		 *
		 * <p>The <strong>body</strong> element of the first request SHOULD possess
		 * the following attributes (they SHOULD NOT be included in any other requests
		 * except as specified under Adding Streams To A Session):</p>
		 *
		 * <ul>
		 * <li>'to' -- This attribute specifies the target domain of the first stream.</li>
		 * <li>'xml:lang' -- This attribute (as defined in Section 2.12 of XML 1.0 [17])
		 *   specifies the default language of any human-readable XML character data
		 *   sent or received during the session.</li>
		 * <li>'ver' -- This attribute specifies the highest version of the BOSH protocol
		 *   that the client supports. The numbering scheme is "major.minor" (where
		 *   the minor number MAY be incremented higher than a single digit, so it
		 *   MUST be treated as a separate integer). Note: The 'ver' attribute should
		 *   not be confused with the version of any protocol being transported.</li>
		 * <li>'wait' -- This attribute specifies the longest time (in seconds) that
		 *   the connection manager is allowed to wait before responding to any request
		 *   during the session. This enables the client to limit the delay before it
		 *   discovers any network failure, and to prevent its HTTP/TCP connection
		 *   from expiring due to inactivity.</li>
		 * <li>'hold' -- This attribute specifies the maximum number of requests the
		 *   connection manager is allowed to keep waiting at any one time during the
		 *   session. If the client is not able to use HTTP Pipelining then this SHOULD
		 *   be set to "1".</li>
		 * </ul>
		 *
		 * <p>Note: Clients that only support Polling Sessions MAY prevent the connection
		 * manager from waiting by setting 'wait' or 'hold' to "0". However, polling is
		 * NOT RECOMMENDED since the associated increase in bandwidth consumption and
		 * the decrease in responsiveness are both typically one or two orders of
		 * magnitude!</p>
		 *
		 * @param	streamType Not used
		 * @see http://xmpp.org/extensions/xep-0206.html#initiate
		 */
		override public function connect( streamType:uint = 0 ):void
		{
			var attrs:Object = {
				"xml:lang": XMPPStanza.XML_LANG,
				"xmlns:xmpp": XMPPStanza.NAMESPACE_BOSH,
				"xmpp:version": XMPPStanza.CLIENT_VERSION,
				"hold": hold,
				"rid": nextRID,
				"secure": secure,
				"wait": wait,
				"ver": BOSH_VERSION,
				"to": domain
			};

			var result:XML = <{ ELEMENT_NAME }/>;
			result.setNamespace(XMPPBOSHConnection.BOSH_NS);

			for (var key:String in attrs)
			{
				if (attrs.hasOwnProperty(key))
				{
					result.@[ key ] = attrs[ key ];
				}
			}

			sendRequests( result );
		}

		/**
		 * @see http://xmpp.org/extensions/xep-0124.html#terminate
		 */
		override public function disconnect():void
		{
			if ( active )
			{
				var data:XML = createRequest();
				data.@type = "terminate";
				sendRequests( data );
				active = false;
				loggedIn = false;
				dispatchEvent( new DisconnectionEvent() );
			}
		}

		/**
		 * @return	true if pause request is sent
		 */
		public function pauseSession( seconds:uint ):Boolean
		{
			trace( "Pausing session for {0} seconds", seconds );

			if ( !_pauseEnabled || seconds > _maxPause || seconds <= _boshPollingInterval )
			{
				return false;
			}

			_pollingEnabled = false;

			var data:XML = createRequest();
			data.@pause = seconds;
			sendRequests( data );

			var pauseTimer:Timer = new Timer( (seconds * 1000) - 2000, 1 );
			pauseTimer.addEventListener( TimerEvent.TIMER, handlePauseTimeout );
			pauseTimer.start();

			return true;
		}

		/**
		 * Session Creation Response
		 *
		 * <p>After receiving a new session request, the connection manager MUST generate
		 * an opaque, unpredictable session identifier (or SID). The SID MUST be unique
		 * within the context of the connection manager application. The <strong>body</strong>
		 * element of the connection manager's response to the client's session creation
		 * request MUST possess the following attributes (they SHOULD NOT be included in
		 * any other responses):</p>
		 *
		 * <ul>
		 * <li>'sid' -- This attribute specifies the SID</li>
		 * <li>'wait' -- This is the longest time (in seconds) that the connection manager
		 *   will wait before responding to any request during the session. The time MUST be
		 *   less than or equal to the value specified in the session request.</li>
		 * </ul>
		 *
		 * <p>The <strong>body</strong> element SHOULD also include the following attributes
		 * (they SHOULD NOT be included in any other responses):</p>
		 *
		 * <ul>
		 * <li>'ver' -- This attribute specifies the highest version of the BOSH protocol
		 *   that the connection manager supports, or the version specified by the client in
		 *   its request, whichever is lower.</li>
		 * <li>'polling' -- This attribute specifies the shortest allowable polling
		 *   interval (in seconds). This enables the client to not send empty request
		 *   elements more often than desired (see Polling Sessions and Overactivity).</li>
		 * <li>'inactivity' -- This attribute specifies the longest allowable inactivity
		 *   period (in seconds). This enables the client to ensure that the periods with
		 *   no requests pending are never too long (see Polling Sessions and Inactivity).</li>
		 * <li>'requests' -- This attribute enables the connection manager to limit the
		 *   number of simultaneous requests the client makes (see Overactivity and
		 *   Polling Sessions). The RECOMMENDED values are either "2" or one more than
		 *   the value of the 'hold' attribute specified in the session request.</li>
		 * <li>'hold' -- This attribute informs the client about the maximum number
		 *   of requests the connection manager will keep waiting at any one time during
		 *   the session. This value MUST NOT be greater than the value specified by the
		 *   client in the session request.</li>
		 * <li>'to' -- This attribute communicates the identity of the backend server
		 *   to which the client is attempting to connect.</li>
		 * </ul>
		 *
		 * <p>The connection manager MAY include an 'accept' attribute in the session
		 * creation response element, to specify a space-separated list of the content
		 * encodings it can decompress. After receiving a session creation response
		 * with an 'accept' attribute, clients MAY include an HTTP Content-Encoding
		 * header in subsequent requests (indicating one of the encodings specified
		 * in the 'accept' attribute) and compress the bodies of the requests
		 * accordingly.</p>
		 *
		 * @param	responseBody
		 * @see http://xmpp.org/extensions/xep-0124.html#session-response
		 * @see http://xmpp.org/extensions/xep-0206.html#create
		 */
		public function processConnectionResponse( responseBody:XML ):void
		{
			dispatchEvent( new ConnectionSuccessEvent() );

			_sid = responseBody.@sid;
			wait = parseInt(responseBody.@wait);

			if ( responseBody.hasOwnProperty("@polling") )
			{
				_boshPollingInterval = parseInt(responseBody.@polling);
			}
			if ( responseBody.hasOwnProperty("@inactivity") )
			{
				_inactivity = parseInt(responseBody.@inactivity);
			}
			if ( responseBody.hasOwnProperty("@maxpause") )
			{
				_maxPause = parseInt(responseBody.@maxpause);
				_pauseEnabled = true;
			}
			if ( responseBody.hasOwnProperty("@requests") )
			{
				maxConcurrentRequests = parseInt(responseBody.@requests);
			}

			trace( "Polling interval: {0}", _boshPollingInterval );
			trace( "inactivity timeout: {0}", _inactivity );
			trace( "Max requests: {0}", maxConcurrentRequests );
			trace( "Max pause: {0}", _maxPause );

			active = true;

			addEventListener( LoginEvent.LOGIN, handleLogin );
		}

		/**
		 * Does nothing, BOSH uses polling instead.
		 */
		override public function sendKeepAlive():void
		{
		}

		/**
		 * Upon receiving the <strong>success</strong> element, the client
		 * MUST then ask the connection manager to restart the stream by
		 * sending a "restart request".
		 */
		override protected function restartStream():void
		{
			var data:XML = createRequest();

			var attrs:Object = {
				"xmpp:restart": "true",
				"xmlns:xmpp": XMPPStanza.NAMESPACE_BOSH,
				"xml:lang": XMPPStanza.XML_LANG,
				"to": domain
			};

			for (var key:String in attrs)
			{
				if (attrs.hasOwnProperty(key))
				{
					data.@[ key ] = attrs[ key ];
				}
			}
			sendRequests( data );
			_streamRestarted = true;
		}

		/**
		 * TODO: Is this somthing that could be safely removed?
		 */
		override protected function handleNodeType( node:XML ):void
		{
			super.handleNodeType( node );

			var nodeName:String = String(node.localName()).toLowerCase();

			if ( nodeName == "features" )
			{
				_streamRestarted = false; //avoid triggering the old server workaround
			}
		}

		/**
		 * Helper method for creating XML which contains the data to be sent to server.
		 *
		 * <p>Also called as "Body wrapper element".</p>
		 *
		 * @param	bodyContent
		 * @return
		 * @see http://xmpp.org/extensions/xep-0124.html#wrapper
		 */
		private function createRequest( bodyContent:Array = null ):XML
		{
			var elem:XML = <{ ELEMENT_NAME }/>;
			elem.setNamespace( XMPPBOSHConnection.BOSH_NS );
			elem.@rid = nextRID;
			elem.@sid = _sid;

			if ( bodyContent )
			{
				var len:uint = bodyContent.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var content:XML = bodyContent[i] as XML;
					elem.appendChild( content );
				}
			}

			return elem;
		}

		/**
		 *
		 * @param	event
		 */
		private function handleLogin( event:LoginEvent ):void
		{
			_pollingEnabled = true;
			pollServer();
		}

		/**
		 *
		 * @param	event
		 */
		private function handlePauseTimeout( event:TimerEvent ):void
		{
			_pollingEnabled = true;
			pollServer();
		}

		/**
		 * Outgoing request has completed.
		 *
		 * <p>If the BOSH <strong>body</strong> wrapper is not empty, then it SHOULD
		 * contain one of the following:</p>
		 *
		 * <ul>
		 * <li>A complete <stream:features/> element (in which case the BOSH <strong>body</strong>
		 * element MUST include the namespace xmlns:stream='http://etherx.jabber.org/streams').</li>
		 * <li>A complete element used for SASL negotiation and qualified by the
		 * 'urn:ietf:params:xml:ns:xmpp-sasl' namespace.</li>
		 * <li>One or more complete <strong>message</strong>, <strong>presence</strong>, and/or
		 * <strong>iq</strong> elements qualified by the 'jabber:client' namespace.</li>
		 * <li>A <stream:error/> element (in which case the BOSH <strong>body</strong> element
		 * MUST include the namespace xmlns:stream='http://etherx.jabber.org/streams' and it MUST
		 * feature the 'remote-stream-error' terminal error condition), preceded by zero or more
		 * complete <strong>message</strong>, <strong>presence</strong>, and/or <strong>iq</strong>
		 * elements qualified by the 'jabber:client' namespace.</li>
		 * </ul>
		 *
		 * @param	event
		 */
		private function onRequestComplete( event:Event ):void
		{
			var loader:URLLoader = event.target as URLLoader;

			_requestCount--;
			var byteData:ByteArray = loader.data as ByteArray;

			_incomingBytes += byteData.length;

			var strData:String = byteData.readUTFBytes(byteData.length);
			trace("onRequestComplete. strData: " + strData);

			var xmlData:XML = new XML( strData );

			var incomingEvent:IncomingDataEvent = new IncomingDataEvent();
			incomingEvent.data = byteData;
			dispatchEvent( incomingEvent );

			if ( _streamRestarted && xmlData.children().length() == 0)
			{
				_streamRestarted = false;
				bindConnection();
			}

			// TODO: Error handling... http://xmpp.org/extensions/xep-0124.html#errorstatus
			if ( xmlData.@type == "terminate" && xmlData.hasOwnProperty("@condition") )
			{
				/*
				@condition can be:
				 bad-request
				 policy-violation
				 item-not-found

				 see-other-uri --> uri element

				In case there is no condition, the "terminate" was not due to an error.
				*/
				dispatchError( xmlData.@condition, "BOSH Error", "" );
				active = false;
			}

			// sid is supposed to be only available when creating a new session
			// http://xmpp.org/extensions/xep-0206.html#create
			if ( xmlData.hasOwnProperty("@sid") && !loggedIn )
			{
				processConnectionResponse( xmlData );

				var featuresFound:Boolean = false;
				for each ( var child:XML in xmlData.children() )
				{
					if ( child.localName() == "features" )
					{
						featuresFound = true;
					}
				}
				if ( !featuresFound )
				{
					_pollingEnabled = true;
					pollServer();
				}
			}

			for each ( var childNode:XML in xmlData.children() )
			{
				_responseQueue.push( childNode );
			}

			resetResponseProcessor();
			// if there are no nodes in the response queue, then the response processor won't run and we won't send a poll to the server.
			// so, do it manually here.
			if ( _responseQueue.length == 0 )
			{
				pollServer();
			}
		}

		/**
		 *
		 */
		private function pollServer():void
		{
			/*
			 * We shouldn't poll if the connection is dead, if we had requests
			 * to send instead, or if there's already one in progress
			 */
			if ( !active || !_pollingEnabled || sendQueuedRequests() || _requestCount > 0 )
			{
				return;
			}

			/*
			 * this should be safe since sendRequests checks to be sure it's not
			 * over the concurrent requests limit, and we just ensured that the queue
			 * is empty by calling sendQueuedRequests()
			 */
			sendRequests( null, true );
		}

		/**
		 *
		 * @param	event
		 */
		private function processResponse( event:TimerEvent = null ):void
		{
			// Read the data and send it to the appropriate parser
			var currentNode:XML = _responseQueue.shift() as XML;

			handleNodeType( currentNode );

			resetResponseProcessor();

			//if we have no outstanding requests, then we're free to send a poll at the next opportunity
			if ( _requestCount == 0 && !sendQueuedRequests())
			{
				pollServer();
			}
		}

		/**
		 * Reset the response time if there are items in the queue
		 */
		private function resetResponseProcessor():void
		{
			if ( _responseQueue.length > 0 )
			{
				_responseTimer.reset();
				_responseTimer.start();
			}
		}

		/**
		 *
		 * @param	body
		 * @return
		 */
		private function sendQueuedRequests( data:String = null ):Boolean
		{
			if ( data != null )
			{
				var body:XML = new XML(data);
				_requestQueue.push( body );
			}
			else if ( _requestQueue.length == 0 )
			{
				return false;
			}

			return sendRequests();
		}

		/**
		 * Pass through to <code>sendRequests</code> method for having the
		 * <code>body</code> wrapper around the given data.
		 * @param	data
		 */
		override protected function sendXML( data:String ):void
		{
			sendQueuedRequests( data );
		}

		/**
		 * Returns true if any requests were sent.
		 *
		 * TODO: Handle compression
		 *
		 * @param	data
		 * @param	isPoll
		 * @return
		 */
		private function sendRequests( data:XML = null, isPoll:Boolean = false ):Boolean
		{
			if ( _requestCount >= maxConcurrentRequests )
			{
				return false;
			}

			_requestCount++;

			if ( data == null )
			{
				if ( isPoll )
				{
					data = createRequest();
				}
				else
				{
					var requests:Array = [];
					var len:uint = Math.min( 10, _requestQueue.length ); // ten or less
					for ( var i:uint = 0; i < len; ++i )
					{
						requests.push( _requestQueue.shift() );
					}
					data = createRequest( requests );
				}
			}
			trace("sendRequests. data: " + data.toXMLString());


			// Dispatch OutgoingDataEvent, calls sendDataToServer.
			sendData(data.toXMLString());


			if ( isPoll )
			{
				_lastPollTime = new Date();
				trace( "Polling" );
			}
			return true;
		}

		/**
		 * Connection to the server in BOSH is a simple URLRequest.
		 *
		 * <p>All information is encoded in the body of standard HTTP POST
		 * requests and responses. Each HTTP body contains a single
		 * <strong>body</strong> wrapper which encapsulates the XML elements
		 * being transferred.</p>
		 *
		 * <p>BOSH requires all incoming and outgoing data to be wrapped in
		 * <code>body</code> element. That should be taken care of before possible
		 * Stream Compression.</p>
		 *
		 * @param	data ByteArray that might be compressed if enabled
		 * @see http://xmpp.org/extensions/xep-0124.html#overview
		 */
		override protected function sendDataToServer( data:ByteArray ):void
		{
			trace("XMPPBOSHConnection::sendDataToServer. httpServer: " + httpServer);

			var req:URLRequest = new URLRequest( httpServer );
			req.method = URLRequestMethod.POST;
			req.contentType = "text/xml";
			req.data = data;

			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onRequestComplete);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.load(req);
		}

		private function onHTTPStatus(event:HTTPStatusEvent):void
		{
			trace("onHTTPStatus. " + event.toString());
			trace("onHTTPStatus. status: " + event.status);

		}

		/**
		 * Local part of the address in which the server responds.
		 * @default http-bind/
		 */
		public function get boshPath():String
		{
			return _boshPath;
		}
		public function set boshPath( value:String ):void
		{
			_boshPath = value;
		}

		/**
		 * Request ID
		 */
		private function get nextRID():uint
		{
			if ( !_rid )
			{
				_rid = Math.floor( Math.random() * 1000000 + 10 );
			}
			return ++_rid;
		}

		/**
		 * This attribute specifies the longest time (in seconds) that the connection
		 * manager is allowed to wait before responding to any request during the session.
		 * This enables the client to limit the delay before it discovers any network
		 * failure, and to prevent its HTTP/TCP connection from expiring due to inactivity.
		 */
		public function get wait():uint
		{
			return _wait;
		}
		public function set wait( value:uint ):void
		{
			_wait = value;
		}

		/**
		 * HTTP bind requests type. If secure, the requests will be sent
		 * through HTTPS. If not, through HTTP.
		 *
		 * <p>Please note that the <code>port</code> needs to be set separately.</p>
		 */
		public function get secure():Boolean
		{
			return _secure;
		}
		public function set secure( value:Boolean ):void
		{
			_secure = value;
		}

		/**
		 * This attribute specifies the maximum number of requests the connection
		 * manager is allowed to keep waiting at any one time during the session.
		 * If the client is not able to use HTTP Pipelining then this SHOULD be set to "1".
		 */
		public function get hold():uint
		{
			return _hold;
		}
		public function set hold( value:uint ):void
		{
			_hold = value;
		}

		/**
		 * Server URI
		 */
		public function get httpServer():String
		{
			return ( secure ? "https" : "http" ) + "://" +
				server + ":" + port + "/" + boshPath;
		}

		/**
		 * Defaults to 2. Value retrieved from the server once stream is initiating.
		 */
		public function get maxConcurrentRequests():uint
		{
			return _maxConcurrentRequests;
		}
		public function set maxConcurrentRequests( value:uint ):void
		{
			_maxConcurrentRequests = value;
		}
	}
}
