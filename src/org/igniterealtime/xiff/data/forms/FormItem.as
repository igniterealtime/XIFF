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
package org.igniterealtime.xiff.data.forms
{
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;


	/**
	 *
	 * @see http://xmpp.org/extensions/xep-0004.html
	 */
	public class FormItem extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "item";


		public function FormItem( parent:XML=null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if( parent != null )
			{
				parent.appendChild( xml );
			}
		}

		/**
		 * Item interface to array of fields if they are contained in a "field" element
		 *
		 * @return Array of FormFields objects
		 */
		public function get fields():Array
		{
			var list:Array = [];
			for each( var child:XML in xml.children() )
			{
				if ( child.localName() == FormField.ELEMENT_NAME )
				{
					var item:FormField = new FormField();
					item.xml = child;
					list.push( item );
				}
			}
			return list;
		}
		public function set fields( value:Array ):void
		{
			removeFields(FormField.ELEMENT_NAME);

			if ( value != null )
			{
				var len:uint = value.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var item:FormField = value[i] as FormField;
					xml.appendChild( item.xml );
				}
			}
		}

	}
}
