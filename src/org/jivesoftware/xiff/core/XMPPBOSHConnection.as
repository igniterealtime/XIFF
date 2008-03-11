package org.jivesoftware.xiff.core
{
	import flash.events.ErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.jivesoftware.xiff.auth.Anonymous;
	import org.jivesoftware.xiff.auth.Plain;
	import org.jivesoftware.xiff.auth.SASLAuth;
	import org.jivesoftware.xiff.data.IQ;
	import org.jivesoftware.xiff.data.bind.BindExtension;
	import org.jivesoftware.xiff.data.session.SessionExtension;
	import org.jivesoftware.xiff.events.ConnectionSuccessEvent;
	import org.jivesoftware.xiff.events.IncomingDataEvent;
	import org.jivesoftware.xiff.events.LoginEvent;
	import org.jivesoftware.xiff.events.XIFFErrorEvent;
	import org.jivesoftware.xiff.util.Callback;
	
	public class XMPPBOSHConnection extends XMPPConnection
	{
		private static var saslMechanisms:Object = {
			"PLAIN":Plain,
			"ANONYMOUS":Anonymous
		};
		
		private var maxConcurrentRequests:uint = 2;
		private var boshVersion:Number = 1.6;
		private var headers:Object = {
			"post": [],
			"get": ['Cache-Control', 'no-store', 'Cache-Control', 'no-cache', 'Pragma', 'no-cache']
		};
		private var requestCount:int = 0;
		private var failedRequests:Array = [];
		private var requestQueue:Array = [];
		private var responseQueue:Array = [];
		private const responseTimer:Timer = new Timer(0.0, 1);
		private var isDisconnecting:Boolean = false;
		private var boshPollingInterval:Number = 10000;
		private var sid:String;
		private var rid:Number;
		private var wait:int;
		private var inactivity:int;
		private var pollTimer:Timer;
		private var isCurrentlyPolling:Boolean = false;
		
		private var auth:SASLAuth;
		private var authHandler:Function;
		private var https:Boolean = false;
		private var _port:Number = -1;
		
		private var callbacks:Object = {};
		
		public static var logger:Object = null;
			
		public override function connect(streamType:String=null):Boolean
		{
			if(logger)
				logger.log("CONNECT()", "INFO");
			BindExtension.enable();
			active = false;
			loggedIn = false;
			var attrs:Object = {
	            xmlns: "http://jabber.org/protocol/httpbind",
	            hold: maxConcurrentRequests,
	            rid: nextRID,
	            secure: https,
	            wait: 10,
	            ver: boshVersion
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
		
		public function set secure(flag:Boolean):void
		{
			https = flag;
		}
		
		public override function set port(portnum:Number):void
		{
			_port = portnum;
		}
		
		public override function get port():Number
		{
			if(_port == -1)
				return https ? 8483 : 8080;
			return _port;
		}
		
		public function get httpServer():String
		{
			return (https ? "https" : "http") + "://" + server + ":" + port + "/http-bind/";
		}
		
		public override function disconnect():void
		{
			super.disconnect();
			pollTimer.stop();
			pollTimer = null;
		}
		
		public function processConnectionResponse(responseBody:XMLNode):void
		{
			var attributes:Object = responseBody.attributes;
			sid = attributes.sid;
	        boshPollingInterval = attributes.polling * 1000;
	        // if we have a polling interval of 1, we want to add an extra second for a little bit of
	        // padding.
	        if(boshPollingInterval <= 1000 && boshPollingInterval > 0)
	            boshPollingInterval += 1000;
	        
	        wait = attributes.wait;
	        inactivity = attributes.inactivity;
	        var serverRequests:int = attributes.requests;
	        if (serverRequests)
	            maxConcurrentRequests = Math.min(serverRequests, maxConcurrentRequests);
	        active = true;
	        configureConnection(responseBody);
	        responseTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processResponse);
	        pollTimer = new Timer(boshPollingInterval, 1);
	        pollTimer.addEventListener(TimerEvent.TIMER, pollServer);
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
			
			if(logger)
	       		logger.log(rawXML, "INCOMING");
			
			var xmlData:XMLDocument = new XMLDocument();
			xmlData.ignoreWhite = this.ignoreWhite;
			xmlData.parseXML( rawXML );
			var bodyNode:XMLNode = xmlData.firstChild;
	
			var event:IncomingDataEvent = new IncomingDataEvent();
			event.data = xmlData;
			dispatchEvent( event );
			
			if(bodyNode.attributes["type"] == "terminal")
			{
				dispatchError( "BOSH Error", bodyNode.attributes["condition"], "", -1 );
				active = false;
			}
			
			for each(var childNode:XMLNode in bodyNode.childNodes)
			{
				if(childNode.nodeName == "stream:features")
				{
					_expireTagSearch = false;
					processConnectionResponse( bodyNode );
				}
				else
					responseQueue.push(childNode);
			}
			
			resetResponseProcessor();
			
			//if we just processed a poll response, we're no longer in mid-poll
			if(isPollResponse)
				isCurrentlyPolling = false;
			
			//if we have queued requests we want to send them before attempting to poll again
			//otherwise, if we don't already have a countdown going for the next poll, start one
	        if (!sendQueuedRequests() && (!pollTimer || !pollTimer.running))
	        	resetPollTimer();
		}
		
		private function httpError(req:XMLNode, isPollResponse:Boolean, evt:FaultEvent):void
		{
			active = false;
			var err:XIFFErrorEvent = new XIFFErrorEvent();
			err.errorMessage = "HTTP Error";
			dispatchEvent(err);
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
		private function sendRequests(data:XMLNode = null, isPoll:Boolean=false):Boolean
		{
			if(requestCount >= maxConcurrentRequests)
				return false;
				
			if(isPoll)
				trace("Polling at: " + new Date().getSeconds());
				
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
	       
	       trace(data);
	       if(logger)
	       	logger.log(data, "OUTGOING");
	       
			request.send(data);

			resetPollTimer();
			
			return true;
		}
    	
    	private function resetPollTimer():void 
    	{
    		if(!pollTimer)
    			return;
    		pollTimer.reset();
    		pollTimer.start();
    	}
    	
    	private function pollServer(evt:TimerEvent):void 
    	{
    		//We shouldn't poll if the connection is dead, if we had requests to send instead, or if there's already one in progress
    		if(!isActive() || sendQueuedRequests() || isCurrentlyPolling)
    			return;
    		
    		//this should be safe since sendRequests checks to be sure it's not over the concurrent requests limit, and we just ensured that the queue is empty by calling sendQueuedRequests()
    		isCurrentlyPolling = sendRequests(null, true);
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
	    //    if(!response || response.length == 0) {
	     //       return;
	     //   }
	        var status:Object = auth.handleResponse(0, responseBody);
	        if (status.authComplete) {
	            if (status.authSuccess) {
	                bindConnection();
	            }
	            else {
	                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
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
	   				return new authClass(this);
	        }
	
	        if (!authMechanism) {
	            throw new Error("No auth mechanisms found");
	        }
	
	        return authMechanism;
	    }
	    
	    public function handleBindResponse(packet:IQ):void
	    {
	    	var bind:BindExtension = packet.getExtension("bind") as BindExtension;
	
            var jid:String = bind.getJID();
            
            var parts:Array = jid.split("/");
            myResource = parts[1];
            parts = parts[0].split("@");
            myUsername = parts[0];
            server = parts[1];
            
            establishSession();
	    }
	    
	    private function bindConnection():void 
	    {
	    	var bindIQ:IQ = new IQ(null, "set");
	
			var bindExt:BindExtension = new BindExtension();
			if(resource)
	        	bindExt.resource = resource;
	        
	        bindIQ.addExtension(bindExt);
	
			//this is laaaaaame, it should be a function
			bindIQ.callbackName = "handleBindResponse";
			bindIQ.callbackScope = this;
	
	        send(bindIQ);
	    }
	    
	    public function handleSessionResponse(packet:IQ):void
	    {
	    	dispatchEvent(new LoginEvent());
	    }
	    
	    private function establishSession():void
	    {
	        var sessionIQ:IQ = new IQ(null, "set");

	        sessionIQ.addExtension(new SessionExtension());
	        
	        sessionIQ.callbackName = "handleSessionResponse";
	        sessionIQ.callbackScope = this;
	
	        send(sessionIQ);
	    }
	    
		//do nothing, we use polling instead
		public override function sendKeepAlive():void {}
	}
}