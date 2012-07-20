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
package org.igniterealtime.xiff.data.version
{

	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	
	/**
	 * XEP-0092: Software Version
	 *
	 * <p>The 'jabber:iq:version' namespace provides a standard way for Jabber entities
	 * to exchange information about the software version used by the entities.
	 * The information is communicated in a request/response pair using an <code>iq</code>
	 * element that contains a <code>query</code> scoped by the 'jabber:iq:version' namespace.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0092.html
	 */
	public class SoftwareVersionExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:version";
		public static const ELEMENT_NAME:String = "query";
		
		/**
		 *
		 * @param	parent
		 */
		public function SoftwareVersionExtension( parent:XML = null )
		{
			super(parent);
		}
		
		public function getNS():String
		{
			return SoftwareVersionExtension.NS;
		}
		
		public function getElementName():String
		{
			return SoftwareVersionExtension.ELEMENT_NAME;
		}
		
		/**
		 * The natural-language name of the software.
		 * This element is REQUIRED in a result.
		 *
		 * @exampleText XIFF
		 */
		public function get name():String
		{
			return getField("name");
		}
		public function set name(value:String):void
		{
			setField("name", value);
		}

		/**
		 * The specific version of the software.
		 * This element is REQUIRED in a result.
		 *
		 * @exampleText 3.1.0
		 */
		public function get version():String
		{
			return getField("version");
		}
		public function set version(value:String):void
		{
			setField("version", value);
		}

		/**
		 * The operating system of the queried entity.
		 * This element is OPTIONAL in a result, mind the
		 * Security Considerations.
		 *
		 * @exampleText Windows OS 3.11
		 * @see http://xmpp.org/extensions/xep-0092.html#security
		 */
		public function get os():String
		{
			return getField("os");
		}
		public function set os(value:String):void
		{
			setField("os", value);
		}

	}
}
