/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
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
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	/**
	 * This class is used by the MUCExtension for internal representation of
	 * information pertaining to occupants in a multi-user conference room.
	 */
	public class MUCItem extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "item";

		public function MUCItem( parent:XML = null )
		{
			super();

			node.setName( ELEMENT_NAME );

			if ( exists( parent ) )
			{
				parent.appendChild( node );
			}
		}

		/**
		 *
		 */
		public function get actor():EscapedJID
		{
			var value:EscapedJID;
			if (node.actor.@jid.length() > 0)
			{
				value = new EscapedJID( node.actor.@jid.toString() );
			}
			return value;
		}

		public function set actor( value:EscapedJID ):void
		{
			node.actor.@jid = value.toString();
		}

		/**
		 * The following affiliations are defined:
		 * <ul>
		 * <li></li>
		 * </ul>

   1. Owner
   2. Admin
   3. Member
   4. Outcast
   5. None (the absence of an affiliation)

		 */
		public function get affiliation():String
		{
			return node.@affiliation;
		}

		public function set affiliation( value:String ):void
		{
			node.@affiliation = value;
		}

		public function deserialize( node:XML ):Boolean
		{
			node = node;

			return true;
		}

		public function get jid():EscapedJID
		{
			var value:EscapedJID;
			if (node.@jid.length() > 0)
			{
				value = new EscapedJID( node.@jid.toString() );
			}
			return value;
		}

		public function set jid( value:EscapedJID ):void
		{
			node.@jid = value.toString();
		}

		/**
		 * The nickname of the conference occupant.
		 *
		 */
		public function get nick():String
		{
			return node.@nick;
		}

		public function set nick( value:String ):void
		{
			node.@nick = value;
		}

		public function get reason():String
		{
			var value:String;
			if (node.reason.length() > 0)
			{
				value = node.reason.toString();
			}
			return value;
		}

		public function set reason( value:String ):void
		{
			node.reason = value;
		}

		/**
		 * Table 2: Roles
Name 	Support
Moderator 	REQUIRED
None 	N/A (the absence of a role)
Participant 	REQUIRED
Visitor 	RECOMMENDED
		 */
		public function get role():String
		{
			return node.@role;
		}

		public function set role( value:String ):void
		{
			node.@role = value;
		}

		public function serialize( parent:XML ):Boolean
		{
			if ( parent != node.parent() )
			{
				parent.appendChild( node.copy() );
			}

			return true;
		}
	}
}
