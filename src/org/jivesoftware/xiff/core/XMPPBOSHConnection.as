package org.jivesoftware.xiff.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.logging.ILogger;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.jivesoftware.xiff.auth.Anonymous;
	import org.jivesoftware.xiff.auth.External;
	import org.jivesoftware.xiff.auth.Plain;
	import org.jivesoftware.xiff.auth.SASLAuth;
	import org.jivesoftware.xiff.data.IQ;
	import org.jivesoftware.xiff.data.bind.BindExtension;
	import org.jivesoftware.xiff.data.session.SessionExtension;
	import org.jivesoftware.xiff.events.ConnectionSuccessEvent;
	import org.jivesoftware.xiff.events.IncomingDataEvent;
	import org.jivesoftware.xiff.events.LoginEvent;
	import org.jivesoftware.xiff.events.OutgoingDataEvent;
	import org.jivesoftware.xiff.logging.LoggerFactory;
	import org.jivesoftware.xiff.util.Callback;
	
	public class XMPPBOSHConnection extends XMPPConnection
	{
		private static const logger:ILogger = LoggerFactory.getLogger("org.jivesoftware.xiff.core.XMPPBOSHConnection");
		
		private static const HTTP_PORT:int = 7070;
		private static const HTTPS_PORT:int = 7443;
		private static const BOSH_VERSION:String = "1.6";
		
		private static const headers:Object = {
			"post": [],
			"get": ['Cache-Control', 'no-store', 'Cache-Control', 'no-cache', 'Pragma', 'no-cache']
		};
		
		private static var saslMechanisms:Object = {
			"PLAIN":Plain,
			"ANONYMOUS":Anonymous,
            "EXTERNAL":External
		};
		
		private const responseTimer:Timer = new Timer(0.0, 1);
		
		private var requestCount:int = 0;
		private var failedRequests:Array = [];
		private var requestQueue:Array = [];
		private var responseQueue:Array = [];
		private var isDisconnecting:Boolean = false;
		private var sid:String;
		private var rid:Number;
		
		private var lastPollTime:Date = null;
		private var pollTimer:Timer = new Timer(1, 1);
		private var pollTimeoutTimer:Timer = new Timer(1, 1);
		
		private var auth:SASLAuth;
		private var authHandler:Function;
		
		private var inactivity:uint;
		private var boshPollingInterval:uint = 10000;
		
		// These attributes can be configured from outside after creating the instance
		private var _secure:Boolean;
		private var _port:Number;
		private var _maxConcurrentRequests:uint;
		private var _hold:uint;
		private var _wait:uint;
		
		public function XMPPBOSHConnection(secure:Boolean = false):void
		{
			super();
			this.secure = secure;
			this.hold = 1;
			this.wait = 30;
			this.maxConcurrentRequests = 2;
			this.boshPollingInterval = 10000;
		}
		
		public override function connect(streamType:String=null):Boolean
		{
			logger.debug("BOSH connect()");
			BindExtension.enable();
			active = false;
			loggedIn = false;
			var attrs:Object = {
				"xml:lang": "en",
	            xmlns: "http://jabber.org/protocol/httpbind",
	            hold: hold,
	            rid: nextRID,
	            secure: secure,
	            wait: wait,
	            ver: BOSH_VERSION,
	            to: domain
	        }
	        
	        var result:XMLNode = new XMLNode(1, "body");
	        result.attributes = attrs;
	        sendRequests(result);
	
	        return true;
		}
		
		public static function registerSASLMechanism(name:String, authClass:Class):void
		{
			saslMechanisms[name] = authClass;
		}
		
		public static function disableSASLMechanism(name:String):void
		{
			saslMechanisms[name] = null;
		}
		
		public function set maxConcurrentRequests(value:uint):void
		{
			_maxConcurrentRequests = value;
		}
		
		public function get maxConcurrentRequests():uint
		{
			return _maxConcurrentRequests;
		}
		
		public function set hold(value:uint):void
		{
			_hold = value;
		}
		
		public function get hold():uint
		{
			return _hold;
		}
		
		public function set wait(value:uint):void
		{
			_wait = value;
		}
		
		public function get wait():uint
		{
			return _wait;
		}
		
		public function set secure(flag:Boolean):void
		{
			logger.debug("set secure: {0}", flag);
			_secure = flag;			
			port = _secure ? HTTPS_PORT : HTTP_PORT;
		}
		
		public function get secure():Boolean
		{
			return _secure;
		}
		
		public override function set port(portnum:Number):void
		{
			logger.debug("set port: {0}", portnum);
			_port = portnum;
		}
		
		public override function get port():Number
		{
			return _port;
		}
		
		public function get httpServer():String
		{
			return (secure ? "https" : "http") + "://" + server + ":" + port + "/http-bind/";
		}
		
		public override function disconnect():void
		{
			super.disconnect();
			pollTimer.stop();
			pollTimer = null;
			pollTimeoutTimer.stop();
			pollTimeoutTimer = null;
		}
		
		public function processConnectionResponse(responseBody:XMLNode):void
		{
			var attributes:Object = responseBody.attributes;
			
			sid = attributes.sid;
	        wait = attributes.wait;
	        
	        boshPollingInterval = attributes.polling * 1000;
	        inactivity = attributes.inactivity * 1000;
	        
	        if(inactivity - 2000 >= boshPollingInterval || (boshPollingInterval <= 1000 && boshPollingInterval > 0))
	        {
	        	boshPollingInterval += 1000;
	        }
	        
	        inactivity -= 1000;
	        
	        logger.debug("Polling interval: {0}", boshPollingInterval);
	        logger.debug("Inactivity timeout: {0}", inactivity);
	        
	        var serverRequests:int = attributes.requests;
	        if (serverRequests)
	            maxConcurrentRequests = Math.min(serverRequests, maxConcurrentRequests);
	        active = true;
	        configureConnection(responseBody);
	        responseTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processResponse);
	        pollTimer.delay = boshPollingInterval;
	        pollTimer.addEventListener(TimerEvent.TIMER_COMPLETE, pollServer);
	        pollTimer.start();
	        
	        pollTimeoutTimer.delay = inactivity;
	        pollTimeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(evt:TimerEvent):void {
				logger.debug("Poll timed out, resuming");
				pollServer(evt, true);
			});
		}
		
		private function processResponse(event:TimerEvent=null):void
		{
			// Read the data and send it to the appropriate parser
			var currentNode:XMLNode = responseQueue.shift();
			var nodeName:String = currentNode.nodeName.toLowerCase();
			
			switch( nodeName )
			{
				case "stream:features":
					//we already handled this in httpResponse()
					break;
								
				case "stream:error":
					handleStreamError( currentNode );
					break;
					
				case "iq":
					handleIQ( currentNode );
					break;
					
				case "message":
					handleMessage( currentNode );
					break;
					
				case "presence":
					handlePresence( currentNode );
					break;
					
				case "success":
					handleAuthentication( currentNode );
					break;

				case "failure":
					handleAuthentication( currentNode );
					break;
				default:
					dispatchError( "undefined-condition", "Unknown Error", "modify", 500 );
					break;
			}
			
			resetResponseProcessor();
		}
		
		private function resetResponseProcessor():void
		{
			if(responseQueue.length > 0)
			{
				responseTimer.reset();
				responseTimer.start();
			}
		}

		private function httpResponse(req:XMLNode, isPollResponse:Boolean, evt:ResultEvent):void
		{
			requestCount--;
			var rawXML:String = evt.result as String;
			
			logger.info("INCOMING {0}", rawXML);
			
			var xmlData:XMLDocument = new XMLDocument();
			xmlData.ignoreWhite = this.ignoreWhite;
			xmlData.parseXML(rawXML);
			var bodyNode:XMLNode = xmlData.firstChild;
			
			var event:IncomingDataEvent = new IncomingDataEvent();
			event.data = xmlData;
			dispatchEvent(event);
			
			if(bodyNode.attributes["type"] == "terminate")
			{
				dispatchError("BOSH Error", bodyNode.attributes["condition"], "", -1);
				active = false;
			}
			
			for each(var childNode:XMLNode in bodyNode.childNodes)
			{
				if(childNode.nodeName == "stream:features")
				{
					_expireTagSearch = false;
					processConnectionResponse(bodyNode);
				}
				else
					responseQueue.push(childNode);
			}
			
			resetResponseProcessor();
			
			//if we have no outstanding requests, then we're free to send a poll at the next opportunity
			if(requestCount == 0 && !sendQueuedRequests())
				resetPollTimer();
		}
		
		private function httpError(req:XMLNode, isPollResponse:Boolean, evt:FaultEvent):void
		{
			disconnect();
			dispatchError("Unknown HTTP Error", evt.fault.rootCause.text, "", -1);
		}
		
		protected override function sendXML(body:*):void
		{
			sendQueuedRequests(body);
		}
		
		private function sendQueuedRequests(body:*=null):Boolean
		{
			if(body)
				requestQueue.push(body);
			else if(requestQueue.length == 0)
				return false;
				
			return sendRequests();
		}
		
		//returns true if any requests were sent
		private function sendRequests(data:XMLNode = null, isPoll:Boolean = false):Boolean
		{
			if(requestCount >= maxConcurrentRequests)
				return false;
			
			requestCount++;
			
			if(!data)
			{
				if(isPoll)
				{
					data = createRequest();
				}
				else
				{
					var temp:Array = [];
					for(var i:uint = 0; i < 10 && requestQueue.length > 0; i++)
					{
						temp.push(requestQueue.shift());
					}
					data = createRequest(temp);
				}
			}
			
			//build the http request
	        var request:HTTPService = new HTTPService();
	        request.method = "post";
	        request.headers = headers[request.method];
	        request.url = httpServer;
	        request.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
	        request.contentType = "text/xml";
	        
	        var responseCallback:Callback = new Callback(this, httpResponse, data, isPoll);
	        var errorCallback:Callback = new Callback(this, httpError, data, isPoll);
	        
	        request.addEventListener(ResultEvent.RESULT, responseCallback.call, false);
	        request.addEventListener(FaultEvent.FAULT, errorCallback.call, false);
	       
	       	logger.info("OUTGOING {0}", data);
	       
			request.send(data);

			var event:OutgoingDataEvent = new OutgoingDataEvent();
			event.data = data;
			dispatchEvent(event);
			
			if(isPoll) {
				lastPollTime = new Date();
				pollTimeoutTimer.reset();
				pollTimeoutTimer.start();
				logger.info("Polling");
			}
			
			pollTimer.stop();
			
			return true;
		}
    	
    	private function resetPollTimer():void 
    	{
    		if(!pollTimer)
    			return;

    		pollTimeoutTimer.stop();
    		
    		pollTimer.reset();
    		var timeSinceLastPoll:Number = 0;
    		if(lastPollTime)
    			 timeSinceLastPoll = new Date().time - lastPollTime.time;
    			
    		if(timeSinceLastPoll >= boshPollingInterval)
    			timeSinceLastPoll = 0;
    		
    		pollTimer.delay = boshPollingInterval - timeSinceLastPoll;
    		pollTimer.start();
    	}
    	
    	private function pollServer(evt:TimerEvent, force:Boolean=false):void 
    	{
    		if(force)
    			logger.warn("Forcing poll!");
    		//We shouldn't poll if the connection is dead, if we had requests to send instead, or if there's already one in progress
    		if(!isActive() || ((sendQueuedRequests() || requestCount > 0) && !force))
    			return;
    		
    		//this should be safe since sendRequests checks to be sure it's not over the concurrent requests limit, and we just ensured that the queue is empty by calling sendQueuedRequests()
    		sendRequests(null, true);
    	}
    	
    	private function get nextRID():Number {
    		if(!rid)
    			rid = Math.floor(Math.random() * 1000000);
    		return ++rid;
    	}
    	
    	private function createRequest(bodyContent:Array=null):XMLNode {
    		var attrs:Object = {
    			xmlns: "http://jabber.org/protocol/httpbind",
				rid: nextRID,
				sid: sid
    		}
    		var req:XMLNode = new XMLNode(1, "body");
    		if(bodyContent)
    			for each(var content:XMLNode in bodyContent)
    					req.appendChild(content);
    		
    		req.attributes = attrs;
    		
    		return req;
    	}
	    
	    private function handleAuthentication(responseBody:XMLNode):void
	    {
	        var status:Object = auth.handleResponse(0, responseBody);
	        if (status.authComplete) {
	            if (status.authSuccess) {
	                bindConnection();
	            }
	            else {
					dispatchError("Authentication Error", "", "", 401);
	                disconnect();
	            }
	        }
	    }
	    
	    private function configureConnection(responseBody:XMLNode):void
	    {
	    	var features:XMLNode = responseBody.firstChild;
	
	        var authentication:Object = {};
	        for each(var feature:XMLNode in features.childNodes)
			{
	            if (feature.nodeName == "mechanisms")
	                authentication.auth = configureAuthMechanisms(feature);
	            else if (feature.nodeName == "bind")
	                authentication.bind = true;
	            else if (feature.nodeName == "session")
	                authentication.session = true;
	        }
	        
	        auth = authentication.auth;
	        dispatchEvent(new ConnectionSuccessEvent());
	        authHandler = handleAuthentication;
	        sendXML(auth.request);
	    }
	    
	    private function configureAuthMechanisms(mechanisms:XMLNode):SASLAuth
	    {
	        var authMechanism:SASLAuth;
	        var authClass:Class;
	        for each(var mechanism:XMLNode in mechanisms.childNodes) 
	        {
	        	authClass = saslMechanisms[mechanism.firstChild.nodeValue];
	   			if(authClass)
	   				break;
	        }
	
	        if (!authClass) {
	        	dispatchError("SASL missing", "The server is not configured to support any available SASL mechanisms", "SASL", -1);
	        	return null;
	        }
	
	   		return new authClass(this);
	    }
	    
	    public function handleBindResponse(packet:IQ):void
	    {
	    	logger.debug("handleBindResponse: {0}", packet.getNode());
	    	var bind:BindExtension = packet.getExtension("bind") as BindExtension;
	
            var jid:UnescapedJID = bind.jid.unescaped;
            
            myResource = jid.resource;
            myUsername = jid.node;
            domain = jid.domain;
            
            establishSession();
	    }
	    
	    private function bindConnection():void 
	    {
	    	var bindIQ:IQ = new IQ(null, "set");
	
			var bindExt:BindExtension = new BindExtension();
			if(resource)
	        	bindExt.resource = resource;
	        
	        bindIQ.addExtension(bindExt);
	        
			bindIQ.callback = handleBindResponse;
			bindIQ.callbackScope = this;
	
	        send(bindIQ);
	    }
	    
	    public function handleSessionResponse(packet:IQ):void
	    {
	    	logger.debug("handleSessionResponse: {0}", packet.getNode());
	    	dispatchEvent(new LoginEvent());
	    }
	    
	    private function establishSession():void
	    {
	        var sessionIQ:IQ = new IQ(null, "set");

	        sessionIQ.addExtension(new SessionExtension());
	        
	        sessionIQ.callback = handleSessionResponse;
	        sessionIQ.callbackScope = this;
	
	        send(sessionIQ);
	    }
	    
		//do nothing, we use polling instead
		public override function sendKeepAlive():void {}
	}
}
