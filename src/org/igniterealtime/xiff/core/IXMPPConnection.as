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
	import flash.events.IEventDispatcher;

	import org.igniterealtime.xiff.data.IXMPPStanza;

	/**
	 * Interface for the XMPP Connection classes
	 */
	public interface IXMPPConnection extends IEventDispatcher
	{
		function connect( streamType:uint=0 ):void;

		function disconnect():void;

		function enableExtensions(... exts):void;

		function disableExtensions(... exts):void;

		function send( data:IXMPPStanza ):void;

		function sendKeepAlive():void;

		function get compress():Boolean;
		function set compress( value:Boolean ):void;

		function get domain():String;
		function set domain( value:String ):void;

		function get incomingBytes():uint;

		function get jid():UnescapedJID;

		function get outgoingBytes():uint;

		function get password():String;
		function set password( value:String ):void;

		function get port():uint;
		function set port( value:uint ):void;

		function get queuePresences():Boolean;
		function set queuePresences( value:Boolean ):void;

		function get resource():String;
		function set resource( value:String ):void;

		function get server():String;
		function set server( value:String ):void;

		function get useAnonymousLogin():Boolean;
		function set useAnonymousLogin( value:Boolean ):void;

		function get username():String;
		function set username( value:String ):void;

		function get active():Boolean;
		function set active( value:Boolean ):void;

		function get loggedIn():Boolean;
		function set loggedIn( value:Boolean ):void;
	}
}
