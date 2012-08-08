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
package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * XEP-0012: Last Activity
	 *
	 * <p>It is often helpful to know the time of the last
	 * activity associated with a entity. The canonical
	 * usage is to discover when a disconnected user last
	 * accessed its server. The 'jabber:iq:last' namespace
	 * provides a method for retrieving that information.
	 * The 'jabber:iq:last' namespace can also be used to
	 * discover or publicize when a connected user was
	 * last active on the server (i.e., the user's idle
	 * time) or to query servers and components about
	 * their current uptime.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0012.html
	 */
	public class LastActivityExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:last";
		public static const ELEMENT_NAME:String = "query";

		/**
		 *
		 * @param	parent
		 */
		public function LastActivityExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return LastActivityExtension.NS;
		}

		public function getElementName():String
		{
			return LastActivityExtension.ELEMENT_NAME;
		}

		/**
		 * Required address of the content.
		 */
		public function get seconds():uint
		{
			return parseInt(getAttribute("seconds"));
		}
		public function set seconds( value:uint ):void
		{
			setAttribute("seconds", value.toString());
		}

		/**
		 * Optional message text.
		 */
		public function get text():String
		{
			xml.normalize();
			if (xml.children().length() > 0)
			{
				return xml.children().toXMLString();
			}
			return null;
		}
		public function set text( value:String ):void
		{
			if (value == null)
			{
				xml.setChildren("");
			}
			else
			{
				xml.setChildren(value);
			}
			xml.normalize();
		}
	}
}
