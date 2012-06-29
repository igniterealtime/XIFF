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
package org.igniterealtime.xiff.data.search
{
	
	
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
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
	public class SearchExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:search";
		public static const ELEMENT_NAME:String = "query";
	
		private var _fields:Object = {};
		private var _items:Array = [];
	
	    private static var staticDepends:Class = ExtensionClassRegistry;
	
		/**
		 *
		 * @param	parent (Optional) The parent node used to build the XML tree.
		 */
		public function SearchExtension( parent:XML = null )
		{
			super(parent);
		}
	
		public function getNS():String
		{
			return SearchExtension.NS;
		}
	
		public function getElementName():String
		{
			return SearchExtension.ELEMENT_NAME;
		}
	
	    /**
	     * Performs the registration of this extension into the extension registry.
	     */
	    public static function enable():void
	    {
	        ExtensionClassRegistry.register(SearchExtension);
	    }
		
	
		override public function set xml( node:XML ):void
		{
			super.xml = node;
	
			for each ( var child:XML in node.children() )
			{
	
				switch (child.localName())
				{
						
					case "x":
						if (child.namespace().uri == FormExtension.NS)
						{
							var dataFormExt:FormExtension = new FormExtension(xml);
							dataFormExt.xml = child;
							addExtension(dataFormExt);
						}
						break;
						
					case "item":
						var item:SearchItem = new SearchItem(xml);
						item.xml = child;
						_items.push(item);
						break;
	
					default:
						_fields[child.localName()] = child;
						break;
				}
			}
	
		}
	
		public function getRequiredFieldNames():Array
		{
			var fields:Array = [];
	
			for (var i:String in _fields)
			{
				fields.push(i);
			}
	
			return fields;
		}
		
		public function getAllItems():Array
		{
			return _items;
		}
	
		/**
		 * Use <code>null</code> to remove.
		 */
		public function get instructions():String
		{
			return getField("instructions");
		}
		public function set instructions(value:String):void
		{
			setField("instructions", value);
		}
	}
}
