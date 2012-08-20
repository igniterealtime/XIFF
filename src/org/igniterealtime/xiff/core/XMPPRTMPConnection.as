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
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.utils.ByteArray;

	import org.igniterealtime.xiff.events.*;

	/**
	 * A child of <code>XMPPConnection</code>, this class makes use of the
	 * Flash RTMP connection instead of the <code>Socket</code>.
	 *
	 * @see org.igniterealtime.xiff.core.XMPPConnection
	 */
	public class XMPPRTMPConnection extends XMPPConnection implements IXMPPConnection
	{

		private var _netConnection:NetConnection;
		private var _rtmpUrl:String = "rtmp:/xmpp";

		/**
		 *
		 * @param	url
		 */
		public function XMPPRTMPConnection(url:String = "rtmp:/xmpp")
		{
			super();
			_rtmpUrl = url;
		}

		/**
		 * Called from <code>XMPPConnection()</code> constructor.
		 */
		override protected function createConnection():void
		{
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;

			_netConnection = new NetConnection();
			_netConnection.client = this;
			_netConnection.addEventListener( NetStatusEvent.NET_STATUS , onNetStatus );
			_netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_netConnection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, onAsyncError );
		}


		private function onNetStatus( event:NetStatusEvent ):void
		{

			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					active = true;
					dispatchEvent( new ConnectionSuccessEvent() );

					var myResult:Responder = new Responder(this.onResult);
					_netConnection.call("xmppConnect", myResult, username, password, resource);

					break;

				case "NetConnection.Connect.Failed":
					dispatchError( "service-unavailable", "Service Unavailable", "cancel", 503 );
					break;

				case "NetConnection.Connect.Closed":
					dispatchEvent( new DisconnectionEvent() );
					break;

				case "NetConnection.Connect.Rejected":
					dispatchError( "not-authorized", "Not Authorized", "auth", 401 );
					break;

			}
		}

		private function onResult(success:Boolean): void
		{
			if (success)
			{
				dispatchEvent( new LoginEvent() );

			}
			else
			{

				dispatchError( "not-authorized", "Not Authorized", "auth", 401 );
			}
		}

		private function onAsyncError(event:AsyncErrorEvent):void
		{
			trace("AsyncErrorEvent: " + event);
		}

		override protected function sendDataToServer( data:ByteArray ):void
		{
			_netConnection.call("xmppSend", null, data.readUTFBytes(data.length));
		}

		override public function disconnect():void
		{
			if ( active )
			{
				_netConnection.close();
				active = false;
				loggedIn = false;
				dispatchEvent( new DisconnectionEvent() );
			}
		}

		override public function connect( streamType:uint=0  ):void
		{
			active = false;
			loggedIn = false;

			_netConnection.connect(_rtmpUrl);
		}

		/**
		 * No need for keepalive
		 */
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
