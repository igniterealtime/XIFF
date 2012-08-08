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
	import org.igniterealtime.xiff.data.forms.enum.*;

	/**
	 * This class is used by the FormExtension class for managing fields
	 * as fields have multiple behaviors depending on the type of the form
	 * while containing different kinds of data, some optional some not.
	 *
	 * @see	org.igniterealtime.xiff.data.forms.FormExtension
	 * @see	http://xmpp.org/extensions/xep-0004.html
	 */
	public class FormField extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "field";

		/**
		 *
		 * @param	type
		 * @param	varName
		 * @param	values
		 * @param	options
		 * @param	label
		 * @param	desc
		 * @param	required
		 */
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
			return getAttribute("var");
		}
		public function set varName( value:String ):void
		{
			setAttribute("var", value);
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
			return getAttribute("type");
		}
		public function set type( value:String ):void
		{
			var list:Array = [
				FormFieldType.BOOLEAN,
				FormFieldType.FIXED,
				FormFieldType.HIDDEN,
				FormFieldType.JID_MULTI,
				FormFieldType.JID_SINGLE,
				FormFieldType.LIST_MULTI,
				FormFieldType.LIST_SINGLE,
				FormFieldType.TEXT_MULTI,
				FormFieldType.TEXT_PRIVATE,
				FormFieldType.TEXT_SINGLE
			];
			if (value == null || list.indexOf(value) !== -1)
			{
				setAttribute("type", value);
			}
			else
			{
				throw new Error("Not allowed value for FormField.type");
			}
		}

		/**
		 * A human-readable name for the field.
		 */
		public function get label():String
		{
			return getAttribute("label");
		}
		public function set label( value:String ):void
		{
			setAttribute("label", value);
		}

		/**
		 * A natural-language description of the field, intended for presentation in a user-agent
		 * (e.g., as a "tool-tip", help button, or explanatory text provided near the field).
		 */
		public function get desc():String
		{
			return getField("desc");
		}
		public function set desc( value:String ):void
		{
			setField("desc", value);
		}

		/**
		 * If true, flags the field as required in order for the form to be considered valid.
		 */
		public function get required():Boolean
		{
			return getField("required") != null;
		}
		public function set required( value:Boolean ):void
		{
			if ( !value )
			{
				removeFields("required");
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
		 * <p>Suggested values can typically be retrieved in <code>getAllOptions</code></p>
		 *
		 */
		public function get value():String
		{
			return getField("value");
		}
		public function set value( value:String ):void
		{
			setField("value", value);
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
			removeFields("value");

			for each (var i:String in value)
			{
				var option:XML = <value>{ i }</value>;
				xml.appendChild(option);
			}
		}

		/**
		 * If options are provided for possible selections of the value they are listed here.
		 *
		 * <p>Applies to the following field types:</p>
		 *
		 * <code>FormFieldType.LIST_MULTI</code>
		 * <code>FormFieldType.LIST_SINGLE</code>
		 *
		 * <p>Array of objects with the properties <code>label</code> and <code>value</code>, {label, value}.</p>
		 *
		 * <p>The <strong>option</strong> element MUST contain one and only one
		 * <strong>value</strong> child. If the field is not of type "list-single"
		 * or "list-multi", it MUST NOT contain an <strong>option</strong> element.</p>
		 */
		public function get options():Array
		{
			var result:Array = [];

			var list:XMLList = xml.children().(localName() == "option");
			for each ( var node:XML in list )
			{
				result.push( { value: node.value.toString(), label: node.@label.toString() } );
			}
			return result;
		}
		public function set options( value:Array ):void
		{
			removeFields("option");

			for each (var i:Object in value)
			{
				var option:XML = <option><value>{ i.value }</value></option>;
				option.@label = i.label;
				xml.appendChild(option);
			}
		}

	}
}
