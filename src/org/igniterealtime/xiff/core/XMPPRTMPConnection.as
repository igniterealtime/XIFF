/*
 * Copyright (C) 2003-2011 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
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
	import flash.errors.IOError;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;

	import flash.events.SecurityErrorEvent;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;

	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import org.igniterealtime.xiff.events.*;
		
	
	/**
	 * A child of <code>XMPPConnection</code>, this class makes use of the
	 * Flash RTMP connection instead of the XMLSocket</code>.
	 *
	 * @see org.jivesoftware.xiff.core.XMPPConnection
	 */
	public class XMPPRTMPConnection extends XMPPConnection
	{

		public var netConnection:NetConnection = null;
		private var xmppUrl:String = "rtmp:/xmpp";
		
				
		public function XMPPRTMPConnection(xmppUrl:String = "rtmp:/xmpp")
		{
			super();
			this.xmppUrl = xmppUrl;
			
			configureRedfire();
		}
		
		private function configureRedfire():void {
		
			NetConnection.defaultObjectEncoding = flash.net.ObjectEncoding.AMF0;
			netConnection = new NetConnection();
			netConnection.client = this;
			netConnection.addEventListener( NetStatusEvent.NET_STATUS , netStatus );
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	    	}
	

		private function netStatus (evt:NetStatusEvent ):void {

			switch(evt.info.code) {
				
				case "NetConnection.Connect.Success":
					active = true;
					dispatchEvent( new ConnectionSuccessEvent() );
					
					var myResult:Responder = new Responder(this.onResult);
					netConnection.call("xmppConnect", myResult, username, password, resource);
					
					break;
		
				case "NetConnection.Connect.Failed":
					dispatchError( "service-unavailable", "Service Unavailable", "cancel", 503 );
					break;
					
				case "NetConnection.Connect.Closed":
					var event2:DisconnectionEvent = new DisconnectionEvent();
					dispatchEvent( event2 );
					break;
		
				case "NetConnection.Connect.Rejected":
					dispatchError( "not-authorized", "Not Authorized", "auth", 401 );
					break;
					
				default:
					
			}
		}

		private function onResult (loginOK:Boolean): void
		{
			if (loginOK)
			{
				dispatchEvent( new LoginEvent() );

			} else {

				dispatchError( "not-authorized", "Not Authorized", "auth", 401 );
			}
		}
					
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
           		//trace("AsyncErrorEvent: " + event);
        	}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
            		//trace("securityErrorHandler: " + event);
        	}

	
	    	override protected function sendXML( someData:* ):void
		{
			var xmlData:String;
			
			if (someData is XML)
			{
				xmlData =  (someData as XML).toXMLString();

			} else if (someData is String) {

				xmlData =  someData;
			
			} else {
			
				xmlData = someData.toString();
			}

			netConnection.call("xmppSend", null, xmlData);
				
			var event:OutgoingDataEvent = new OutgoingDataEvent();
			var byteData:ByteArray = new ByteArray();
			byteData.writeUTFBytes(xmlData);
			event.data = byteData;
				
			dispatchEvent( event );
		}
		
		override public function disconnect():void
		{
			if( isActive() ) {
				netConnection.close();
				active = false;
				loggedIn = false;
				var event:DisconnectionEvent = new DisconnectionEvent();
				dispatchEvent(event);
			}
		}
		
		override public function connect( streamType:uint=0  ):Boolean
		{
			active = false;
			loggedIn = false;

			netConnection.connect(xmppUrl);
			return true;
		}

		override public function sendKeepAlive():void
		{
		
		}

		override protected function restartStream():void
		{
			disconnect();
			connect();
		}
			
			
		public function xmppRecieve(rawXML:String):*
		{
			var xmlData:XMLDocument = new XMLDocument();
			xmlData.ignoreWhite = ignoreWhitespace;
			var isComplete:Boolean = true;

			if ("<?xml version='1.0' encoding='UTF-8'?>" == rawXML.substring(0, 38))
			{
				rawXML = rawXML.substring(38) + "</stream:stream>";
			}
						
			try {
				xmlData.parseXML( rawXML );
			}
			catch(err:Error){
				isComplete = false;
			}
			
			
			if (isComplete)
			{
				var event:IncomingDataEvent = new IncomingDataEvent();
				var byteData:ByteArray = new ByteArray();
				byteData.writeUTFBytes(rawXML);
				event.data = byteData;
				dispatchEvent( event );
				
				for (var i:int = 0; i<xmlData.childNodes.length; i++)
				{
					var currentNode:XMLNode = xmlData.childNodes[i];
					handleNodeType( currentNode );
				}
			}
		}
	}
}
