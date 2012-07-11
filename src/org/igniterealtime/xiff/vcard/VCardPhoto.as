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
package org.igniterealtime.xiff.vcard
{
	import com.hurlant.util.Base64;

	import flash.utils.ByteArray;

	/**
	 * Photograph.
	 *
	 * <p>The image height and width SHOULD be between thirty-two (32) and ninety-six (96) pixels;
	 * the recommended size is sixty-four (64) pixels high and sixty-four (64) pixels wide.</p>
	 *
	 * <p>The image SHOULD be square.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0153.html
	 */
	public class VCardPhoto implements IVCardPhoto
	{
		private var _binaryValue:String;

		private var _bytes:ByteArray;

		private var _externalValue:String;

		private var _type:String;

		/**
		 * To save a photo, either binaryValue or externalValue are required, but not both.
		 * If binaryValue is passed in, type is required.
		 * If externalValue is passed in, type is not required.
		 *
		 * @param	type The image type of the photo. Required if binaryValue is passed in.
		 * @param	binaryValue The BASE64 encoded binary value of the photo. Either binaryValue or externalValue are required, but not both.
		 * @param	externalValue The URI to an external photo. Either binaryValue or externalValue are required, but not both.
		 */
		public function VCardPhoto( type:String=null, binaryValue:String=null, externalValue:String=null )
		{
			this.type = type;
			this.binaryValue = binaryValue;
			this.externalValue = externalValue;
		}

		/**
		 * Base64 encoded data.
		 * The image SHOULD use less than eight kilobytes (8k) of data; this
		 * restriction is to be enforced by the publishing client.
		 *
		 * <p>The image data MUST conform to the base64Binary datatype [7] and thus be encoded in accordance with
		 * Section 6.8 of RFC 2045 [8], which recommends that base64 data should have lines limited to at most
		 * 76 characters in length. However, any whitespace characters (e.g., '\\r' and '\\n') MUST be ignored.</p>
		 *
		 * @see http://tools.ietf.org/html/rfc2045#section-6.8
		 */
		public function get binaryValue():String
		{
			return _binaryValue;
		}
		public function set binaryValue( value:String ):void
		{
			_binaryValue = value;
			if ( value )
			{
				try
				{
					_bytes = Base64.decodeToByteArrayB( value );
				}
				catch( error:Error )
				{
					throw new Error( "VCardPhoto Error decoding binaryValue " + error.getStackTrace() );
				}
			}
			else
			{
				_bytes = null;
			}
		}

		/**
		 * Image data
		 */
		public function get bytes():ByteArray
		{
			return _bytes;
		}
		public function set bytes( value:ByteArray ):void
		{
			_bytes = value;
			if ( value )
			{
				try
				{
					_binaryValue =  Base64.encodeByteArray( value );
				}
				catch( error:Error )
				{
					throw new Error( "VCardPhoto Error encoding bytes " + error.getStackTrace() );
				}
			}
			else
			{
				_binaryValue = null;
			}
		}

		/**
		 * The URI to an external photo
		 */
		public function get externalValue():String
		{
			return _externalValue;
		}
		public function set externalValue( value:String ):void
		{
			_externalValue = value;
		}

		/**
		 * Mimetype of the given <code>bytes</code> value, if any.
		 * Should be set by hand.
		 *
		 * <p>The image content type [6] SHOULD be image/gif, image/jpeg, or image/png; support for the
		 * "image/png" content type is REQUIRED, support for the "image/gif" and "image/jpeg" content
		 * types is RECOMMENDED, and support for any other content type is OPTIONAL.</p>
		 *
		 * @exampleText image/jpeg
		 */
		public function get type():String
		{
			return _type;
		}
		public function set type( value:String ):void
		{
			_type = value;
		}
	}
}
