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
	import org.igniterealtime.xiff.data.XMPPStanza;

	/**
	 * XEP-0047: In-Band Bytestreams, Version 2.0 (2012-06-22)
	 *
	 * <p>Open the communication</p>
	 *
	 * <p>It is RECOMMENDED to send IBB data using IQ stanzas
	 * instead of message stanzas because IQ stanzas provide
	 * feedback to the sender regarding delivery to the recipient).</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0047.html
	 */
	public class IBBOpenExtension extends IBBExtension implements IExtension
	{
		public static const ELEMENT_NAME:String = "open";

		/**
		 * The recommended values for <code>blockSize</code> (4096) and
		 * <code>stanza</code> ("iq") are set by default.
		 *
		 * @param	parent
		 */
		public function IBBOpenExtension( parent:XML = null )
		{
			super(parent);

			blockSize = 4096;
			stanza = XMPPStanza.ELEMENT_IQ;
		}

		public function getElementName():String
		{
			return IBBOpenExtension.ELEMENT_NAME;
		}

		/**
		 * The REQUIRED 'block-size' attribute defines the maximum
		 * size in bytes of each data chunk (which MUST NOT be
		 * greater than 65535).
		 *
		 * @default 4096
		 */
		public function get blockSize():uint
		{
			return parseInt(getAttribute("block-size"));
		}
		public function set blockSize( value:uint ):void
		{
			setAttribute("block-size", value.toString());
		}

		/**
		 * The OPTIONAL 'stanza' attribute defines whether the
		 * data will be sent using <code>IQ</code> stanzas or
		 * <code>Message</code> stanzas.
		 *
		 * @default iq
		 */
		public function get stanza():String
		{
			return getAttribute("stanza");
		}
		public function set stanza( value:String ):void
		{
			setAttribute("stanza", value);
		}
	}
}
