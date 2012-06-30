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
package org.igniterealtime.xiff.bookmark
{
	

	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ISerializable;

	/**
	 * XEP-0048: Bookmarks
	 * @see http://xmpp.org/extensions/xep-0048.html
	 */
	public class GroupChatBookmark extends Extension implements ISerializable
	{
		// TODO: NS?
		public static const ELEMENT_NAME:String = "conference";
		

		/**
		 *
		 * @param	name
		 * @param	jid
		 * @param	autoJoin
		 * @param	nickname
		 * @param	password
		 */
		public function GroupChatBookmark( name:String = null, jid:EscapedJID = null,
										   autoJoin:Boolean = false, nickname:String = null,
										   password:String = null )
		{
			if ( !name && !jid )
			{
				return;
			}
			else if ( !name || !jid )
			{
				throw new Error( "Name and jid cannot be null, they must either both be null or an Object" );
			}
			
			xml.setLocalName( ELEMENT_NAME );
			xml.@name = name;
			xml.@jid = jid.toString();
			
			if ( autoJoin )
			{
				xml.@autojoin = "true";
			}
			if ( nickname )
			{
				xml.nick = nickname;
			}
			if ( password )
			{
				xml.password = password;
			}
		}
		
		public function getNS():String
		{
			return ""; // GroupChatBookmark.NS;
		}
		
		public function getElementName():String
		{
			return GroupChatBookmark.ELEMENT_NAME;
		}

		public function get autoJoin():Boolean
		{
			return xml.@autojoin == "true";
		}

		public function set autoJoin( value:Boolean ):void
		{
			xml.@autojoin = value.toString();
		}
		
		public function get jid():EscapedJID
		{
			
			return new EscapedJID( xml.@jid );
		}

		public function get name():String
		{
			return xml.@name;
		}

		public function get nickname():String
		{
			return xml.nick.toString();
		}

		public function get password():String
		{
			return xml.password.toString();
		}

	}
}
