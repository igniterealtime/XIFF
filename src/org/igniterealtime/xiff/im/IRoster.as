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
package org.igniterealtime.xiff.im
{
	import org.igniterealtime.xiff.collections.ICollection;
	import org.igniterealtime.xiff.core.IXMPPConnection;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.IPresence;
	import org.igniterealtime.xiff.data.im.IRosterGroup;
	import org.igniterealtime.xiff.data.im.IRosterItemVO;
	
	public interface IRoster extends ICollection
	{
		function addContact( id:UnescapedJID, nickname:String, groupName:String = null, requestSubscription:Boolean = true ):void;
		
		function denySubscription( tojid:UnescapedJID ):void;
		
		function fetchRoster():void;
		
		function getContainingGroups( item:IRosterItemVO ):Array;
		
		function getGroup( name:String ):IRosterGroup;
		
		function getPresence( jid:UnescapedJID ):IPresence;
		
		function grantSubscription( tojid:UnescapedJID, requestAfterGrant:Boolean = true ):void;
		
		function removeContact( rosterItem:IRosterItemVO ):void;
		
		function requestSubscription( id:UnescapedJID, isResponse:Boolean = false ):void;
		
		function setPresence( show:String, status:String, priority:int ):void;
		
		function updateContactGroups( rosterItem:IRosterItemVO, newGroupNames:Array ):void;
		
		function updateContactName( rosterItem:IRosterItemVO, newName:String ):void;
		
		function get connection():IXMPPConnection;
		function set connection( value:IXMPPConnection ):void;
	}
}
