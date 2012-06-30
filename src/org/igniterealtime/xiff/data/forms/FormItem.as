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
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	

	public class FormItem extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "item";

		private var _fields:Array = [];

		public function FormItem( parent:XML=null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if( parent != null )
			{
				parent.appendChild( xml );
			}
		}

		override public function set xml( node:XML ):void
		{
			super.xml = node;

			for each( var c:XML in node.children() )
			{
				switch( c.localName() )
				{
					case "field":
						var field:FormField = new FormField();
						field.xml = c;
						_fields.push( field );
						break;
				}
			}
		}

		/**
		 * Use this method to remove all fields.
		 */
		public function removeAllFields():void
		{
			for each( var field:FormField in _fields )
			{
				for each( var f:* in field )
				{
					delete f.xml;
				}
			}
			_fields = [];
		}

		/**
		 * Item interface to array of fields if they are contained in a "field" element
		 *
		 * @return Array of FormFields objects
		 */
		public function get fields():Array
		{
			return _fields;
		}

		/**
		 * @private
		 */
		public function set fields( value:Array ):void
		{
			removeAllFields();

			_fields = value;
		}

	}
}