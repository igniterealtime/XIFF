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
	
	/**
	 * Utility for reading and writing Hex formatted data to/from ByteArray.
	 */
	public class Hex
	{
		/**
		 * Write the given hex string to the bytearray
		 *
		 * @param   ba
		 * @param   hex
		 * @return  ByteArray that has the hex written in it
		 */
		public static function writeBytes(ba:ByteArray, hex:String):ByteArray
		{
			ba.position = ba.length;
			var len:uint = hex.length;
			for (var i:uint = 0; i < len; i += 2)
			{
				var byte:uint = uint("0x" + hex.substr(i, 2));
				ba.writeByte(byte);
			}
			return ba;
		}
		
		/**
		 * Read the bytes of the given bytearray and convert to a hex string
		 *
		 * @param   ba
		 * @return  String in hex format
		 */
		public static function readBytes(ba:ByteArray):String
		{
			var hex:String = "";
			ba.position = 0;
			var len:uint = ba.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var byte:uint = ba.readUnsignedByte();
				//trace("readBytes. byte " + i + ": " + byte + " -- " + byte.toString(16));
				hex += String("0" + byte.toString(16)).substr(-2);
			}
			return hex;
		}
	}
}
