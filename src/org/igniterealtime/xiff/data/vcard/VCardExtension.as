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
package org.igniterealtime.xiff.data.vcard
{
	
	
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	
	/**
	 * XEP-0054: vcard-temp
	 *
	 * <p>The basic functionality is for a user to store and retrieve an XML
	 * representation of his or her vCard using the data storage capabilities
	 * native to all existing Jabber server implementations. This is done
	 * by by sending an <strong>iq</strong> of type "set" (storage) or "get"
	 * (retrieval) to one's Jabber server containing a <strong>vCard</strong>
	 * child scoped by the 'vcard-temp' namespace, with the <strong>vCard</strong>
	 * element containing the actual vCard-XML elements as defined by the
	 * vCard-XML DTD. Other users may then view one's vCard information.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0054.html
	 */
	public class VCardExtension extends Extension implements IExtension
	{
		public static const NS:String = "vcard-temp";
		public static const ELEMENT_NAME:String = "vCard";
		
		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function VCardExtension( parent:XML = null )
		{
			super(parent);
		}
		
		public function getNS():String
		{
			return VCardExtension.NS;
		}
		
		public function getElementName():String
		{
			return VCardExtension.ELEMENT_NAME;
		}
	
	}
}
