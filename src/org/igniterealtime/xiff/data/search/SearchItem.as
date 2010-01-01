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
package org.igniterealtime.xiff.data.search
{
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	/**
	 * This class is used by the SearchExtension for internal representation of
	 * information pertaining to items matching the search query.
	 * @see http://xmpp.org/extensions/xep-0055.html
	 */
	public class SearchItem extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "item";

		public function SearchItem( parent:XML = null )
		{
			super();

			node.setName( ELEMENT_NAME );

			if ( exists( parent ) )
			{
				parent.appendChild( node );
			}
		}

		public function deserialize( node:XML ):Boolean
		{
			node = node;

			return true;
		}

		public function serialize( parent:XML ):Boolean
		{
			if ( parent != node.parent() )
			{
				parent.appendChild( node.copy() );
			}

			return true;
		}

		/**
		 * E-mail
		 */
		public function get email():String
		{
			return node.email;
		}
		public function set email( value:String ):void
		{
			node.email = value;
		}

		/**
		 * First
		 */
		public function get first():String
		{
			return node.first;
		}
		public function set first( value:String ):void
		{
			node.first = value;
		}

		/**
		 * JID
		 */
		public function get jid():String
		{
			return node.@jid;
		}
		public function set jid( value:String ):void
		{
			node.@jid = value;
		}

		/**
		 * Last
		 */
		public function get last():String
		{
			return node.last;
		}
		public function set last( value:String ):void
		{
			node.last = value;
		}

		/**
		 * Name
		 */
		public function get name():String
		{
			return node.name;
		}
		public function set name( value:String ):void
		{
			node.name = value;
		}

		/**
		 * Nick
		 */
		public function get nick():String
		{
			return node.nick;
		}
		public function set nick( value:String ):void
		{
			node.nick = value;
		}

		/**
		 * Username, altough it seems that a JID is used.
		 */
		public function get username():String
		{
			return node.jid;
		}
		public function set username( value:String ):void
		{
			node.jid = value;
		}
	}
}
