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
	import org.igniterealtime.xiff.data.INodeProxy;
	

	/**
	 * XEP-0030: Service Discovery
	 *
	 * <p>Base class for service discovery extensions.</p>
	 *
	 * @see http://xmpp.org/protocols/disco/
	 * @see http://xmpp.org/extensions/xep-0030.html
	 */
	public class DiscoExtension extends Extension implements INodeProxy
    {
		public static const ELEMENT_NAME:String = "query";

		/**
		 * The name of the resource of the service queried if the resource
		 * doesn't have a JID.
		 *
		 * @see http://www.jabber.org/registrar/disco-nodes.html
		 */
		public function DiscoExtension( parent:XML )
		{
			super( parent );
		}

		/**
		 *
		 */
		public function get node():String
		{
			return getAttribute("node");
		}
		public function set node( value:String ):void
		{
			setAttribute("node", value);
		}

	}
}
