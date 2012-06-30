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
package org.igniterealtime.xiff.data
{
	/**
	 * This is a base class for all classes that encapsulate XML stanza data. It provides
	 * a set of methods that faciliate easy manipulation of XML data.
	 */
	public class XMLStanza extends ExtensionContainer implements IXMLStanza
	{
		/**
		 * Default XML namespace. Must define in AS3.
		 * @see http://www.w3.org/XML/1998/namespace
		 */
		public static const DEFAULT_NS:Namespace = new Namespace("xml", "http://www.w3.org/XML/1998/namespace");
		
		/**
		 * @see http://xmpp.org/protocols/streams/
		 */
		public static const STREAM_NS:Namespace = new Namespace("stream", "http://etherx.jabber.org/streams");
		
		/**
		 * @see http://www.jabber.com/streams/flash
		 */
		public static const FLASH_NS:Namespace = new Namespace("flash", "http://www.jabber.com/streams/flash");
		
		
		/**
		 * Three types can exist:
		 * - message
		 * - presence
		 * - iq
		 * @see http://xmpp.org/rfcs/rfc3920.html#stanzas
		 */
		public function XMLStanza()
		{
			super();
			
		}
		
		/**
		 * Convinience method for getting element value from the XML.
		 * @param	name
		 * @return
		 */
		public function getField( name:String ):String
		{
			var list:XMLList = xml.children().(localName() == name);
			
			if ( list.length() > 0 )
			{
				return list[0];
			}
			
			// Namespaces confuse
			if ( xml[name] )
			{
				return xml[name];
			}
			
			return null;
		}
		
		/**
		 * Convinience method for setting a value to a element in the XML.
		 * @param	name
		 * @param	value
		 */
		public function setField( name:String, value:String ):void
		{
			var list:XMLList = xml.children().(localName() == name);
			
			trace("setField. name: " + name + ", value: " + value + ", list: " + list);
			
			if ( value == null )
			{
				if ( list.length() > 0 )
				{
					delete list[0];
				}
			}
			else
			{
				xml[name] = value;
			}
		}
		
		/**
		 * Convinience method for getting element value from the XML.
		 * @param	name
		 * @return
		 */
		public function getAttribute( name:String ):String
		{
			var list:XMLList = xml.attribute( name );
			if ( list.length() > 0 )
			{
				return list[0];
			}
			// Namespaces confuse
			if ( xml.@[name] )
			{
				return xml.@[name];
			}
			
			return null;
		}
		
		/**
		 * Convinience method for setting a value to a element in the XML.
		 * @param	name
		 * @param	value
		 */
		public function setAttribute( name:String, value:String ):void
		{
			var list:XMLList = xml.attribute( name);
			if ( value == null )
			{
				if ( list.length() > 0 )
				{
					delete list[0];
				}
			}
			else
			{
				xml.@[name] = value;
			}
		}
		
		/**
		 * Converts the base stanza XML to a string.
		 *
		 * @return The base XML in string form, as in <code>toXMLString()</code>
		 */
		public function toString():String
		{
			return xml.toXMLString();
		}
		
	}
}
