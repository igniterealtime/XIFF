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
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;

	

	/**
	 * Implements <a href="http://xmpp.org/extensions/xep-0030.html">XEP-0030</a>
	 * for service item discovery.
	 * @see http://xmpp.org/extensions/xep-0030.html
	 */
	public class ItemDiscoExtension extends DiscoExtension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/disco#items";

		private var _items:Array;

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
	     * Registers this extension with the extension registry for it to be used,
		 * in case incoming data matches the ELEMENT_NAME and NS.
	     */
		public static function enable():void
		{
			ExtensionClassRegistry.register( ItemDiscoExtension );
		}

		/**
		 * An array of objects that represent the items discovered
		 *
		 * <p>The objects in the array have the following possible
		 * attributes:</p>
		 *
		 * <ul>
		 * <li><code>jid</code>: the resource name</li>
		 * <li><code>node</code>: a path to a resource that can be discovered
		 * without a JID</li>
		 * <li><code>name</code>: the friendly name of the jid</li>
		 * <li><code>action</code>: the kind of action that occurs during
		 * publication of services it can be either "remove" or "update"</li>
		 * </ul>
		 */
		public function get items():Array
		{
			return _items;
		}

		/**
		 *
		 */
		public function set items( value:Array ):void
		{
			_items = value;
		}

		override public function set xml( node:XML ):void
		{
			super.xml = node;

			_items = [];

			for each( var child:XML in xml.children() )
			{
				switch( child.localName() )
				{
					case "item":
						var item:DiscoItem = new DiscoItem( xml );
						item.xml = child;
						_items.push( item );
						break;
				}
			}
		}

		/**
		 *
		 * @param	item
		 * @return
		 */
		public function addItem( item:DiscoItem ):DiscoItem
		{
			_items.push( item );
			return item;
		}

	}
}
