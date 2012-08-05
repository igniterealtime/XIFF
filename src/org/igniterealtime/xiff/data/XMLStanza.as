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
		 * XMPP is based on communication with XML stanzas
		 */
		public function XMLStanza()
		{
			super();
		}
		
		/**
		 * Convinience method for getting element value from the XML.
		 *
		 * <p>Might seem over complex, but AS3 seems to handle different kind of
		 * XML differently, thus shorthands and even methods such as <code>localName()</code>
		 * do not work as expected.</p>
		 *
		 * @param	name
		 * @return
		 */
		public function getField( name:String ):String
		{
			if ( xml[name].length() > 0 )
			{
				return xml[name][0];
			}
			
			for each (var child:XML in xml.children())
			{
				if (child.localName() == name)
				{
					return child.toString();
				}
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
			if ( value == null )
			{
				removeFields(name);
			}
			else
			{
				xml[name] = value;
			}
		}
		
		/**
		 * Convinience method for getting child element value from the XML.
		 *
		 * <p>Might seem over complex, but AS3 seems to handle different kind of
		 * XML differently, thus shorthands and even methods such as <code>localName()</code>
		 * do not work as expected.</p>
		 *
		 * @param	elem
		 * @param	name
		 * @return
		 */
		public function getChildField( elem:String, name:String ):String
		{
			if (elem == null || name == null)
			{
				return null;
			}
			
			var list:XMLList = xml.children().(localName() == elem);
			if (list.length() > 0 && list[0].children().length() > 0)
			{
				for each (var child:XML in list[0].children())
				{
					if (child.localName() == name)
					{
						return child.toString();
					}
				}
			}
			
			return null;
		}
		
		/**
		 * Convinience method for setting a value for a child element of the XML.
		 *
		 * @param	elem
		 * @param	name
		 * @param	value
		 */
		public function setChildField( elem:String, name:String, value:String ):void
		{
			if (elem == null || name == null)
			{
				throw new Error("Both 'elem' and 'name' should be set for XMLStanza.setChildField");
			}
			
			var list:XMLList = xml.children().(localName() == elem);
			if (list.length() > 0)
			{
				xml[elem][name] = value;
			}
		}
		
		/**
		 * Convinience method for getting element value from the XML.
		 * @param	name
		 * @return
		 */
		public function getAttribute( name:String ):String
		{
			if ( xml.@[name] )
			{
				return xml.@[name];
			}
			// Namespaces confuse
			var list:XMLList = xml.attribute( name );
			if ( list.length() > 0 )
			{
				return list[0];
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
			if ( value == null )
			{
				delete xml.@[name];
				var list:XMLList = xml.attribute( name);
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
		 * Convinience method for getting child element attribute value from the XML.
		 * @param	elem
		 * @param	name
		 * @return
		 */
		public function getChildAttribute( elem:String, name:String ):String
		{
			if (elem == null || name == null)
			{
				return null;
			}
			
			var list:XMLList = xml.children().(localName() == elem);
			if (list.length() > 0)
			{
				return list[0].@[name];
			}
			
			return null;
		}
		
		/**
		 * Convinience method for setting an attribute for a child element of the XML.
		 *
		 * <p>In case the child element does not exist, it will be created.</p>
		 *
		 * @param	elem
		 * @param	name
		 * @param	value
		 */
		public function setChildAttribute( elem:String, name:String, value:String ):void
		{
			if (elem == null || name == null)
			{
				throw new Error("Both 'elem' and 'name' should be set for XMLStanza.setChildAttribute");
			}
			
			var list:XMLList = xml.children().(localName() == elem);
			if (list.length() > 0)
			{
				xml.children().(localName() == elem)[0].@[name] = value;
			}
			else
			{
				xml[elem] = "";
				xml[elem].@[name] = value;
			}
		}
		
		/**
		 * Helper method for removing all child elements that have the given name.
		 */
		public function removeFields( name:String ):void
		{
			while ( xml.children().(localName() == name).length() > 0 )
			{
				delete xml.children().(localName() == name)[0];
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
