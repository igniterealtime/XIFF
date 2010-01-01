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
package org.igniterealtime.xiff.data
{
	/**
	 * This is a base class for all classes that encapsulate XML stanza data.
	 * It provides a set of methods that faciliate easy manipulation of XML data.
	 */
	public class XMLStanza extends ExtensionContainer implements IExtendable
	{
		/**
		 * The local data container whose name will be overwritten.
		 */
		private var _node:XML = <node/>;

		/**
		 * <p>Three types can exist:</p>
		 * <ul>
		 * <li>message</li>
		 * <li>presence</li>
		 * <li>iq</li>
		 * </ul>
		 * @see http://xmpp.org/rfcs/rfc3920.html#stanzas
		 */
		public function XMLStanza()
		{
			super();
		}

		/**
		 * A helper method to determine if a value is both not null
		 * and not undefined.
		 *
		 * @param	value The value to check for existance
		 * @return Whether the value checked is both not null and not undefined
		 */
		public static function exists( value:* ):Boolean
		{
			if ( value != null && value !== undefined )
			{
				return true;
			}

			return false;
		}

		/**
		 * Adds a simple text node to the parent node specified.
		 *
		 * @param	parent The parent node that the newly created node should be appended onto
		 * @param	elementName The element name of the new node
		 * @param	value The value of the new node
		 * @return A reference to the new node
		 */
		public function addTextNode( parent:XML, elementName:String, value:String ):XML
		{
			var newNode:XML = <{ elementName }/>;
			newNode.appendChild( value );
			parent.appendChild( newNode );
			return newNode;
		}

		/**
		 * Replaces one node in the stanza with another simple text node.
		 *
		 * @param	parent The parent node to start at when searching for replacement
		 * @param	original The node to replace
		 * @param	elementName The new node's element name
		 * @param	value The new node's value
		 * @return The newly created node
		 */
		public function replaceTextNode( parent:XML, original:XML, elementName:String, value:String ):XML
		{
			var newNode:XML;

			// XXX Investigate on whether a remove/create is as efficient
			// as replacing the contents of the first text element nodeValue

			// Through the magic of AS, this will not fail if the
			// original node is undefined

			if ( original != null )
			{
				original = null;
			}

			if ( exists( value ))
			{
				newNode = <{ elementName }/>;
				if ( value.length > 0 )
				{
					newNode.appendChild( value );
				}
				parent.appendChild( newNode );
			}

			return newNode;
		}

		/**
		 * The XML node that should be used for this stanza's internal XML representation.
		 */
		public function get node():XML
		{
			return _node;
		}
		public function set node( node:XML ):void
		{
			// Transfer ownership from the node's parent to our old parent
			_node = node;

			if ( exists( _node ) && _node.parent() !== undefined )
			{
				_node.parent().appendChild( _node );
			}
		}
	}
}
