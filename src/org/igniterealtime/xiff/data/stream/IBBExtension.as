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
package org.igniterealtime.xiff.data.stream
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * XEP-0047: In-Band Bytestreams, Version 2.0 (2012-06-22)
	 *
	 * <p>Base class of all IBB classes that are using same namespace.
	 * Do not use this directly.</p>
	 *
	 * <p>Generally, in-band bytestreams SHOULD be used only as a
	 * last resort. SOCKS5 Bytestreams will almost always be preferable,
	 * but are not implemented in XIFF...</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0047.html
	 */
	public class IBBExtension extends Extension
	{
		public static const NS:String = "http://jabber.org/protocol/ibb";

		/**
		 * @param	parent
		 */
		public function IBBExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return IBBExtension.NS;
		}

		/**
		 * The REQUIRED 'sid' attribute defines a unique session
		 * ID for this IBB session (which MUST match the NMTOKEN
		 * datatype).
		 *
		 * <p>All of the extending classes require this property
		 * to be set.</p>
		 */
		public function get sid():String
		{
			return getAttribute("sid");
		}
		public function set sid( value:String ):void
		{
			setAttribute("sid", value);
		}
	}
}
