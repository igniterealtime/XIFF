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
package org.igniterealtime.xiff.data.id
{
	/**
	 * Generates a universally unique identifier.
	 * RFC4122 Version 4.
	 * http://tools.ietf.org/html/rfc4122#section-4.4
	 */
	public class UUIDGenerator implements IIDGenerator
	{
		private var _prefix:String;

		public function UUIDGenerator()
		{
		}

		/**
		 * The prefix to use for the generated ID (for namespacing purposes).
		 */
		public function get prefix():String
		{
			return _prefix;
		}
		public function set prefix( value:String ):void
		{
			_prefix = value;
		}

		/**
		 * Generates the unique ID.
		 *
		 * @return The generated ID
		 */
		public function generateID():String
		{
			var uuid:String = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace( /[xy]/g, replaceChar );
			var id:String;

			if ( _prefix != null ) {
				id = _prefix + uuid;
			} else {
				id = uuid;
			}
			return id;
		}

		private function replaceChar():String
		{
			var r:Number = Math.random() * 16 | 0;
			var v:Number = arguments[ 0 ] == "x" ? r : ( r&0x3 | 0x8 );
			return v.toString( 16 );
		}
	}
}
