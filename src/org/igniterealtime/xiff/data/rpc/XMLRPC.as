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
package org.igniterealtime.xiff.data.rpc
{

	/**
	 * Implements client side XML marshalling of methods and parameters into XMLRPC.
	 * For more information on RPC over XMPP, see <a href="http://xmpp.org/extensions/xep-0009.html">
	 * http://xmpp.org/extensions/xep-0009.html</a>.
	 */
	public class XMLRPC
	{
		/**
		 * Extract and marshall the XML-RPC response to Flash types.
		 *
		 * @param	xml The XML containing the message response
		 * @return Mixed object of either an array of results from the method call or a fault.
		 * If the result is a fault, "result.isFault" will evaulate as true.
		 */
		public static function fromXML( xml:XML ):Array
		{
			var result:Array;
			var response:XML = findNode( "methodResponse", xml );

			if ( response[0].name() == "fault" )
			{
				// methodResponse/fault/value/struct
				result = extractValue( response[0].firstChild.firstChild );
				result.isFault = true;
			}
			else
			{
				result = [];
				var params:XML = findNode( "params", response );
				if ( params != null )
				{
					for ( var param_idx:int = 0; param_idx < params.children().length; param_idx++ )
					{
						var param:Array = params.children()[ param_idx ].firstChild;

						for ( var type_idx:int = 0; type_idx < param.children().length; type_idx++ )
						{
							result.push( extractValue( param.children()[ type_idx ] ) );
						}
					}
				}
			}
			return result;
		}

		/**
		 * The marshalling process, accepting a block of XML, a string description of the remote method,
		 * and an array of flash type parameters.
		 *
		 * @return XML containing the XML marshalled result
		 */
		public static function toXML( parent:XML, method:String, params:Array ):XML
		{
			var mc:XML = addNode( parent, "methodCall" );
			addText( addNode( mc, "methodName" ), method );

			var p:XML = addNode( mc, "params" );
			for ( var i:int = 0; i < params.length; ++i )
			{
				addParameter( p, params[ i ] );
			}

			return mc;
		}

		private static function addNode( parent:XML, name:String ):XML
		{
			var child:XML = <{ name }/>;
			parent.appendChild( child );
			return parent.lastChild;
		}

		private static function addParameter( node:XML, param:* ):XML
		{
			return addValue( addNode( node, "param" ), param );
		}

		private static function addText( parent:XML, value:String ):XML
		{
			var child:XML = <{ value }/>;
			parent.appendChild( child );
			return parent.lastChild;
		}

		private static function addValue( node:XML, value:* ):XML
		{
			var value_node:XML = addNode( node, "value" );

			if ( typeof( value ) == "string" )
			{
				addText( addNode( value_node, "string" ), value );

			}
			else if ( typeof( value ) == "number" )
			{
				if ( Math.floor( value ) != value )
				{
					addText( addNode( value_node, "double" ), value );
				}
				else
				{
					addText( addNode( value_node, "int" ), value.toString() );
				}

			}
			else if ( typeof( value ) == "boolean" )
			{
				addText( addNode( value_node, "boolean" ), value == false ? "0" :
						 "1" );

			}
			else if ( value is Array )
			{
				var data:XML = addNode( addNode( value_node, "array" ), "data" );
				for ( var i:int = 0; i < value.length; ++i )
				{
					addValue( data, value[ i ] );
				}
			}
			else if ( typeof( value ) == "object" )
			{
				// Special case where type is simple custom type is defined
				if ( value.type != undefined && value.value != undefined )
				{
					addText( addNode( value_node, value.type ), value.value );
				}
				else
				{
					var struct:XML = addNode( value_node, "struct" );
					for ( var attr:String in value )
					{
						var member:XML = addNode( struct, "member" );
						addText( addNode( member, "name" ), attr );
						addValue( member, value[ attr ] );
					}
				}
			}

			return node;
		}

		private static function extractValue( value:XML ):*
		{
			var result:* = null;

			switch ( value.name() )
			{
				case "int":
				case "i4":
				case "double":
					result = Number( value.toString() );
					break;

				case "boolean":
					result = Number( value.toString() ) ? true : false;
					break;

				case "array":
					var value_array:Array = [];
					var next_value:*;
					for ( var data_idx:int = 0; data_idx < value[0].children().length; data_idx++ )
					{
						next_value = value.firstChild.children()[ data_idx ];
						value_array.push( extractValue( next_value.firstChild ) );
					}
					result = value_array;
					break;

				case "struct":
					var value_object:Object = {};
					for ( var member_idx:int = 0; member_idx < value.children().length; member_idx++ )
					{
						var member:Array = value.children()[ member_idx ];
						var m_name:String = member.children()[ 0 ].firstChild.toString();
						var m_value:* = extractValue( member.children()[ 1 ].firstChild );
						value_object[ m_name ] = m_value;
					}
					result = value_object;
					break;

				case "dateTime.iso8601":
				case "Base64":
				case "string":
				default:
					result = value.toString();
					break;

			}

			return result;
		}

		private static function findNode( name:String, xml:XML ):XML
		{
			if ( xml.name() == name )
			{
				return xml;
			}
			else
			{
				var child:XML = xml.child( name )[0];
				if ( child != null )
				{
					return child;
				}
			}
			return null;
		}
	}
}
