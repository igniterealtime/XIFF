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
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.forms.FormExtension;

	/**
	 * Implements jabber:iq:search namespace.  Use this to perform user searches.
	 * Send an empty IQ.TYPE_GET packet with this extension and the return will either be
	 * a conflict, or the fields you will need to fill out.
	 * Send a IQ.TYPE_SET packet to the server and with the fields that are listed in
	 * getRequiredFieldNames set on this extension.
	 * Check the result and re-establish the connection with the new account.
	 * @see http://xmpp.org/extensions/xep-0055.html
	 */
	public class SearchExtension extends Extension implements IExtension, ISerializable
	{
		public static const ELEMENT_NAME:String = "query";

		public static const NS:String = "jabber:iq:search";

		private static var staticDepends:Class = ExtensionClassRegistry;

		private var _fields:Object = {};

		private var _instructionsNode:XML;

		private var _items:Array = [];

		/**
		 *
		 * @param	parent (Optional) The parent node used to build the XML tree.
		 */
<<<<<<< .mine
		public function SearchExtension( parent:XML = null )
=======
		public function SearchExtension( parent:XMLNode = null )
>>>>>>> .r11468
		{
			super( parent );
		}

		/**
		 * Performs the registration of this extension into the extension registry.
		 */
		public static function enable():void
		{
			ExtensionClassRegistry.register( SearchExtension );
		}

		public function deserialize( node:XML ):Boolean
		{
			node = node;

			for each ( var child:XML in node.children() )
			{

				switch ( child.name() )
				{
					case "instructions":
						_instructionsNode = child;
						break;

					case "x":
						if ( child.@xmlns == FormExtension.NS )
						{
							var dataFormExt:FormExtension = new FormExtension( node );
							dataFormExt.deserialize( child );
							addExtension( dataFormExt );
						}
						break;

					case "item":
						var item:SearchItem = new SearchItem( node );
						item.deserialize( child );
						_items.push( item );
						break;

					default:
						_fields[ child.name() ] = child;
						break;
				}
			}
			return true;

		}

		public function getAllItems():Array
		{
			return _items;
		}

		public function getElementName():String
		{
			return SearchExtension.ELEMENT_NAME;
		}

		public function getField( name:String ):String
		{
			var node:XML = _fields[ name ];
			if ( node && node[0] )
			{
				return node[0].toString();
			}

			return null;
		}

		public function getNS():String
		{
			return SearchExtension.NS;
		}

		public function getRequiredFieldNames():Array
		{
			var fields:Array = [];

			for ( var i:String in _fields )
			{
				fields.push( i );
			}

			return fields;
		}

		public function get instructions():String
		{
			return node.instructions.text();
		}

		public function set instructions( value:String ):void
		{
			node.instructions = value;
		}

		public function serialize( parentNode:XML ):Boolean
		{
			if ( !exists( node.parent() ) )
			{
				parentNode.appendChild( node.copy() );
			}
			return true;
		}

		public function setField( name:String, value:String ):void
		{
			_fields[ name ] = replaceTextNode( node, _fields[ name ], name,
											   value );
		}
	}
}
