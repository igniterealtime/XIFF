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
	import flash.errors.IOError;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;

	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.NetStream;
	import flash.utils.ByteArray;

	import org.igniterealtime.xiff.events.*;


	/**
	 * A child of <code>XMPPConnection</code>, this class makes use of the
	 * Flash RTMP connection instead of the <code>Socket</code>.
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
		}

		/**
		 * Called from <code>XMPPConnection()</code> constructor.
		 */
		override protected function createConnection():void
		{
			NetConnection.defaultObjectEncoding = flash.net.ObjectEncoding.AMF0;
			netConnection = new NetConnection();
			netConnection.client = this;
			netConnection.addEventListener( NetStatusEvent.NET_STATUS , netStatus );
			netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}


		private function netStatus (evt:NetStatusEvent ):void
		{

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

		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			//trace("AsyncErrorEvent: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			//trace("securityErrorHandler: " + event);
		}


		override protected function sendDataToServer( data:ByteArray ):void
		{
			netConnection.call("xmppSend", null, data.readUTFBytes(data.length));
		}

		override public function disconnect():void
		{
			if ( isActive() )
			{
				netConnection.close();
				active = false;
				loggedIn = false;
				var event:DisconnectionEvent = new DisconnectionEvent();
				dispatchEvent(event);
			}
		}

		override public function connect( streamType:uint=0  ):void
		{
			active = false;
			loggedIn = false;

			netConnection.connect(xmppUrl);
		}

		override public function sendKeepAlive():void
		{

		}

		override protected function restartStream():void
		{
			disconnect();
			connect();
		}

		/**
		 * Is the name of this method locked in the server side?
		 */
		public function xmppRecieve(rawXML:String):void
		{
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(rawXML);
			parseDataReceived(data);
		}
	}
}
