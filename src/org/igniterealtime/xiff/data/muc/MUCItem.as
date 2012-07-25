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
package org.igniterealtime.xiff.data.muc
{


	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;

	/**
	 * This class is used by the MUCExtension for internal representation of
	 * information pertaining to occupants in a multi-user conference room.
	 *
	 * <p>The information given inside Precense of a given room user</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0045.html#associations
	 */
	public class MUCItem extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "item";

		/**
		 *
		 * @param	parent
		 */
		public function MUCItem(parent:XML = null)
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if (parent != null)
			{
				parent.appendChild(xml);
			}
		}

		/**
		 * Optional. JID of the room user or server that made changes to the given item.
		 * Most likely when kicking someone from a room.
		 *
		 * @see http://xmpp.org/extensions/xep-0045.html#kick
		 */
		public function get actor():EscapedJID
		{
			var value:String = getChildAttribute("actor", "jid");
			if ( value != null )
			{
				return new EscapedJID(value);
			}
			return null;
		}
		public function set actor(value:EscapedJID):void
		{
			setChildAttribute("actor", "jid", value != null ? value.toString() : null);
		}

		/**
		 * Optional. Nickname of the room user or server that made changes to the given item.
		 * Most likely when kicking someone from a room.
		 *
		 * <p>This property was added to Version 1.25 (2012-02-08) of the specification.</p>
		 *
		 * @see http://xmpp.org/extensions/xep-0045.html#kick
		 */
		public function get actorNick():String
		{
			return getChildAttribute("actor", "nick");
		}
		public function set actorNick(value:String):void
		{
			setChildAttribute("actor", "nick", value);
		}

		/**
		 * Rason given by the actor for the action that was made for the given item.
		 * Most likely the reson why someone was kicked out from a room.
		 *
		 * @see http://xmpp.org/extensions/xep-0045.html#kick
		 */
		public function get reason():String
		{
			return getField("reason");
		}
		public function set reason(value:String):void
		{
			setField("reason", value);
		}

		/**
		 * Can be one of the following: owner, admin, member, outcast, or none.
		 */
		public function get affiliation():String
		{
			return getAttribute("affiliation");
		}
		public function set affiliation(value:String):void
		{
			setAttribute("affiliation", value);
		}

		/**
		 *
		 */
		public function get jid():EscapedJID
		{
			var value:String = getAttribute("jid");
			if ( value != null )
			{
				return new EscapedJID(value);
			}
			return null;
		}
		public function set jid(value:EscapedJID):void
		{
			setAttribute("jid", value != null ? value.toString() : null);
		}

		/**
		 * The nickname of the conference occupant.
		 *
		 */
		public function get nick():String
		{
			return getAttribute("nick");
		}
		public function set nick(value:String):void
		{
			setAttribute("nick", value);
		}

		/**
		 * Can be one of the following: moderator, participant,
		 * visitor, or none.
		 */
		public function get role():String
		{
			return getAttribute("role");
		}
		public function set role(value:String):void
		{
			setAttribute("role", value);
		}
	}
}
