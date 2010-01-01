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
package org.igniterealtime.xiff.data.browse
{
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;

	/**
	 * Implements jabber:iq:browse namespace. Use this extension to request the items
	 * of an agent or service such as the rooms of a conference server or the members of
	 * a room.
	 * OBSOLETE
	 * @see http://xmpp.org/extensions/xep-0011.html
	 */
	public class BrowseExtension extends BrowseItem implements IExtension, ISerializable
	{
		public static const ELEMENT_NAME:String = "query";

		public static const NS:String = "jabber:iq:browse";

		private static var staticDepends:Class = ExtensionClassRegistry;

		private var _items:Array = [];

		public function BrowseExtension( parent:XML = null )
		{
			super( parent );

			node.setName( BrowseExtension.ELEMENT_NAME );
			node.setNamespace( BrowseExtension.NS );
		}

		/**
		 * Performs the registration of this extension into the extension registry.
		 */
		public static function enable():void
		{
			ExtensionClassRegistry.register( BrowseExtension );
		}

		public function getNS():String
		{
			return BrowseExtension.NS;
		}
		
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
		public function addItem( item:BrowseItem ):BrowseItem
		{
			_items.push( item );
			return item;
		}

		/**
		 * ISerializable implementation which saves this extension to XML
		 *
		 * @see	org.igniterealtime.xiff.data.ISerializable
		 */
		override public function deserialize( node:XML ):Boolean
		{
			node = node;

			this[ 'deserialized' ] = true;

			_items = [];

			for each ( var child:XML in node.children() )
			{
				switch ( child.name() )
				{
					case "item":
						var item:BrowseItem = new BrowseItem( node );
						item.deserialize( child );
						_items.push( item );
						break;
				}
			}
			return true;
		}

		/**
		 * An array of BrowseItems containing information about the browsed resource
		 *
		 * @return	array of BrowseItems
		 * @see	org.igniterealtime.xiff.data.browse.BrowseItem
		 */
		public function get items():Array
		{
			return _items;
		}

		/**
		 * ISerializable implementation which loads this extension from XML
		 *
		 * @see	org.igniterealtime.xiff.data.ISerializable
		 */
		override public function serialize( parentNode:XML ):Boolean
		{
			var node:XML = node;
			for each ( var item:BrowseItem in _items )
			{
				item.serialize( node );
			}

			if ( node.parent() != undefined )
			{
				parentNode.appendChild( node.copy() );
			}

			return true;
		}
	}
}
