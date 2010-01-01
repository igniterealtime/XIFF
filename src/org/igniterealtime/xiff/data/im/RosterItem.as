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
<<<<<<< .mine
package org.igniterealtime.xiff.data.im
{
=======
package org.igniterealtime.xiff.data.im
{
	
	import flash.xml.XMLNode;
	
>>>>>>> .r11468
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	/**
	 * This class is used internally by the RosterExtension class for managing items
	 * received and sent as roster data. Usually, each item in the roster represents a single
	 * contact, and this class is used to represent, abstract, and serialize/deserialize
	 * this data.
	 *
	 * @see	org.igniterealtime.xiff.data.im.RosterExtension
	 */
	public class RosterItem extends XMLStanza implements ISerializable
	{
<<<<<<< .mine
		public static const ELEMENT_NAME:String = "item";

		/**
		 *
		 * @param	parent The parent XML
		 */
		public function RosterItem( parent:XML = null )
=======
		public static const ELEMENT:String = "item";
		
		private var myGroupNodes:Array;
		
		public function RosterItem( parent:XMLNode = null )
>>>>>>> .r11468
		{
			super();

			node.setName( ELEMENT_NAME );

			if ( exists( parent ) )
			{
				parent.appendChild( node );
			}
		}

		/**
		 * Adds a group to the roster item. Contacts in the roster can be associated
		 * with multiple groups.
		 *
		 * @param	groupName The name of the group to add
		 */
		public function addGroupNamed( groupName:String ):void
		{
			node.group.appendChild( groupName );
		}

		/**
		 * The ask type for this roster item.  Ask types have
		 * been enumerated by static variables in the RosterExtension:
		 * <ul>
		 * <li>RosterExtension.ASK_TYPE_NONE</li>
		 * <li>RosterExtension.ASK_TYPE_SUBSCRIBE</li>
		 * <li>RosterExtension.ASK_TYPE_UNSUBSCRIBE</li>
		 * </ul>
		 *
		 */
		public function get askType():String
		{
			return node.@ask;
		}

		public function set askType( value:String ):void
		{
			node.@ask = value;
		}

		/**
		 * Deserializes the RosterItem data.
		 *
		 * @param	node The XML node associated this data
		 * @return An indicator as to whether deserialization was successful
		 */
		public function deserialize( node:XML ):Boolean
		{
			node = node;
			return true;
		}

		public function get groupCount():int
		{
			return node.group.children().length();
		}

		/**
		 * Gets a list of all the groups associated with this roster item.
		 *
		 * @return An array of strings containing the name of each group
		 */
		public function get groupNames():Array
		{
			var names:Array = [];

			for each ( var group:XML in node.group.children() )
			{
				names.push( group.text() );
			}
			return names;
		}

		/**
		 * The JID for this roster item.
		 *
		 */
		public function get jid():EscapedJID
		{
			return new EscapedJID( node.@jid );
		}

		public function set jid( value:EscapedJID ):void
		{
			node.@jid = value.toString();
		}

		/**
		 * The display name for this roster item.
		 *
		 */
		public function get name():String
		{
			return node.@name;
		}

		public function set name( value:String ):void
		{
			node.@name = value;
		}

		/**
		 * Convenience routine to determine if a roster item is considered "pending" or not.
		 */
		public function get pending():Boolean
		{
			if ( askType == RosterExtension.ASK_TYPE_SUBSCRIBE && ( subscription ==
				RosterExtension.SUBSCRIBE_TYPE_NONE || subscription == RosterExtension.SUBSCRIBE_TYPE_FROM ) )
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public function removeAllGroups():void
		{
			delete node.group;
		}

		/**
		 * Remove a group by the given name.
		 * @param	groupName
		 * @return
		 */
		public function removeGroupByName( groupName:String ):Boolean
		{
			var len:uint = node.group.child(groupName).length();
			delete node.group.child(groupName);
			return len != node.group.child(groupName).length();
		}

		/**
		 * Serializes the RosterItem data to XML for sending.
		 *
		 * @param	parent The parent node that this item should be serialized into
		 * @return An indicator as to whether serialization was successful
		 */
		public function serialize( parent:XML ):Boolean
		{
			if ( !exists( jid ) )
			{
				trace( "Warning: required roster item attributes 'jid' missing" );
				return false;
			}

			if ( parent != node.parent() )
			{
				parent.appendChild( node );
			}

			return true;
		}

		/**
		 * The subscription type for this roster item. Subscription types
		 * have been enumerated by static variables in the RosterExtension:
		 * <ul>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_NONE</li>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_TO</li>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_FROM</li>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_BOTH</li>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_REMOVE</li>
		 * </ul>
		 *
		 */
		public function get subscription():String
		{
			return node.@subscription;
		}

		public function set subscription( value:String ):void
		{
			node.@subscription = value;
		}
	}

}
