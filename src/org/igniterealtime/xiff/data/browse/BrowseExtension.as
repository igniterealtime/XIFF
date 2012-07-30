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
package org.igniterealtime.xiff.data.browse
{
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * XEP-0011: Jabber Browsing
	 *
	 * <p>Implements jabber:iq:browse namespace.  Use this extension to request the items
	 * of an agent or service such as the rooms of a conference server or the members of
	 * a room.</p>
	 *
	 * <p><strong>OBSOLETE</strong></p>
	 *
	 * @see http://xmpp.org/extensions/xep-0011.html
	 */
	public class BrowseExtension extends BrowseItem implements IExtension
	{
		public static const NS:String = "jabber:iq:browse";
		public static const ELEMENT_NAME:String = "query";

		/**
		 *
		 * @param	parent
		 */
		public function BrowseExtension( parent:XML = null )
		{
			super(parent);

			xml.setLocalName( getElementName() );
			xml.setNamespace( getNS() );
		}

		/**
		 * Gets the namespace associated with this extension.
		 * The namespace for the BrowseExtension is "jabber:iq:browse".
		 *
		 * @return The namespace
		 */
		public function getNS():String
		{
			return BrowseExtension.NS;
		}

		/**
		 * Gets the element name associated with this extension.
		 * The element for this extension is "query".
		 */
		public function getElementName():String
		{
			return BrowseExtension.ELEMENT_NAME;
		}

		/**
		 * If you are generating a browse response to a browse request, then
		 * fill out the items list with this method.
		 *
		 * @param	item BrowseItem which contains the info related to the browsed resource
		 * @return	the item added
		 * @see	org.igniterealtime.xiff.data.browse.BrowseItem
		 */
		public function addItem(item:BrowseItem):BrowseItem
		{
			xml.appendChild(item.xml);
			return item;
		}

		/**
		 * An array of BrowseItems containing information about the browsed resource
		 *
		 * @return	array of BrowseItem
		 * @see	org.igniterealtime.xiff.data.browse.BrowseItem
		 */
		public function get items():Array
		{
			var list:Array = [];
			for each (var child:XML in xml.children())
			{
				if ( child.localName() == BrowseItem.ELEMENT_NAME )
				{
					var item:BrowseItem = new BrowseItem();
					item.xml = child;
					list.push(item);
				}
			}
			return list;
		}
	}
}
