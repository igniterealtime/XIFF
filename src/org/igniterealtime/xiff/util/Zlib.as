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
		private var _streamDef:ZStream;
		private var _streamInf:ZStream;

		/**
		 * Stream Compression - Zlib
		 */
		public function Zlib()
		{
			_streamDef = new ZStream();
			_streamDef.deflateInit(JZlib.Z_BEST_COMPRESSION);

			_streamInf = new ZStream();
			_streamInf.inflateInit();
		}

		public function clear():void
		{
			_streamDef.free();
			_streamInf.free();
		}

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
			var chunk:ByteArray = new ByteArray();
			var outBytesLength:int = data.length * 2;

			var err:int;

			trace("Zlib.uncompress. data.length: " + data.length);

			_streamInf.next_in = data;
			_streamInf.next_in_index = 0;

			_streamInf.next_out = chunk;
			_streamInf.next_out_index = 0;

	        _streamInf.avail_in = 1;
			_streamInf.avail_out = outBytesLength;
			_streamInf.total_in = 0;

			while (true)
			{
				err = _streamInf.inflate(JZlib.Z_SYNC_FLUSH);
				switch (err)
				{
					case JZlib.Z_STREAM_END:
						// completed decompression, lets copy data and get out
						trace("Zlib.uncompress. inflation stream ended");
						break;
					case JZlib.Z_BUF_ERROR:
						emptyByteArrayIntoByteArray(chunk, uncompressed);
						_streamInf.next_out_index = 0;
						_streamInf.avail_out = outBytesLength;
						break;
					default:
						// unknown error
						if (err != JZlib.Z_OK)
						{
							if (_streamInf.msg == null)
							{
								trace("Zlib.uncompress. Unknown error. Error code : " + err);
							}
							else
							{
								trace("Zlib.uncompress. Unknown error. Error code : " + err + " and message : " + _streamInf.msg);
							}
						}
				}
				_streamInf.avail_in = 1;

				if (_streamInf.total_in >= data.length)
				{
					emptyByteArrayIntoByteArray(chunk, uncompressed);
					break;
				}
			}
			
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

			trace("Zlib.compress. data.length: " + data.length);

			// How is this number build?
			var outLen:int = Math.round(data.length * 1.001) + 1 + 12;

			_streamDef.next_in = data;
			_streamDef.next_in_index = 0;

			_streamDef.next_out = compressed;
			_streamDef.next_out_index = 0;
			
			_streamDef.avail_in = data.length;
			_streamDef.avail_out = outLen;

			err = _streamDef.deflate(JZlib.Z_SYNC_FLUSH);

			if (err != JZlib.Z_OK)
			{
				compressed = null;
				trace("Zlib.compress. Compression failed with return value : " + err);
			}

			// TODO: we need this, but why? zlib must be missing something
			if (compressed.length > 2)
			{
				compressed.position = compressed.length - 2;
				compressed.writeByte(0xFF);
				compressed.writeByte(0xFF);
			}

			trace("Zlib.compress. compressed.length: " + compressed.length);

			compressed.position = 0;
			return compressed;
		}
		
		private function emptyByteArrayIntoByteArray(chunk:ByteArray, target:ByteArray):void
		{
			var len:uint = chunk.length;
			for (var i:uint = 0; i < len; ++i)
			{
				target.writeByte(chunk.readByte());
			}
			chunk.clear();
		}
	}
}
