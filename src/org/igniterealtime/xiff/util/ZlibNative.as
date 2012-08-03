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
package org.igniterealtime.xiff.util
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * Compress the given ByteArrays by using the Flash
	 * Player 10 native CompressionAlgorithm.ZLIB.
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/CompressionAlgorithm.html
	 */
	public class ZlibNative implements ICompressor
	{
		/**
		 * Stream Compression - Native DEFLATE
		 *
		 * <p>All multi-byte numbers in the format described in RFC 1950 are stored with
		 * the MOST-significant byte first (at the lower memory address).</p>
		 *
		 * @see http://tools.ietf.org/html/rfc1950
		 */
		public function ZlibNative()
		{
			
		}

		public function clear():void
		{
		}
		
		/**
		 * Uncompress (inflate) the given ByteArray.
		 *
		 * @param	data
		 * @return Uncompressed data
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/ByteArray.html#inflate%28%29
		 */
		public function uncompress(data:ByteArray):ByteArray
		{
			data.position = 0;
			var cmf:uint = data.readUnsignedByte();
			var flg:uint = data.readUnsignedByte();
			trace("ZlibNative::uncompress. cmf: " + cmf.toString(16));
			trace("ZlibNative::uncompress. flg: " + flg.toString(16));
			
			data.position = data.length - 4;
			var adler32:uint = data.readUnsignedInt();
			trace("ZlibNative::uncompress. adler32: " + adler32.toString(16));
			
			data.position = 0;
			var compressed:ByteArray = new ByteArray();
			compressed.endian = Endian.BIG_ENDIAN;
			compressed.writeBytes(data, 2, data.length - (2 + 4));
			compressed.inflate();
			
			return compressed;
		}
		
		/**
		 * Compress (deflate) the given ByteArray.
		 *
		 * @param	data
		 * @return Compressed data
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/ByteArray.html#deflate%28%29
		 */
		public function compress(data:ByteArray):ByteArray
		{
			data.deflate();
			
			var out:ByteArray = new ByteArray();
			out.endian = Endian.BIG_ENDIAN;
			out.writeByte(0x78); // CMF
			out.writeByte(0xDA); // FLG
			
			// 78da55 in this class, but 78da54 in Zlib
			// Openfire: java.io.IOException: Unknown error. Error code : -3 and message : incorrect data check
			
			out.writeBytes(data, 0, data.length);
			
			var adler32:uint = calculateAdler32(data);
			
			trace("ZlibNative::compress. adler32: " + adler32.toString(16));
			out.writeUnsignedInt(adler32);
			
			if (out.length > 4)
			{
				out.position = out.length - 4;
				out.writeByte(0x00);
				out.writeByte(0x00);
				out.writeByte(0xFF);
				out.writeByte(0xFF);
			}
			
			out.position = 0;
			return out;
		}
		
		/**
		 * http://en.wikipedia.org/wiki/Adler-32#Example_implementation
		 * @param	data
		 * @return
		 */
		private function calculateAdler32(data:ByteArray):uint
		{
			var modAdler:uint = 65521;

			data.position = 0;
			var a:uint = 1;
			var b:uint = 0;
			var len:uint = data.length;
			for (var index:uint = 0; index < len; ++index)
			{
				a = (a + data.readUnsignedByte()) % modAdler;
				b = (b + a) % modAdler;
			}
			return (b << 16) | a;
		}
	}
}
