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
package org.igniterealtime.xiff.si
{
	import flash.events.EventDispatcher;
	
	import org.igniterealtime.xiff.core.*;
	import org.igniterealtime.xiff.data.forms.*;
	import org.igniterealtime.xiff.data.si.*;
	import org.igniterealtime.xiff.events.*;

	/**
	 *
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.TRANSFER_INIT
	 */
	[Event(name="transferInit", type="org.igniterealtime.xiff.events.FileTransferEvent")]
	
	/**
	 * Manages Stream Initiation (XEP-0095) based File Transfer (XEP-0096)
	 *
	 * @see http://xmpp.org/extensions/xep-0095.html
	 * @see http://xmpp.org/extensions/xep-0096.html
	 */
	public class FileTransferManager extends EventDispatcher
	{

		private var _connection:IXMPPConnection;

		/**
		 *
		 * @param	aConnection A reference to an XMPPConnection class instance
		 */
		public function FileTransferManager( aConnection:IXMPPConnection = null )
		{
			if ( aConnection != null )
			{
				connection = aConnection;
			}
        }

		/**
		 * The connection used for sending and receiving data.
		 */
		public function get connection():IXMPPConnection
		{
			return _connection;
		}
		public function set connection( value:IXMPPConnection ):void
		{
			if ( _connection != null )
			{
			}
			
			_connection = value;
			_connection.enableExtensions( FileTransferExtension, FormExtension, StreamInitiationExtension );
		}
	}
}
