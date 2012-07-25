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
	 * Resource Binding as defined in RFC 6120: Section 7.
	 *
	 * <p>After a client authenticates with a server, it MUST bind a specific
	 * resource to the stream so that the server can properly address the
	 * client.</p>
	 * <p>That is, there MUST be an XMPP resource associated with the
	 * bare JID (<strong>localpart&#64;domainpart</strong>) of the client, so that the address
	 * for use over that stream is a full JID of the form
	 * <strong>localpart&#64;domainpart/resource</strong> (including the resourcepart).  This
	 * ensures that the server can deliver XML stanzas to and receive XML
	 * stanzas from the client in relation to entities other than the server
	 * itself or the client's account.</p>
	 *
	 * @see http://tools.ietf.org/html/rfc6120#section-7
	 */
	public class BindExtension extends Extension implements IExtension
	{
		public static const NS:String = "urn:ietf:params:xml:ns:xmpp-bind";
		public static const ELEMENT_NAME:String = "bind";


		/**
		 * Support for resource binding is REQUIRED in XMPP client and server
		 * implementations.
		 *
		 * @param	parent
		 */
		public function BindExtension( parent:XML = null)
		{
			super(parent);
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
		 * JID that the server has accepted. Read-only.
		 */
		public function get jid():EscapedJID
		{
			var value:String = getField("jid");
			if ( value != null )
			{
				return new EscapedJID(value);
			}
			return null;
		}

		/**
		 * Resource.
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 *
		 * <p>Instead of asking the server to generate a resourcepart on its behalf,
		 * a client MAY attempt to submit a resourcepart that it has generated or
		 * that the controlling user has provided.</p>
		 *
		 * @see http://tools.ietf.org/html/rfc6120#section-7.7
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
