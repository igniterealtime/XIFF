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
package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.IExtension;


	/**
	 * Implements <a href="http://xmpp.org/extensions/xep-0030.html">XEP-0030</a>
	 * for service item discovery.
	 * @see http://xmpp.org/extensions/xep-0030.html
	 */
	public class ItemDiscoExtension extends DiscoExtension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/disco#items";

		/**
		 *
		 * @param	parent
		 */
		public function ItemDiscoExtension( parent:XML=null )
		{
			super( parent );
		}

		public function getElementName():String
		{
			return DiscoExtension.ELEMENT_NAME;
		}

		public function getNS():String
		{
			return ItemDiscoExtension.NS;
        }
		
		/**
		 *
		 * @param	item
		 * @return
		 */
		public function addItem( item:DiscoItem ):DiscoItem
		{
			xml.appendChild( item.xml );
			return item;
		}

		/**
		 * An array of DiscoItems that represent the items discovered.
		 *
		 * @see org.igniterealtime.xiff.data.disco.DiscoItem
		 */
		public function get items():Array
		{
			var items:Array = [];
			for each( var child:XML in xml.children() )
			{
				if ( child.localName() == DiscoItem.ELEMENT_NAME )
				{
					var item:DiscoItem = new DiscoItem();
					item.xml = child;
					items.push( item );
				}
			}
			return items;
		}
		public function set items( value:Array ):void
		{
			removeFields(DiscoItem.ELEMENT_NAME);
			
			if (value == null)
			{
				return;
			}
			
			var len:uint = value.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var item:DiscoItem = value[i] as DiscoItem;
				xml.appendChild( item.xml );
			}
		}

	}
}
