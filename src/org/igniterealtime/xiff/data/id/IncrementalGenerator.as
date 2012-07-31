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
package org.igniterealtime.xiff.data.id
{
	/**
	 * Uses a simple incrementation of a variable to generate new IDs.
	 */
	public class IncrementalGenerator implements IIDGenerator
	{
		protected var counter:int = 0;

		protected var _prefix:String;

		public function IncrementalGenerator( prefix:String=null )
		{
			this.prefix = prefix;
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
		 * Generates a unique ID.
		 *
		 * @return The generated ID
		 */
		public function generateID():String
		{
			counter++;
			var id:String;

			if ( _prefix != null )
			{
				id = _prefix + counter;
			}
			else
			{
				id = counter.toString();
			}
			return id;
		}
	}
}
