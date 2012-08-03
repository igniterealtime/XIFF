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
package org.igniterealtime.xiff.conference
{
	import org.igniterealtime.xiff.collections.ICollection;
	import org.igniterealtime.xiff.core.IXMPPConnection;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.IMessage;
	import org.igniterealtime.xiff.data.muc.IMUCExtension;

	public interface IRoom extends ICollection
	{
		function allow( jids:Array ):void;

		function ban( jids:Array ):void;

		function cancelConfiguration():void;

		function changeSubject( newSubject:String ):void;

		function configure( fieldmap:Object ):void;

		function decline( jid:UnescapedJID, reason:String ):void;

		function destroy( reason:String, alternateJID:UnescapedJID = null, callback:Function = null ):void;

		function getMessage( body:String = null, htmlBody:String = null ):IMessage;

		function getOccupantNamed( name:String ):IRoomOccupant;

		function grant( affiliation:String, jids:Array ):void;

		function invite( jid:UnescapedJID, reason:String ):void;

		function isThisRoom( sender:UnescapedJID ):Boolean;

		function isThisUser( sender:UnescapedJID ):Boolean;

		function join( createReserved:Boolean = false, joinPresenceExtensions:Array = null ):Boolean;

		function joinWithExplicitMUCExtension( createReserved:Boolean, mucExtension:IMUCExtension, joinPresenceExtensions:Array = null ):Boolean;

		function kickOccupant( occupantNick:String, reason:String ):void;

		function leave():void;

		function requestAffiliations( affiliation:String ):void;

		function requestConfiguration():void;

		function revoke( jids:Array ):void;

		function sendMessage( body:String = null, htmlBody:String = null ):void;

		function sendMessageWithExtension( message:IMessage ):void;

		function sendPrivateMessage( recipientNickname:String, body:String = null, htmlBody:String = null ):void;

		function setOccupantVoice( occupantNick:String, voice:Boolean ):void;

		function get affiliation():String;

		function get anonymous():Boolean;

		function get connection():IXMPPConnection;
		function set connection( value:IXMPPConnection ):void;

		function get conferenceServer():String;
		function set conferenceServer( value:String ):void;

		function get active():Boolean;

		function get nickname():String;
		function set nickname( value:String ):void;

		function get password():String;
		function set password( value:String ):void;

		function get role():String;

		function get roomJID():UnescapedJID;
		function set roomJID( jid:UnescapedJID ):void;

		function get roomName():String;
		function set roomName( value:String ):void;

		function get subject():String;

		function get userJID():UnescapedJID;
	}
}
