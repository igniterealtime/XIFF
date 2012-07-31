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
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;
	
	/**
	 * This class is used internally by the RosterExtension class for managing items
	 * received and sent as roster data. Usually, each item in the roster represents a single
	 * contact, and this class is used to represent, abstract, and serialize/deserialize
	 * this data.
	 *
	 * @see	org.igniterealtime.xiff.data.im.RosterExtension
	 * @see http://xmpp.org/extensions/xep-0144.html
	 * @see http://tools.ietf.org/html/rfc3921#section-8
	 */
	public class RosterItem extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "item";
		
		/**
		 *
		 * @param	parent The parent XML
		 */
		public function RosterItem( parent:XML = null )
		{
			super();
			
			xml.setLocalName( ELEMENT_NAME );
			
			if ( parent != null )
			{
				parent.appendChild( xml );
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
			var node:XML = <group>{ groupName }</group>;
			xml.appendChild(node);
		}
		
		/**
		 * Gets a list of all the groups associated with this roster item.
		 *
		 * @return An array of strings containing the name of each group
		 */
		public function get groupNames():Array
		{
			var list:Array = [];
			var groups:XMLList = xml.children().(localName() == "group");
			
			for each ( var item:XML in groups )
			{
				list.push( item );
			}
			return list;
		}
		
		/**
		 * Get the number of <code>group</code> elements in this roster item.
		 */
		public function get groupCount():int
		{
			return xml.children().(localName() == "group").length();
		}
		
		/**
		 * Remove all group elements
		 */
		public function removeAllGroups():void
		{
			removeFields("group");
		}
		
		/**
		 * Remove a single group with the given name
		 * @param	groupName
		 * @return
		 */
		public function removeGroupByName( groupName:String ):Boolean
		{
			var groups:XMLList = xml.children().(localName() == "group");
			var index:int = -1;
			
			for each ( var item:XML in groups )
			{
				if (item.contains(groupName))
				{
					index = item.childIndex();
					break;
				}
			}
			
			if (index !== -1)
			{
				delete xml.group.children()[index];
				return true;
			}
			
			return false;
		}
		
		/**
		 * The JID for this roster item.
		 * Required.
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
		public function set jid( value:EscapedJID ):void
		{
			setAttribute("jid", value != null ? value.toString() : null);
		}
		
		/**
		 * The display name for this roster item.
		 *
		 */
		public function get name():String
		{
			return getAttribute("name");
		}
		public function set name( value:String ):void
		{
			setAttribute("name", value);
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
		 * @see http://tools.ietf.org/html/rfc3921#section-8.1
		 */
		public function get subscription():String
		{
			return getAttribute("subscription");
		}
		public function set subscription( value:String ):void
		{
			setAttribute("subscription", value);
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
			return getAttribute("ask");
		}
		public function set askType( value:String ):void
		{
			setAttribute("ask", value);
		}
		
		/**
		 * Convenience routine to determine if a roster item is considered "pending" or not.
		 */
		public function get pending():Boolean
		{
		 	if (askType == RosterExtension.ASK_TYPE_SUBSCRIBE &&
				(subscription == RosterExtension.SUBSCRIBE_TYPE_NONE ||
				subscription == RosterExtension.SUBSCRIBE_TYPE_FROM))
			{
		 		return true;
		 	}
		 	else
			{
		 		return false;
		 	}
		}
	}
	
}
