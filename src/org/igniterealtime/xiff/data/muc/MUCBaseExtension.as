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
	import org.igniterealtime.xiff.data.*;
	
	/**
	 * Implements the base functionality shared by all MUC extensions
	 *
	 * @see http://xmpp.org/extensions/xep-0045.html
	 * @param	parent (Optional) The containing XML for this extension
	 */
	public class MUCBaseExtension extends Extension implements IExtendable, ISerializable
	{
		private var _items:Array = [];
	
		public function MUCBaseExtension( parent:XML = null )
		{
			super(parent);
		}
	
		override public function set xml( node:XML ):void
		{
			super.xml = node;
			removeAllItems();
	
			for each( var child:XML in node.children() )
			{
				switch( child.localName() )
				{
					case "item":
						var item:MUCItem = new MUCItem(xml);
						item.xml = child;
						_items.push(item);
						break;
	
					default:
						var extClass:Class = ExtensionClassRegistry.lookup(child.@xmlns);
						if (extClass != null)
						{
							var ext:IExtension = new extClass();
							if (ext != null)
							{
								if (ext is ISerializable)
								{
									ISerializable(ext).xml = child;
								}
								addExtension(ext);
							}
						}
						break;
				}
			}
		}
	
		/**
		 * Item interface to MUCItems if they are contained in this extension
		 *
		 * @return Array of MUCItem objects
		 */
		public function getAllItems():Array
		{
			return _items;
		}
	
		/**
		 * Use this method to create a new item.  Either the affiliation or role are requried.
		 *
		 * @param	affiliation A predefined string defining the affiliation the JID or nick has in relation to the room
		 * @param	role The role the jid or nick has in the room
		 * @param	nick The nickname of the new item
		 * @param	jid The jid of the new item
		 * @param	actor The user that is actually creating the request
		 * @param	reason The reason why the action associated with this item is being preformed
		 * @return The newly created MUCItem
		 */
		public function addItem(affiliation:String=null, role:String=null, nick:String=null, jid:EscapedJID=null, actor:String=null, reason:String=null):MUCItem
		{
			var item:MUCItem = new MUCItem(xml);
	
			item.affiliation = affiliation;
			item.role = role;
			item.nick = nick;
			item.jid = jid;
			item.reason = reason;
			
			if (actor != null)
			{
				item.actor = new EscapedJID(actor);
			}
			
			_items.push(item);
			return item;
		}
		
		/**
		 * Use this method to remove all items.
		 *
		 */
		public function removeAllItems():void
		{
			var len:uint = _items.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var item:MUCItem = _items[i] as MUCItem;
				var parent:XML = item.xml.parent();
				if (parent != null)
				{
					var index:int = parent.(child() == item.xml).childIndex();
					delete parent.children()[index];
				}
			}
		 	_items = [];
		}
	}
}
