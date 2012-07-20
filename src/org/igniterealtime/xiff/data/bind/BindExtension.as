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
package org.igniterealtime.xiff.data.bind
{
	import org.igniterealtime.xiff.core.EscapedJID;
        import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.XMLStanza;
	
	/**
         * XEP-0193: Proposed Resource Binding Improvements
         *
         * <p><strong>OBSOLETE</strong></p>
         *
	 * @see http://xmpp.org/extensions/xep-0193.html
	 */
	public class BindExtension extends Extension implements IExtension
	{
		public static const NS:String = "urn:ietf:params:xml:ns:xmpp-bind";
		public static const ELEMENT_NAME:String = "bind";
		
		
		/**
		 *
		 * @param	parent
		 */
		public function BindExtension( parent:XML = null)
		{
			super(parent);
			
			resource = "xiff"; // default
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
		 * JID. Not sure if the setter should be available...
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 */
		public function get jid():EscapedJID
		{
			var list:XMLList = xml.children().(localName() == "jid");
			if (list.length() > 0)
			{
				return new EscapedJID(list[0]);
			}
			return null;
		}
		public function set jid( value:EscapedJID ):void
		{
			if ( value == null )
			{
				delete xml.jid;
			}
			else
			{
				xml.jid = value;
			}
		}
		
		/**
		 * Resource.
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 */
		public function get resource():String
		{
			return getField("resource");
		}
		public function set resource( value:String ):void
		{
			setField("resource", value);
		}
		
	}
}
