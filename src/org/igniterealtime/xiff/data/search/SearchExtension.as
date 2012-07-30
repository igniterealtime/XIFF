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
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.forms.FormExtension;

	/**
	 * XEP-0055: Jabber Search
	 *
	 * <p>Implements jabber:iq:search namespace. Use this to perform user searches.</p>
	 *
	 * <p>Send an empty IQ.TYPE_GET packet with this extension and the return will either be
	 * a conflict, or the fields you will need to fill out.</p>
	 *
	 * <p>Send a IQ.TYPE_SET packet to the server and with the fields that are listed in
	 * getRequiredFieldNames set on this extension.</p>
	 *
	 * <p>Check the result and re-establish the connection with the new account.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0055.html
	 */
	public class SearchExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:search";
		public static const ELEMENT_NAME:String = "query";

		private var _fields:Object = {};

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

		override public function set xml( node:XML ):void
		{
			super.xml = node;

			for each ( var child:XML in node.children() )
			{
				var local:String = child.localName();
				if (local != "x" && local != "item")
				{
					_fields[child.localName()] = child;
				}

				// Refactor this out...
				if (local == "x")
				{
					if (child.namespace().uri == FormExtension.NS)
					{
						var dataFormExt:FormExtension = new FormExtension(xml);
						dataFormExt.xml = child;
						addExtension(dataFormExt);
					}
				}

			}

		}

		/**
		 * TODO rename to getter
		 */
		public function getRequiredFieldNames():Array
		{
			var fields:Array = [];

			for (var i:String in _fields)
			{
				fields.push(i);
			}

			return fields;
		}

		/**
		 * List of SearchItem in this query.
		 *
		 * @return
		 */
		public function get items():Array
		{
			var items:Array = [];

			var list:XMLList = xml.children().(localName() == SearchItem.ELEMENT_NAME);
			for each ( var child:XML in list )
			{
				var item:SearchItem = new SearchItem();
				item.xml = child;
				items.push(item);
			}
			return items;
		}
		public function set fields( value:Array ):void
		{
			removeFields(SearchItem.ELEMENT_NAME);

			if ( value != null )
			{
				var len:uint = value.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var item:SearchItem = value[i] as SearchItem;
					xml.appendChild( item.xml );
				}
			}
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
