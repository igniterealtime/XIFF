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
	public class MUCBaseExtension extends Extension implements IExtendable, INodeProxy
	{

		/**
		 *
		 * @param	parent
		 */
		public function MUCBaseExtension( parent:XML = null )
		{
			super(parent);
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

			return item;
		}

		/**
		 * Item interface to MUCItems if they are contained in this extension
		 *
		 * @return Array of MUCItem objects
		 */
		public function get items():Array
		{
			var list:Array = [];
			for each( var child:XML in xml.children() )
			{
				if ( child.localName() == MUCItem.ELEMENT_NAME )
				{
					var item:MUCItem = new MUCItem();
					item.xml = child;
					list.push( item );
				}
			}
			return list;
		}
		public function set items( value:Array ):void
		{
			removeFields(MUCItem.ELEMENT_NAME);

			if ( value != null )
			{
				var len:uint = value.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var item:MUCItem = value[i] as MUCItem;
					xml.appendChild( item.xml );
				}
			}
		}
	}
}
