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
	 * Bidirectional-streams Over Synchronous HTTP (BOSH)
	 * <p>Using BOSH do not prevent your application from respecting
	 * Adobe Flash Player policy file issues. HTTP requests to your
	 * server must be authorized with a crossdomain.xml file
	 * in your webserver root.</p>
	 *
	 * <p>For eJabberd users : if your crossdomain policy file cannot
	 * be served by your server, this issue can be solved with an
	 * Apache proxy redirect so that any automatic Flash/Flex calls
	 * to an URL like http://xmppserver:5280/crossdomain.xml will be
	 * redirected as an URL of your choice such as
	 * http://webserver/crossdomain.xml</p>
	 *
	 * <p>Warning: if you are using BOSH through HTTPS, your crossdomain
	 * policy file must also be served through HTTPS. Your application
	 * (if online) must also be served through HTTPS else you will
	 * have a crossdomain policy issue. This issue can be solved by
	 * using the secure property of the allow-access-from node in the
	 * crossdomain.xml file. But this is not recommended by Adobe.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0124.html
	 * @see http://xmpp.org/extensions/xep-0206.html
	 */
	public class XMPPBOSHConnection extends XMPPConnection implements IXMPPConnection
	{
		/**
		 * @default 1.6
		 */
		public static const BOSH_VERSION:String = "1.6";

		/**
		 *
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
		 * BOSH body element name
		 */
		public static const ELEMENT_NAME:String = "body";

		/**
		 * Keys should match URLRequestMethod constants.
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequestMethod.html
		 */
		private static const HEADERS:Object = {
			"POST": [],
			"GET": [ 'Cache-Control',
					 'no-store',
					 'Cache-Control',
					 'no-cache',
					 'Pragma', 'no-cache' ]
		};

		private var _boshPath:String = "http-bind/";

		private var _hold:uint = 1;

		private var _maxConcurrentRequests:uint = 2;

		private var _secure:Boolean;

		private var _wait:uint = 20;

		/**
		 * Polling interval, in seconds
		 */
		private var _boshPollingInterval:uint = 10;

		/**
		 * Inactivity time, in seconds
		 */
		private var _inactivity:uint;

		private var _isDisconnecting:Boolean = false;

		private var _lastPollTime:Date = null;

		/**
		 * Maximum pausing time, in seconds
		 */
		private var _maxPause:uint;

		private var _pauseEnabled:Boolean = false;

		private var _pollingEnabled:Boolean = false;

		private var _requestCount:int = 0;

		private var _requestQueue:Array = [];

		private var _responseQueue:Array = [];

		private var _responseTimer:Timer;

		/**
		 * Optional, positive integer.
		 */
		private var _rid:uint;

		private var _sid:String;

		private var _streamRestarted:Boolean;

		/**
		 *
		 * @param	secure	Determines which port is used
		 */
		public function XMPPBOSHConnection( secure:Boolean = false ):void
		{
			super();
			this.secure = secure;
			_responseTimer = new Timer( 0.0, 1 );
			_responseTimer.addEventListener( TimerEvent.TIMER_COMPLETE, processResponse );
		}

		override public function connect( streamType:uint = 0 ):Boolean
		{
			var attrs:Object = {
				"xml:lang": XMPPStanza.XML_LANG,
				"xmlns": XMPPBOSHConnection.BOSH_NS,
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
			for (var key:String in attrs)
			{
				if (attrs.hasOwnProperty(key))
				{
					result.@[ key ] = attrs[ key ];
				}
			}

			sendRequests( result );

			return true;
		}

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
		 *
		 * @param	responseBody
		 */
		public function processConnectionResponse( responseBody:XML ):void
		{
			dispatchEvent( new ConnectionSuccessEvent() );

			_sid = responseBody.@sid;
			wait = responseBody.@wait;

			if ( responseBody.hasOwnProperty("@polling") )
			{
				_boshPollingInterval = responseBody.@polling;
			}
			if ( responseBody.hasOwnProperty("@inactivity") )
			{
				_inactivity = responseBody.@inactivity;
			}
			if ( responseBody.hasOwnProperty("@maxpause") )
			{
				_maxPause = responseBody.@maxpause;
				_pauseEnabled = true;
			}
			if ( responseBody.hasOwnProperty("@requests") )
			{
				maxConcurrentRequests = responseBody.@requests;
			}

			trace( "Polling interval: {0}", _boshPollingInterval );
			trace( "inactivity timeout: {0}", _inactivity );
			trace( "Max requests: {0}", maxConcurrentRequests );
			trace( "Max pause: {0}", _maxPause );

			active = true;

			addEventListener( LoginEvent.LOGIN, handleLogin );
		}

		//do nothing, we use polling instead
		override public function sendKeepAlive():void
		{
		}

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

		override protected function sendXML( someData:String ):void
		{
			var thisData:XML;
			thisData = someData as XML;

			sendQueuedRequests( thisData );
		}

		override protected function handleNodeType( node:XML ):void
		{
			super.handleNodeType( node );

			var nodeName:String = String(node.localName()).toLowerCase();

			if( nodeName == "stream:features" )
			{
				_streamRestarted = false; //avoid triggering the old server workaround
			}
		}

		/**
		 *
		 * @param	bodyContent
		 * @return
		 */
		private function createRequest( bodyContent:Array = null ):XML
		{
			var elem:XML = <{ ELEMENT_NAME }/>;
			elem.setNamespace( XMPPBOSHConnection.BOSH_NS );
			elem.@rid = nextRID;
			elem.@sid = _sid;

			if ( bodyContent )
			{
				for each ( var content:XML in bodyContent )
				{
					elem.appendChild( new XML(content.toString()) );
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
		 * TODO: Compression handling
		 * @param	event
		 */
		private function onRequestComplete( event:Event ):void
		{
			var loader:URLLoader = event.target as URLLoader;

			_requestCount--;
			var byteData:ByteArray = loader.data as ByteArray;

			var xmlData:XML = new XML( byteData.readUTFBytes(byteData.length) );

			var incomingEvent:IncomingDataEvent = new IncomingDataEvent();
			incomingEvent.data = byteData;
			dispatchEvent( incomingEvent );

			var bodyNode:XML = xmlData.children()[0];

			if ( _streamRestarted && bodyNode.children().length() == 0)
			{
				_streamRestarted = false;
				bindConnection();
			}

			if ( bodyNode.@type == "terminate" )
			{
				dispatchError( "BOSH Error", bodyNode.@condition, "", -1 );
				active = false;
			}

			if ( bodyNode.@sid && !loggedIn )
			{
				processConnectionResponse( bodyNode );

				var featuresFound:Boolean = false;
				for each ( var child:XML in bodyNode.children() )
				{
					if ( child.localName() == "stream:features" )
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

			for each ( var childNode:XML in bodyNode.children() )
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
			if ( !isActive() || !_pollingEnabled || sendQueuedRequests() || _requestCount > 0 )
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
		 *
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
		private function sendQueuedRequests( body:XML = null ):Boolean
		{
			if ( body )
			{
				_requestQueue.push( body );
			}
			else if ( _requestQueue.length == 0 )
			{
				return false;
			}

			return sendRequests();
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

			if ( !data )
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

			var byteData:ByteArray = new ByteArray();
			byteData.writeUTFBytes(data.toString());

			var event:OutgoingDataEvent = new OutgoingDataEvent();
			event.data = byteData;
			dispatchEvent( event );

			// Compression here if needed ...

			var req:URLRequest = new URLRequest( httpServer );
			req.method = URLRequestMethod.POST;
			req.contentType = "text/xml";
			req.requestHeaders = HEADERS[ req.method ];
			req.data = byteData;

			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onRequestComplete);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(req);

			if ( isPoll )
			{
				_lastPollTime = new Date();
				trace( "Polling" );
			}

			return true;
		}

		/**
		 *
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
		 *
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
		 * Defaults to 2
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
