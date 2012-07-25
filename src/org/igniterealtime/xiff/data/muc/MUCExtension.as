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
package org.igniterealtime.xiff.data.muc
{


	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.INodeProxy;

	/**
	 * Implements the base MUC protocol schema from <a href="http://www.xmpp.org/extensions/xep-0045.html">XEP-0045</a> for multi-user chat.
	 *
	 * This extension is typically used to test for the presence of MUC enabled conferencing
	 * service, or a MUC related error condition.
	 *
	 * @see http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUCExtension extends Extension implements IMUCExtension
	{
		public static const NS:String = "http://jabber.org/protocol/muc";
		public static const ELEMENT_NAME:String = "x";


		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function MUCExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return MUCExtension.NS;
		}

		public function getElementName():String
		{
			return MUCExtension.ELEMENT_NAME;
		}


		public function addChildNode( childNode:XML ):void
		{
			xml.appendChild(childNode);
		}

		/**
		 * If a room is password protected, add this extension and set the password.
		 * Use <code>null</code> to remove.
		 */
		public function get password():String
		{
			return getField("password");
		}
		public function set password( value:String ):void
		{
			setField("password", value);
		}

		/**
		 * This is property allows a user to retrieve a server defined collection of previous messages.
		 * Set this property to "true" to retrieve a history of the dicussions.
		 */
		public function get history():Boolean
		{
			return xml.children().(localName() == "history").length() > 0;
		}
		public function set history( value:Boolean ):void
		{
			if (!value)
			{
				delete xml.history;
			}
			else
			{
				xml.history = "";
			}
		}

		/**
		 * Size based condition to evaluate by the server for the maximum
		 * characters to return during history retrieval
		 */
		public function get maxchars():int
		{
			var value:String = getChildAttribute("history", "maxchars");
			if (value == null)
			{
				return NaN; // TODO
			}
			return parseInt(value);
		}
		public function set maxchars( value:int ):void
		{
			setChildAttribute("history", "maxchars", value.toString());
		}

		/**
		 * Protocol based condition for the number of stanzas to return during history retrieval
		 */
		public function get maxstanzas():int
		{
			var value:String = getChildAttribute("history", "maxstanzas");
			if (value == null)
			{
				return NaN; // TODO
			}
			return parseInt(value);
		}
		public function set maxstanzas( value:int ):void
		{
			setChildAttribute("history", "maxstanzas", value.toString());
		}

		/**
		 * Time based condition to retrive all messages for the last N seconds.
		 */
		public function get seconds():Number
		{
			var value:String = getChildAttribute("history", "seconds");
			if (value == null)
			{
				return NaN;
			}
			return parseFloat(value);
		}
		public function set seconds( value:Number ):void
		{
			setChildAttribute("history", "seconds", value.toString());
		}

		/**
		 * Time base condition to retrieve all messages from a given time formatted in the format described in
		 * <a href="http://xmpp.org/extensions/xep-0082.html">XEP-0082</a>.
		 *
		 * @see http://xmpp.org/extensions/xep-0082.html
		 */
		public function get since():String
		{
			return getChildAttribute("history", "since");
		}
		public function set since( value:String ):void
		{
			setChildAttribute("history", "since", value);
		}
	}
}
