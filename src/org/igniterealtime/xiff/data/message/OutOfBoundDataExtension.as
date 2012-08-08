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
package org.igniterealtime.xiff.data.message
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * XEP-0066: Out of Band Data
	 *
	 * <p>While the given XEP defined two namespaces ('jabber:iq:oob' and
	 * 'jabber:x:oob'), this implementation only uses the latter
	 * ('jabber:x:oob') which is used within <code>Message</code> or
	 * <code>Presence</code>.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0066.html#x-oob
	 */
	public class OutOfBoundDataExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:x:oob";
		public static const ELEMENT_NAME:String = "x";

		/**
		 * The 'jabber:x:oob' namespace is used to communicate a URI
		 * to another user or application.
		 *
		 * <p>This is done by including
		 * an <strong>x</strong> child element qualified by the
		 * 'jabber:x:oob' namespace in either a <strong>message</strong>
		 * and <strong>presence</strong> stanza; the <strong>x</strong>
		 * child MUST contain a <strong>url</strong> child specifying
		 * the URL of the resource, and MAY contain an optional
		 * <strong>desc</strong> child describing the resource.</p>
		 *
		 * @param	parent
		 */
		public function OutOfBoundDataExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return OutOfBoundDataExtension.NS;
		}

		public function getElementName():String
		{
			return OutOfBoundDataExtension.ELEMENT_NAME;
		}

		/**
		 * Required address of the content.
		 */
		public function get url():String
		{
			return getField("url");
		}
		public function set url( value:String ):void
		{
			setField("url", value);
		}

		/**
		 * Optional description about the content at the given URL.
		 */
		public function get description():String
		{
			return getField("desc");
		}
		public function set description( value:String ):void
		{
			setField("desc", value);
		}
	}
}
