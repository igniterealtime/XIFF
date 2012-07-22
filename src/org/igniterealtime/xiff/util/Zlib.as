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
	
	import com.wirelust.as3zlib.JZlib;
	import com.wirelust.as3zlib.ZStream;
	
	/**
	 * Compress the given ByteArrays by using the as3zlib library.
	 *
	 * @see http://code.google.com/p/as3zlib/
	 */
	public class Zlib implements ICompressor
	{
		/**
		 * Uncompress (inflate) the given ByteArray.
		 *
		 * @param	data
		 * @return Uncompressed data
		 */
		public function uncompress(data:ByteArray):ByteArray
		{
			data.position = 0;
			var uncompressed:ByteArray = new ByteArray();
			var outBytesLength:int = data.length * 2;
			
			var err:int;
			var i:int = 0;
			var j:int = 0;
			
			trace("Zlib.uncompress. data.length: " + data.length);
			trace("Zlib.uncompress. data: " + data.toString());
			
			
			var stream:ZStream = new ZStream();
			
			stream.next_in = data;
			stream.next_in_index = 0;
			
			stream.next_out = uncompressed;
			stream.next_out_index = 0;
			
			stream.avail_out = outBytesLength;
			stream.total_in = 0;
			
			
			err = stream.inflateInit();
			checkError(stream, err, "inflateInit");

			var outcount:int = 0;
			while (true)
			{
				// force small buffers
				stream.avail_in = 1;
				stream.avail_out = 1;
				
				err = stream.inflate(JZlib.Z_NO_FLUSH);
				switch (err)
				{
					case JZlib.Z_STREAM_END:
						// completed decompression, lets copy data and get out
						trace("Zlib.uncompress. inflation stream ended");
						break;
					case JZlib.Z_BUF_ERROR:
						stream.next_out_index = 0;
						stream.avail_out = outBytesLength;
						break;
					default:
						// unknown error
						if (err != JZlib.Z_OK)
						{
							if (stream.msg == null) {
								trace("Unknown error. Error code : " + err);
							}
							else {
								trace("Unknown error. Error code : " + err + " and message : " + stream.msg);
							}
						}
				}
				
				outcount++;
				//trace("Zlib.uncompress. outcount: " + outcount + ", stream.total_out: " + stream.total_out);

				if (!checkError(stream, err, "inflate"))
				{
					break;
				}
			}

			err = stream.inflateEnd();
			checkError(stream, err, "inflateEnd");
			
			
			trace("Zlib.uncompress. uncompressed.length: " + uncompressed.length);
			trace("Zlib.uncompress. uncompressed: " + uncompressed.toString());

			uncompressed.position = 0;
			return uncompressed;
		}
		
		/**
		 * Compress (deflate) the given ByteArray.
		 *
		 * @param	data
		 * @return Compressed data
		 */
		public function compress(data:ByteArray):ByteArray
		{
			data.position = 0;
			var compressed:ByteArray = new ByteArray();
			var err:int;
			var i:int = 0;
			var j:int = 0;
			
			trace("Zlib.compress. data.length: " + data.length);
			trace("Zlib.compress. data: " + data.toString());
			
			var stream:ZStream = new ZStream();

			err = stream.deflateInit(JZlib.Z_BEST_COMPRESSION);
			checkError(stream, err, "deflateInit");
			
			stream.next_in = data;
			stream.next_in_index = 0;
			
			stream.next_out = compressed;
			stream.next_out_index = 0;
			
			
			// ----
			
			var comprLen:int = 40000;
			while (stream.total_in != data.length && stream.total_out < comprLen)
			{
				// force small buffers
				stream.avail_in = 1;
				stream.avail_out = 1;
				
				err = stream.deflate(JZlib.Z_NO_FLUSH);
				checkError(stream, err, "deflate");
			}
			
			while (true)
			{
				stream.avail_out = 1;
				err = stream.deflate(JZlib.Z_FINISH);
				if (err == JZlib.Z_STREAM_END)
				{
					break;
				}

				compressed.position = 0;
				
				checkError(stream, err, "deflate");
			}
			
			err = stream.deflateEnd();
			checkError(stream, err, "deflateEnd");
	
			
			trace("Zlib.compress. compressed.length: " + compressed.length);
			trace("Zlib.compress. compressed: " + compressed.toString());

			compressed.position = 0;
			return compressed;
		}
		
		/**
		 * Check errors in the given ZStream.
		 *
		 * @param	z
		 * @param	err
		 * @param	msg
		 * @return
		 */
		public function checkError(z:ZStream, err:int, msg:String):Boolean
		{
			if (err != JZlib.Z_OK)
			{
				if (z.msg != null)
				{
					trace(z.msg + " ");
				}
				trace(msg + " error: " + err);
				return false;
			}
			return true;
		}
	}
}
