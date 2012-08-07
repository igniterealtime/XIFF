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
package org.igniterealtime.xiff.data.si
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.util.DateTimeParser;

	/**
	 * XEP-0096: SI File Transfer.
	 *
	 * <p>To be used within XEP-0095: Stream Initiation</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0096.html
	 */
	public class FileTransferExtension extends Extension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/si/profile/file-transfer";
		public static const ELEMENT_NAME:String = "file";

		/**
		 * The size and name attributes MUST be present in the profile.
		 * The other attributes MAY be present.
		 *
		 * <p>There are two possible child elements of the root: 'desc' and 'range'.
		 * Both are OPTIONAL.</p>
		 *
		 * @param	parent
		 */
		public function FileTransferExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return FileTransferExtension.NS;
		}

		public function getElementName():String
		{
			return FileTransferExtension.ELEMENT_NAME;
		}

		/**
		 * The size, in bytes, of the data to be sent.
		 *
		 * <p>REQUIRED</p>
		 */
		public function get size():uint
		{
			return parseInt(getAttribute("size"));
		}
		public function set size(value:uint):void
		{
			if (isNaN(value))
			{
				setAttribute("size", null);
			}
			else
			{
				setAttribute("size", value.toString());
			}
		}

		/**
		 * The name of the file that the Sender wishes to send.
		 *
		 * <p>REQUIRED</p>
		 */
		public function get name():String
		{
			return getAttribute("name");
		}
		public function set name(value:String):void
		{
			setAttribute("name", value);
		}

		/**
		 * The last modification time of the file.
		 *
		 * <p>This is specified using the DateTime profile as described in XMPP
		 * Date and Time Profiles.</p>
		 *
		 * @see http://xmpp.org/extensions/xep-0082.html
		 */
		public function get date():Date
		{
			var value:String = getAttribute("date");
			if (value != null)
			{
				return DateTimeParser.string2dateTime(value);
			}
			return null;
		}
		public function set date(value:Date):void
		{
			if (value == null)
			{
				setAttribute("date", null);
			}
			else
			{
				setAttribute("date", DateTimeParser.dateTime2string(value));
			}
		}

		/**
		 * The MD5 sum of the file contents.
		 */
		public function get hash():String
		{
			return getAttribute("hash");
		}
		public function set hash(value:String):void
		{
			setAttribute("hash", value);
		}

		/**
		 * Used to provide a sender-generated description of the file so the receiver
		 * can better understand what is being sent. It MUST NOT be sent in the result.
		 */
		public function get desc():String
		{
			return getField("desc");
		}
		public function set desc(value:String):void
		{
			setField("desc", value);
		}

		/**
		 * When <code>range</code> is sent in the offer, it should have no attributes.
		 * This signifies that the sender can do ranged transfers.
		 *
		 * <p>Both <code>rangeOffset</code> and <code>rangeLength</code> attributes are OPTIONAL
		 * on the <code>range</code> element. Sending no attributes is synonymous with not sending
		 * the <code>range</code> element.</p>
		 *
		 * <p>When no <code>range</code> element is sent in the Stream Initiation result, the Sender MUST send
		 * the complete file starting at offset 0. More generally, data is sent over the stream
		 * byte for byte starting at the offset position for the length specified.</p>
		 */
		public function get hasRange():Boolean
		{
			return getField("range") != null;
		}
		public function set hasRange(value:Boolean):void
		{
			if (value)
			{
				setField("range", "");
			}
			else
			{
				setField("range", null);
			}
		}

		/**
		 * Specifies the position, in bytes, to start transferring the file data from.
		 * This defaults to zero (0) if not specified.
		 *
		 * <p>When a Stream Initiation result is sent with the <code>range</code> element, it uses this property.</p>
		 */
		public function get rangeOffset():uint
		{
			return parseInt(getChildAttribute("range", "offset"));
		}
		public function set rangeOffset(value:uint):void
		{
			if (isNaN(value))
			{
				setChildAttribute("range", "offset", null);
			}
			else
			{
				setChildAttribute("range", "offset", value.toString());
			}
		}

		/**
		 * Specifies the number of bytes to retrieve starting at offset.
		 * This defaults to the length of the file from offset to the end.
		 *
		 * <p>When a Stream Initiation result is sent with the <code>range</code> element, it uses this property.</p>
		 */
		public function get rangeLength():uint
		{
			return parseInt(getChildAttribute("range", "length"));
		}
		public function set rangeLength(value:uint):void
		{
			if (isNaN(value))
			{
				setChildAttribute("range", "length", null);
			}
			else
			{
				setChildAttribute("range", "length", value.toString());
			}
		}
	}
}
