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
package org.igniterealtime.xiff.data.rpc
{
	/**
	 * Implements client side XML marshalling of methods and parameters into XMLRPC.
	 *
	 * @see http://xmpp.org/extensions/xep-0009.html
	 * @see http://www.xmlrpc.com/spec
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
		public static function fromXML(xml:XML):Array
		{
			var result:Array;
			var response:XML = findNode("methodResponse", xml);

			if (response.hasOwnProperty("fault"))
			{
				// methodResponse/fault/value/struct
				result = extractValue(response..struct);
				result.isFault = true;
			}
			else
			{
				result = [];
				var params:XML = findNode("params", response);
				if (params != null)
				{
					for each (var param:XML in params.children())
					{
						for each (var child:XML in param.children())
						{
							result.push(extractValue(child.toString()));
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
		public static function toXML(parent:XML, method:String, params:Array):XML
		{
			var mc:XML = addNode(parent, "methodCall");
			addText(addNode(mc, "methodName"), method);

			var p:XML = addNode(mc, "params");
			for (var i:int = 0; i < params.length; ++i)
			{
				addParameter(p, params[i]);
			}

			return mc;
		}

		private static function extractValue(value:XML):*
		{
			var result:* = null;

			switch (value.localName())
			{
				case "int":
				case "i4":
				case "double":
					result = Number(value.toString());
					break;

				case "boolean":
					result = Number(value.toString()) ? true : false;
					break;

				case "array":
					var value_array:Array = [];
					for each (var next_value:XML in value.children())
					{
						value_array.push(extractValue(next_value.toString()));
					}
					result = value_array;
					break;

				case "struct":
					var value_object:Object = {};
					for each (var member:XML in value.children())
					{
						var m_name:String = member.children()[0].toString();
						var m_value:* = extractValue(member.children()[1].toString());
						value_object[m_name] = m_value;
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

		private static function addParameter(node:XML, param:*):XML
		{
			return addValue(addNode(node, "param"), param);
		}

		private static function addValue(node:XML, value:*):XML
		{
			var value_node:XML = addNode(node, "value");
			var type:String = typeof(value);

			if (type == "string")
			{
				addText(addNode(value_node, "string"), value);

			}
			else if (type == "number")
			{
				if (Math.floor(value) != value)
				{
					addText(addNode(value_node, "double"), value);
				}
				else
				{
					addText(addNode(value_node, "int"), value.toString());
				}

			}
			else if (type == "boolean")
			{
				addText(addNode(value_node, "boolean"), value == false ? "0" : "1");
			}
			else if (value is Array)
			{
				var data:XML = addNode(addNode(value_node, "array"), "data");
				for (var i:int = 0; i < value.length; ++i)
				{
					addValue(data, value[i]);
				}
			}
			else if (type == "object")
			{
				// Special case where type is simple custom type is defined
				if (value.type != undefined && value.value != undefined)
				{
					addText(addNode(value_node, value.type), value.value);
				}
				else
				{
					var struct:XML = addNode(value_node, "struct");
					for (var attr:String in value)
					{
						var member:XML = addNode(struct, "member");
						addText(addNode(member, "name"), attr);
						addValue(member, value[attr]);
					}
				}
			}

			return node;
		}

		private static function addNode(parent:XML, name:String):XML
		{
			var child:XML = <{ name }/>;
			parent.appendChild(child);
			return child;
		}

		private static function addText(parent:XML, value:String):XML
		{
			parent.appendChild(value);
			return parent.children()[parent.children().length() - 1];
		}

		/**
		 * Find an element that has the given name within and including the
		 * candidate XML.
		 *
		 * @param	name
		 * @param	candidate
		 * @return
		 */
		private static function findNode(name:String, candidate:XML):XML
		{
			if (candidate.localName() == name)
			{
				return candidate;
			}
			else
			{
				var found:XML = null;
				for each (var child:XML in candidate.children())
				{
					found = findNode(name, child);
					if (found != null)
					{
						return found;
					}
				}
			}
			return null;
		}

	}
}
