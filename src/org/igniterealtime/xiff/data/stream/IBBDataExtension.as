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
	 * <p>Each chunk of data is contained in a <strong>data</strong>
	 * element qualified by the 'http://jabber.org/protocol/ibb'
	 * namespace. The data element SHOULD be sent in an IQ stanza
	 * to enable proper tracking and throttling, but instead MAY be
	 * sent in a message stanza. The data to be sent, prior to
	 * base64-encoding and prior to any wrapping in XML, MUST NOT
	 * be larger than the 'block-size' determined in the bytestream
	 * negotiation.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0047.html
	 */
	public class IBBDataExtension extends IBBExtension implements IExtension
	{
		public static const ELEMENT_NAME:String = "data";

		/**
		 *
		 *
		 * @param	parent
		 */
		public function IBBDataExtension( parent:XML = null )
		{
			super(parent);

			seq = 0;
		}

		public function getElementName():String
		{
			return IBBDataExtension.ELEMENT_NAME;
		}

		/**
		 * Required property 'seq'.
		 *
		 * <p>This is a 16-bit unsigned
		 * integer that acts as a counter for data chunks sent
		 * in a particular direction within this session.
		 * The 'seq' value starts at 0 (zero) for each sender
		 * and MUST be incremented for each packet sent by that
		 * entity. Thus, the second chunk sent has a 'seq' value
		 * of 1, the third chunk has a 'seq' value of 2, and so
		 * on. The counter loops at maximum, so that after value
		 * 65535 (215 - 1) the 'seq' MUST start again at 0.</p>
		 *
		 * <p>This value can be safely incremented, limit checking
		 * and resetting is imlemented within the setter.</p>
		 */
		public function get seq():uint
		{
			return parseInt(getAttribute("seq"));
		}
		public function set seq( value:uint ):void
		{
			if (value > 65535)
			{
				value = 0;
			}
			setAttribute("seq", value.toString());
		}

		/**
		 * Base64 encoded data
		 */
		public function get data():String
		{
			xml.normalize();
			return xml.children().toXMLString().replace(/\s/mg, "");
		}
		public function set data( value:String ):void
		{
			xml.setChildren(value);
		}
	}
}
