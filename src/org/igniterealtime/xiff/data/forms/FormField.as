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

	

	/**
	 * This class is used by the FormExtension class for managing fields
	 * as fields have multiple behaviors depending on the type of the form
	 * while containing different kinds of data, some optional some not.
	 *
	 *
	 * @see	org.igniterealtime.xiff.data.forms.FormExtension
	 * @see	http://xmpp.org/extensions/xep-0004.html
	 * @param	parent The parent XML
	 */
	public class FormField extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "field";

		public function FormField( type:String = null, varName:String = null, values:Array = null, options:Array = null, label:String = null, desc:String = null, required:Boolean = false )
		{
			super();
			
			xml.setLocalName( ELEMENT_NAME );

			this.type = type;
			this.varName = varName;
			this.values = values;
			this.options = options;
			this.label = label;
			this.desc = desc;
			this.required = required;
		}

		/**
		 * The var of this field used to uniquely identify the field in the context of the form.
		 *
		 * Note: this serializes to the <code>var</code> attribute on the field node.
		 * Since <code>var</code> is a reserved word in ActionScript
		 * this field uses <code>varName</code> to describe the var of this field.
		 */
		public function get varName():String
		{
			var list:XMLList = xml.attribute("var");
			if ( list.length() > 0 )
			{
				return list[0];
			}
			return null;
		}
		public function set varName( value:String ):void
		{
			if ( value == null )
			{
				delete xml.attribute("var");
			}
			else
			{
				xml.attribute("var")[0] = value;
			}
		}

		/**
		 * The type of this field used by user interfaces to render an approprite
		 * control to represent this field.
		 *
		 * May be one of the following:
		 *
		 * <code>FormFieldType.BOOLEAN</code>
		 * <code>FormFieldType.FIXED</code>
		 * <code>FormFieldType.HIDDEN</code>
		 * <code>FormFieldType.JID_MULTI</code>
		 * <code>FormFieldType.JID_SINGLE</code>
		 * <code>FormFieldType.LIST_MULTI</code>
		 * <code>FormFieldType.LIST_SINGLE</code>
		 * <code>FormFieldType.TEXT_MULTI</code>
		 * <code>FormFieldType.TEXT_PRIVATE</code>
		 * <code>FormFieldType.TEXT_SINGLE</code>
		 *
		 * @see	http://xmpp.org/extensions/xep-0004.html#protocol-fieldtypes
		 */
		public function get type():String
		{
			var list:XMLList = xml.attribute("type");
			if ( list.length() > 0 )
			{
				return list[0];
			}
			return null;
		}
		public function set type( value:String ):void
		{
			if ( value == null && xml.attribute("type").length() > 0)
			{
				delete xml.attribute("type")[0];
			}
			else
			{
				xml.@type = value;
			}
		}

		/**
		 * A human-readable name for the field.
		 */
		public function get label():String
		{
			var list:XMLList = xml.attribute("label");
			if ( list.length() > 0 )
			{
				return list[0];
			}
			return null;
		}
		public function set label( value:String ):void
		{
			if ( value == null && xml.attribute("label").length() > 0)
			{
				delete xml.attribute("label")[0];
			}
			else
			{
				xml.@label = value;
			}
		}

		/**
		 * A natural-language description of the field, intended for presentation in a user-agent
		 * (e.g., as a "tool-tip", help button, or explanatory text provided near the field).
		 */
		public function get desc():String
		{
			var list:XMLList = xml.children().(localName() == "desc");
			if ( list.length() > 0 )
			{
				return list[0];
			}
			return null;
		}
		public function set desc( value:String ):void
		{
			if ( value == null && xml.children().(localName() == "desc").length() > 0)
			{
				delete xml.children().(localName() == "desc")[0];
			}
			else
			{
				xml.desc = value;
			}
		}

		/**
		 * If true, flags the field as required in order for the form to be considered valid.
		 */
		public function get required():Boolean
		{
			return xml.children().(localName() == "required").length() > 0;
		}
		public function set required( value:Boolean ):void
		{
			if ( !value )
			{
				delete xml.children().(localName() == "required")[0];
			}
			else
			{
				xml.required = "";
			}
		}

		/**
		 * The chosen value for this field. In forms with a type
		 * <code>FormType.FORM</code> this is typically the default
		 * value of the field.
		 *
		 * Applies to the following field types:
		 *
		 * <code>FormFieldType.BOOLEAN</code>
		 * <code>FormFieldType.FIXED</code>
		 * <code>FormFieldType.HIDDEN</code>
		 * <code>FormFieldType.JID_SINGLE</code>
		 * <code>FormFieldType.LIST_SINGLE</code>
		 * <code>FormFieldType.LIST_MULTI</code>
		 * <code>FormFieldType.TEXT_PRIVATE</code>
		 * <code>FormFieldType.TEXT_SINGLE</code>
		 *
		 * Suggested values can typically be retrieved in <code>getAllOptions</code>
		 *
		 */
		public function get value():String
		{
			var list:XMLList = xml.children().(localName() == "value");
			if ( list.length() > 0 )
			{
				return list[0];
			}
			return null;
		}
		public function set value( value:String ):void
		{
			if ( value == null && xml.children().(localName() == "value").length() > 0)
			{
				delete xml.children().(localName() == "value")[0];
			}
			else
			{
				xml.value = value;
			}
		}

		/**
		 * The values for this multiple field.  In forms with a type
		 * <code>FormType.FORM</code> these are typically the existing
		 * values of the field.
		 *
		 * Applies to the following field types:
		 *
		 * <code>FormFieldType.JID_MULTI</code>
		 * <code>FormFieldType.LIST_MULTI</code>
		 * <code>FormFieldType.TEXT_MULTI</code>
		 *
		 * Array containing strings representing the values of this field
		 */
		public function get values():Array
		{
			var result:Array = [];
			
			var list:XMLList = xml.children().(localName() == "value");
			for each ( var node:XML in list )
			{
				result.push( node.toString() );
			}
			return result;
		}
		public function set values( value:Array ):void
		{
			delete xml.value;

			for each (var i:String in value)
			{
				var option:XML = <value>{ i }</value>;
				xml.appendChild(option);
			}
		}

		/**
		 * If options are provided for possible selections of the value they are listed here.
		 *
		 * Applies to the following field types:
		 *
		 * <code>FormFieldType.JID_MULTI</code>
		 * <code>FormFieldType.JID_SINGLE</code>
		 * <code>FormFieldType.LIST_MULTI</code>
		 * <code>FormFieldType.LIST_SINGLE</code>
		 *
		 * Array of objects with the properties <code>label</code> and <code>value</code>, {label, value}.
		 */
		public function get options():Array
		{
			var result:Array = [];
			
			var list:XMLList = xml.children().(localName() == "options");
			for each ( var node:XML in list )
			{
				result.push( { value: node.toString(), label: node.@label.toString() } );
			}
			return result;
		}
		public function set options( value:Array ):void
		{
			delete xml.option;

			for each (var i:Object in value)
			{
				var option:XML = <option>{ i.value }</option>;
				option.@label = i.label;
				xml.appendChild(option);
			}
		}

	}
}
