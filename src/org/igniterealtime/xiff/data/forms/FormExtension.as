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
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;

	

	/**
	 * Implements the base functionality of XEP-0004: Data Forms,
	 * shared by all MUC extensions
	 *
	 * @see http://xmpp.org/extensions/xep-0004.html
	 */
	public class FormExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:x:data";
		public static const ELEMENT_NAME:String = "x";

		//private static var isStaticConstructed:Boolean = enable();
		//private static var staticDependencies:Array = [ ExtensionClassRegistry ];

		private var _reported:FormReported;
		private var _fields:Array = []; // FormField


		/**
		 *
		 * @param	parent
		 */
		public function FormExtension( parent:XML = null )
		{
			super( parent );
		}

		public function getNS():String
		{
			return FormExtension.NS;
		}

		public function getElementName():String
		{
			return FormExtension.ELEMENT_NAME;
		}

		public static function enable():Boolean
		{
			ExtensionClassRegistry.register( FormExtension );
			return true;
		}

		/**
		 * TODO: clean up...
		 */
		override public function set xml( node:XML ):void
		{
			super.xml = node;

			removeAllFields();
			removeAllItems();

			for each( var c:XML in node.children() )
			{
				switch( c.localName() )
				{

					case "reported":
						var reportedItem:FormReported = new FormReported();
						reportedItem.xml =  c;
						_reported = reportedItem;
						break;

					case "field":
						var field:FormField = new FormField();
						field.xml =  c;
						_fields.push( field );
						break;

				}
			}
		}

		/**
		 *
		 * @param	value the name of the form field to retrieve
		 * @return	FormField the matching form field
		 */
		public function getFormField( value:String ):FormField
		{
			for each( var field:FormField in _fields )
			{
				if( field.varName == value )
				{
					return field;
				}
			}
			return null;
		}

		/**
		 * Sets the fields given a fieldMap object containing keys of field vars
		 * and values of value arrays
		 *
		 * @param	fieldMap Object
		 * Format:
		 * { "varName": [ value1, value2, ... ] }
		 */
		public function setFieldMap( fieldMap:Object ):void
		{
			removeAllFields();

			for( var varName:String in fieldMap )
			{
				var field:FormField = new FormField();
				field.varName = varName;
				field.values = fieldMap[ varName ];
				_fields.push( field );
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
		 * Use this method to remove all items.
		 */
		public function removeAllItems():void
		{
			for each( var item:XML in xml.children().(localName() == FormItem.ELEMENT_NAME) )
			{
				var index:uint = item.parent().childIndex();
				delete xml.children()[index];
			}
		}

		/**
		 * The title of this form
		 *
		 */
		public function get title():String
		{
			return getField("title");
		}
		public function set title( value:String ):void
		{
			setField("title", value);
		}

		/**
		 * Natural-language instructions to be followed by the form-submitting entity.
		 *
		 * @return	Array containing instructions.
		 */
		public function get instructions():Array
		{
			var result:Array = [];

			for each ( var valueNode:XML in xml.instructions )
			{
				result.push( valueNode.toString() );
			}
			return result;
		}
		public function set instructions( value:Array ):void
		{
			delete xml.instructions;
			
			for each (var i:String in value)
			{
				var option:XML = <instructions>{ i }</instructions>;
				xml.appendChild(option);
			}
		}

		/**
		 * The type of form.
		 * May be one of the following:
		 *
		 * <code>FormType.FORM</code>
		 * <code>FormType.SUBMIT</code>
		 * <code>FormType.CANCEL</code>
		 * <code>FormType.RESULT</code>
		 */
		public function get type():String
		{
			return getAttribute("type");
		}
		public function set type( value:String ):void
		{
			// TODO ensure it is in the enumeration of "cancel", "form", "result", "submit"
			// TODO Change the behavior of the serialization depending on the type
			xml.@type = value;
		}

		/**
		 * This is an accessor to the hidden field type <code>FORM_TYPE</code>
		 * easily check what kind of form this is.
		 *
		 * @return String the registered namespace of this form type
		 * @see	http://xmpp.org/extensions/xep-0068.html
		 */
		public function get formType():String
		{
			// Most likely at the start of the array
			for each( var field:FormField in _fields )
			{
				if ( field.varName == "FORM_TYPE" )
				{
					return field.value;
				}
			}
			return "";
		}

		/**
		 * An element defining the data format for the result items.
		 *
		 * @return	A FormReported object
		 */
		public function get reported():FormReported
		{
			return _reported;
		}
		public function set reported( value:FormReported ):void
		{
			_reported = value;
		}

		/**
		 * Interface to array of fields.
		 *
		 * @return Array of FormField objects
		 */
		public function get fields():Array
		{
			return _fields;
		}
		public function set fields( value:Array ):void
		{
			removeAllFields();

			_fields = value;
		}

		/**
		 * Interface to array of items.
		 *
		 * @return Array containing Arrays of FormItem objects
		 * @see org.igniterealtime.xiff.data.forms.FormItem
		 */
		public function get items():Array
		{
			var items:Array = [];
			var list:XMLList = xml.children().(localName() == FormItem.ELEMENT_NAME);
			for each ( var child:XML in list )
			{
				var item:FormItem = new FormItem();
				item.xml = child;
				items.push( item );
			}
			return items;
		}
		public function set items( value:Array ):void
		{
			removeAllItems();
			
			var len:uint = value.length;
			for ( var i:uint = 0; i < len; ++i )
			{
				var item:FormItem = value[ i ] as FormItem;
				xml.appendChild( item.xml );
			}
		}

	}
}
