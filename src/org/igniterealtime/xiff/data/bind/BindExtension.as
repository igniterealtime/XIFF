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
package org.igniterealtime.xiff.data.bind
{

	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.*;

	/**
	 * @see http://xmpp.org/extensions/xep-0193.html
	 */
	public class BindExtension extends Extension implements IExtension, ISerializable
	{
		public static const ELEMENT_NAME:String = "bind";
		
		public static const NS:String = "urn:ietf:params:xml:ns:xmpp-bind";

		/**
		 * 
		 * @param	parent
		 */
		public function BindExtension( parent:XML = null )
		{
			super( parent );
		}

		public function getNS():String
		{
			return BindExtension.NS;
		}
		
		public function getElementName():String
		{
			return BindExtension.ELEMENT_NAME;
		}
		
		/**
		 * Registers this extension with the extension registry.
		 */
		public static function enable():void
		{
			ExtensionClassRegistry.register( BindExtension );
		}

		public function serialize( parent:XML ):Boolean
		{
			parent.appendChild( node );
			
			return true;
		}

		public function deserialize( node:XML ):Boolean
		{
			node = node;
			
			return true;
		}

		/**
		 *
		 */
		public function get jid():EscapedJID
		{
			var value:EscapedJID;
			if (node.jid.length() > 0)
			{
				value = new EscapedJID(node.jid.text());
			}
			return value;
		}

		/**
		 *
		 */
		public function get resource():String
		{
			return node.resource.text();
		}
		public function set resource( value:String ):void
		{
			node.resource = value;
		}
	}
}
