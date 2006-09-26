package org.jivesoftware.xiff.core
{
	
	
	/*
	 * Copyright (C) 2003-2004 
	 * Nick Velloff <nick.velloff@gmail.com>
	 * Derrick Grigg <dgrigg@rogers.com>
	 * Sean Voisen <sean@mediainsites.com>
	 * Sean Treadway <seant@oncotype.dk>
	 *
	 * This library is free software; you can redistribute it and/or
	 * modify it under the terms of the GNU Lesser General Public
	 * License as published by the Free Software Foundation; either
	 * version 2.1 of the License, or (at your option) any later version.
	 * 
	 * This library is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	 * Lesser General Public License for more details.
	 * 
	 * You should have received a copy of the GNU Lesser General Public
	 * License along with this library; if not, write to the Free Software
	 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
	 *
	 */
	 
	 
	import org.jivesoftware.xiff.util.SocketConn;
	import flash.errors.IOError;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import org.jivesoftware.xiff.events.*;
	import flash.events.SecurityErrorEvent;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import org.jivesoftware.xiff.util.SocketDataEvent;
	
	public class XMPPSocketConnection extends XMPPConnection
	{
		protected var binarySocket:SocketConn;
		public function XMPPSocketConnection()
		{
			super();
			configureSocket();
		}
		private function configureSocket():void {
			binarySocket = new SocketConn();
			
	        binarySocket.addEventListener(Event.CLOSE, socketClosed);
	        binarySocket.addEventListener(Event.CONNECT, socketConnected);
	        binarySocket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
	        binarySocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
	        binarySocket.addEventListener(SocketDataEvent.SOCKET_DATA_RECEIVED, bSocketReceivedData);
	    }
	    override protected function sendXML( someData:* ):void
		{
			// Data is untyped because it could be a string or XML
	        binarySocket.sendString(someData);

			var event:OutgoingDataEvent = new OutgoingDataEvent();
			event.data = someData;
			dispatchEvent( event );
		}
		override public function disconnect():void
		{
			if( isActive() ) {
				sendXML( closingStreamTag );
				binarySocket.close();
				active = false;
				loggedIn = false;
				var event:DisconnectionEvent = new DisconnectionEvent();
				dispatchEvent(event);
			}
		}
		override public function connect( streamType:String ):Boolean
		{
			active = false;
			loggedIn = false;
			
			// Stream type lets user set opening/closing tag - some servers (jadc2s) prefer <stream:flash> to the standard
			// <stream:stream>
			switch( streamType ) {
				case "flash":
					openingStreamTag = "<?xml version=\"1.0\"?><flash:stream to=\"" + server + "\" xmlns=\"jabber:client\" xmlns:flash=\"http://www.jabber.com/streams/flash\" version=\"1.0\">";
					closingStreamTag = "</flash:stream>";
					break;
					
				case "terminatedFlash":
					openingStreamTag = "<?xml version=\"1.0\"?><flash:stream to=\"" + server + "\" xmlns=\"jabber:client\" xmlns:flash=\"http://www.jabber.com/streams/flash\" version=\"1.0\" />";
					closingStreamTag = "</flash:stream>";
					break;
					
				case "standard":
					openingStreamTag = "<?xml version=\"1.0\"?><stream:stream to=\"" + server + "\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">";
					closingStreamTag = "</stream:stream>";
					break;
			
				case "terminatedStandard":
				default:
					openingStreamTag = "<?xml version=\"1.0\"?><stream:stream to=\"" + server + "\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\" />";
					closingStreamTag = "</stream:stream>";
					break;
			}
			binarySocket.connect( server, port );
			return true;
		}
		
		protected function bSocketReceivedData( ev:SocketDataEvent ):void 
		{
			var rawXML:String = ev.data as String;
			
			// parseXML is more strict in AS3 so we must check for the presence of flash:stream
			// the unterminated tag should be in the first string of xml data retured from the server
			if (!_expireTagSearch) 
			{
				var pattern:RegExp = new RegExp("<flash:stream");
				var resultObj:Object = pattern.exec(rawXML);
				if (resultObj != null) // stop searching for unterminated node
				{
					rawXML = rawXML.concat("</flash:stream>");
					_expireTagSearch = true;
				}
			}
			
			if (!_expireTagSearch) 
			{
				var pattern2:RegExp = new RegExp("<stream:stream");
				var resultObj2:Object = pattern2.exec(rawXML);
				if (resultObj2 != null) // stop searching for unterminated node
				{
					rawXML = rawXML.concat("</stream:stream>");
					_expireTagSearch = true;
				}
			}
			
			var xmlData:XMLDocument = new XMLDocument();
			xmlData.ignoreWhite = this.ignoreWhite;
			xmlData.parseXML( rawXML );
			
			var event:IncomingDataEvent = new IncomingDataEvent();
			event.data = xmlData;
			dispatchEvent( event );
			
			for (var i:int = 0; i<xmlData.childNodes.length; i++)
			{
				// Read the data and send it to the appropriate parser
				var currentNode:XMLNode = xmlData.childNodes[i];
				var nodeName:String = currentNode.nodeName.toLowerCase();
				
				
				switch( nodeName )
				{
					case "stream:stream":
						_expireTagSearch = false;
						handleStream( currentNode );
						break;
					case "flash:stream":
						_expireTagSearch = false;
						handleStream( currentNode );
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
						
					default:
						dispatchError( "undefined-condition", "Unknown Error", "modify", 500 );
						break;
				}
			}
		}
	}
}