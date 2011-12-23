/*
 * Copyright (C) 2003-2011 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
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

	import flash.xml.XMLNode;

	/**
	 * This class is used by the FormExtension class for managing fields
	 * as fields have multiple behaviors depending on the type of the form
	 * while containing different kinds of data, some optional some not.
	 *
	 *
	 * @see	org.igniterealtime.xiff.data.forms.FormExtension
	 * @see	http://xmpp.org/extensions/xep-0004.html
	 * @param	parent The parent XMLNode
	 */
	public class FormField extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "field";

		private var descNode:XMLNode;
		private var requiredNode:XMLNode;
		private var valueNodes:Array;
		private var optionNodes:Array;

		public function FormField()
		{
			super();
		}

		/**
		 * Serializes the FormField data to XML for sending.
		 *
		 * @param	parent The parent node that this item should be serialized into
		 * @return An indicator as to whether serialization was successful
		 */
		public function serialize( parent:XMLNode ):Boolean
		{
			getNode().nodeName = FormField.ELEMENT_NAME;

			if( parent != getNode().parentNode )
			{
				parent.appendChild( getNode().cloneNode( true ) );
			}

			return true;
		}

		/**
		 * Deserializes the FormField data.
		 *
		 * @param	node The XML node associated this data
		 * @return An indicator as to whether deserialization was successful
		 */
		public function deserialize( node:XMLNode ):Boolean
		{
			setNode( node );

			valueNodes = [];
			optionNodes = [];

			var children:Array = node.childNodes;

			for( var i:String in children )
			{
				var c:XMLNode = children[ i ];

				switch( children[ i ].nodeName )
				{
					case "desc":
						descNode = c;
						break;
					case "required":
						requiredNode = c;
						break;
					case "value":
						valueNodes.push( c );
						break;
					case "option":
						optionNodes.push( c );
						break;
				}
			}

			return true;
		}

		/**
		 * The var of this field used by the application or server.
		 *
		 * Note: this serializes to the <code>var</code> attribute on the field node.
		 * Since <code>var</code> is a reserved word in ActionScript
		 * this field uses <code>varName</code> to describe the var of this field.
		 *
		 */
		public function get varName():String
		{
			return getNode().attributes[ "var" ];
		}

		public function set varName( value:String ):void
		{
			getNode().attributes[ "var" ] = value;
		}

		/**
		 * The type of this field used by user interfaces to render an approprite
		 * control to represent this field.
		 *
		 * May be one of the following:
		 *
		 * <code>FormExtension.FIELD_TYPE_BOOLEAN</code>
		 * <code>FormExtension.FIELD_TYPE_FIXED</code>
		 * <code>FormExtension.FIELD_TYPE_HIDDEN</code>
		 * <code>FormExtension.FIELD_TYPE_JID_MULTI</code>
		 * <code>FormExtension.FIELD_TYPE_JID_SINGLE</code>
		 * <code>FormExtension.FIELD_TYPE_LIST_MULTI</code>
		 * <code>FormExtension.FIELD_TYPE_LIST_SINGLE</code>
		 * <code>FormExtension.FIELD_TYPE_TEXT_MULTI</code>
		 * <code>FormExtension.FIELD_TYPE_TEXT_PRIVATE</code>
		 * <code>FormExtension.FIELD_TYPE_TEXT_SINGLE</code>
		 *
		 * @see	http://xmpp.org/extensions/xep-0004.html#protocol-fieldtypes
		 */
		public function get type():String
		{
			return getNode().attributes.type;
		}

		public function set type( value:String ):void
		{
			getNode().attributes.type = value;
		}

		/**
		 * The label of this field used by user interfaces to render a descriptive
		 * title of this field
		 *
		 */
		public function get label():String
		{
			return getNode().attributes.label;
		}

		public function set label( value:String ):void
		{
			getNode().attributes.label = value;
		}

		/**
		 * The chosen value for this field.  In forms with a type
		 * <code>FormExtension.TYPE_REQUEST</code> this is typically the default
		 * value of the field.
		 *
		 * Applies to the following field types:
		 *
		 * <code>FormExtension.FIELD_TYPE_BOOLEAN</code>
		 * <code>FormExtension.FIELD_TYPE_FIXED</code>
		 * <code>FormExtension.FIELD_TYPE_HIDDEN</code>
		 * <code>FormExtension.FIELD_TYPE_JID_SINGLE</code>
		 * <code>FormExtension.FIELD_TYPE_LIST_SINGLE</code>
		 * <code>FormExtension.FIELD_TYPE_LIST_MULTI</code>
		 * <code>FormExtension.FIELD_TYPE_TEXT_PRIVATE</code>
		 * <code>FormExtension.FIELD_TYPE_TEXT_SINGLE</code>
		 *
		 * Suggested values can typically be retrieved in <code>getAllOptions</code>
		 *
		 */
		public function get value():String
		{
			try
			{
				if( valueNodes[ 0 ] != null && valueNodes[ 0 ].firstChild != null )
					return valueNodes[ 0 ].firstChild.nodeValue;
			}
			catch( error:Error )
			{
				trace( error.getStackTrace() );
			}
			return null;
		}

		public function set value( value:String ):void
		{
			if( valueNodes == null ) valueNodes = [];

			valueNodes[ 0 ] = replaceTextNode( getNode(), valueNodes[ 0 ], "value", value );
		}

		/**
		 * The values for this multiple field.  In forms with a type
		 * <code>FormExtension.TYPE_REQUEST</code> these are typically the existing
		 * values of the field.
		 *
		 * Applies to the following field types:
		 *
		 * <code>FormExtension.FIELD_TYPE_JID_MULTI</code>
		 * <code>FormExtension.FIELD_TYPE_LIST_MULTI</code>
		 * <code>FormExtension.FIELD_TYPE_TEXT_MULTI</code>
		 *
		 * @return	Array containing strings representing the values of this field
		 */
		public function getAllValues():Array
		{
			var res:Array = [];

			for each( var valueNode:XMLNode in valueNodes )
			{
				res.push( valueNode.firstChild.nodeValue );
			}
			return res;
		}

		/**
		 * Sets all the values of this field from an array of strings
		 *
		 * @param	value Array of Strings
		 */
		public function setAllValues( value:Array ):void
		{
			for each( var v:XMLNode in valueNodes )
			{
				v.removeNode();
			}

			valueNodes = value.map( function( value:String, index:uint, arr:Array ):*
			{
				return replaceTextNode( getNode(), undefined, "value", value );
			} );
		}

		/**
		 * If options are provided for possible selections of the value they are listed
		 * here.
		 *
		 * Applies to the following field types:
		 *
		 * <code>FormExtension.FIELD_TYPE_JID_MULTI</code>
		 * <code>FormExtension.FIELD_TYPE_JID_SINGLE</code>
		 * <code>FormExtension.FIELD_TYPE_LIST_MULTI</code>
		 * <code>FormExtension.FIELD_TYPE_LIST_SINGLE</code>
		 *
		 * @return	Array of objects with the properties <code>label</code> and <code>value</code>
		 */
		public function getAllOptions():Array
		{
			return optionNodes.map( function( optionNode:XMLNode, index:uint, arr:Array ):Object
			{
				return { label: optionNode.attributes.label, value: optionNode.firstChild.firstChild.nodeValue };
			} );
		}

		/**
		 * Sets all the options available from an array of objects
		 *
		 * @param	Array containing objects with the properties <code>label</code> and
		 * <code>value</code>
		 */
		public function setAllOptions( value:Array ):void
		{
			for each( var optionNode:XMLNode in optionNodes )
			{
				optionNode.removeNode();
			}

			optionNodes = value.map( function( v:Object, index:uint, arr:Array ):XMLNode
			{
				var option:XMLNode = replaceTextNode( getNode(), undefined, "value", v.value );
				option.attributes.label = v.label;
				return option;
			} );
		}

	}
}