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
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;

	/**
	 * XEP-0048: Bookmarks
	 *
	 * @see http://xmpp.org/extensions/xep-0048.html
	 */
	public class GroupChatBookmark extends XMLStanza implements INodeProxy
	{
		// TODO: NS?
		public static const ELEMENT_NAME:String = "conference";


		/**
		 * A common use case is bookmarking of multi-user chat rooms.
		 * A room is bookmarked using the <strong>conference</strong> child element.
		 *
		 * <p>Most of the properties can be set only via constructor or by setting the XML.</p>
		 *
		 * @param	jid			REQUIRED
		 * @param	name		RECOMMENDED
		 * @param	autoJoin	OPTIONAL
		 * @param	nickname	OPTIONAL
		 * @param	password	NOT RECOMMENDED
		 * @see http://xmpp.org/extensions/xep-0048.html#format-conference
		 */
		public function GroupChatBookmark( jid:EscapedJID, name:String = null,
										   autoJoin:Boolean = false, nickname:String = null,
										   password:String = null )
		{
			xml.setLocalName( ELEMENT_NAME );
			xml.@jid = jid.toString();

			if ( name != null )
			{
				xml.@name = name;
			}
			if ( autoJoin )
			{
				xml.@autojoin = "true";
			}
			if ( nickname != null )
			{
				xml.nick = nickname;
			}
			if ( password != null )
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

		/**
		 * Whether the client should automatically join the conference room on login.
		 */
		public function get autoJoin():Boolean
		{
			return xml.@autojoin == "true";
		}
		public function set autoJoin( value:Boolean ):void
		{
			xml.@autojoin = value.toString();
		}

		/**
		 * The JabberID of the chat room.
		 */
		public function get jid():EscapedJID
		{
			var list:XMLList = xml.attribute("jid");
			if ( list.length() > 0 )
			{
				return new EscapedJID(list[0]);
			}
			return null;
		}

		/**
		 * A friendly name for the bookmark.
		 */
		public function get name():String
		{
			return getAttribute("name");
		}

		/**
		 * The user's preferred roomnick for the chatroom.
		 */
		public function get nickname():String
		{
			return getField("nick");
		}

		/**
		 * Unencrypted string for the password needed to enter a password-protected room.
		 *
		 * <p>For security reasons, use of this element is NOT RECOMMENDED.</p>
		 */
		public function get password():String
		{
			return getField("password");
		}

	}
}
