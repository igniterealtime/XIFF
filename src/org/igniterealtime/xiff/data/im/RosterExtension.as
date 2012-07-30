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
package org.igniterealtime.xiff.data.im
{
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * An IQ extension for roster data. Roster data is typically any data
	 * that is sent or received with the "jabber:iq:roster" namespace.
	 *
	 * @see http://xmpp.org/rfcs/rfc3921.html#roster
	 */
	public class RosterExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:roster";
		public static const ELEMENT_NAME:String = "query";

		public static const SUBSCRIBE_TYPE_NONE:String = "none";
		public static const SUBSCRIBE_TYPE_TO:String = "to";
		public static const SUBSCRIBE_TYPE_FROM:String = "from";
		public static const SUBSCRIBE_TYPE_BOTH:String = "both";
		public static const SUBSCRIBE_TYPE_REMOVE:String = "remove";
		public static const ASK_TYPE_NONE:String = "none";
		public static const ASK_TYPE_SUBSCRIBE:String = "subscribe";
		public static const ASK_TYPE_UNSUBSCRIBE:String = "unsubscribe";
		public static const SHOW_UNAVAILABLE:String = "unavailable";
		public static const SHOW_PENDING:String = "Pending";

		/**
		 *
		 * @param	parent
		 */
		public function RosterExtension( parent:XML = null )
		{
			super( parent );
		}

		/**
		 * Gets the namespace associated with this extension.
		 * The namespace for the RosterExtension is "jabber:iq:roster".
		 *
		 * @return The namespace
		 */
		public function getNS():String
		{
			return RosterExtension.NS;
		}

		/**
		 * Gets the element name associated with this extension.
		 * The element for this extension is "query".
		 *
		 * @return The element name
		 */
		public function getElementName():String
		{
			return RosterExtension.ELEMENT_NAME;
		}

		/**
		 * Gets one item from the roster query, returning the first item found with the JID specified.
		 * If none is found, then it returns null.
		 *
		 * @return A roster item object with the following attributes: "jid", "subscription", "nickname", and "groups".
		 */
		public function getItemByJID( jid:EscapedJID ):RosterItem
		{
			for each ( var item:RosterItem in items )
			{
				if ( item.jid.toString() == jid.toString() )
				{
					return item;
				}
			}

			return null;
		}

		/**
		 * Adds a single roster item to the extension payload.
		 *
		 * @param	jid The JID of the contact to add
		 * @param	subscription The subscription type of the roster item contact.
		 * 			There are pre-defined static variables for these string options in this class definition.
		 * @param	nickname The display name or nickname of the contact.
		 * @param	groups An array of strings of the group names that this contact should be placed in.
		 */
		public function addItem( jid:EscapedJID=null, subscription:String="", nickname:String="", groups:Array=null ):void
		{
			var item:RosterItem = new RosterItem( xml );

			if ( jid != null )
			{
				item.jid = jid;
			}
			if ( subscription != "" )
			{
				item.subscription = subscription;
			}
			if ( nickname != "" )
			{
				item.name = nickname;
			}
			if ( groups != null )
			{
				for each( var group:String in groups )
				{
					if (group)
					{
						item.addGroupNamed( group );
					}
				}
			}
		}

		/**
		 *
		 * Array of RosterItem objects
		 */
		public function get items():Array
		{
			var list:Array = [];
			for each( var child:XML in xml.children() )
			{
				if ( child.localName() == RosterItem.ELEMENT_NAME )
				{
					var item:RosterItem = new RosterItem();
					item.xml = child;
					list.push( item );
				}
			}
			return list;
		}
		public function set items( value:Array ):void
		{
			removeFields(RosterItem.ELEMENT_NAME);

			if ( value != null )
			{
				var len:uint = value.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var item:RosterItem = value[i] as RosterItem;
					xml.appendChild( item.xml );
				}
			}
		}
	}
}
