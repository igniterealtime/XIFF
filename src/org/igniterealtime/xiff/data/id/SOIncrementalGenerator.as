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
	import flash.net.SharedObject;

	/**
	 * Generates an incrementing ID and saves the last value in a local shared object.
	 */
	public class SOIncrementalGenerator extends IncrementalGenerator implements IIDGenerator
	{
		private static const SO_COOKIE_NAME:String = "SOIncrementalGenerator";

                private var _so:SharedObject;

		public function SOIncrementalGenerator( id:String, prefix:String=null )
		{
			super( prefix );
			var soName:String = SO_COOKIE_NAME + ( id ? "_" + id : "" );
                        _so = SharedObject.getLocal(soName);
                        if (_so.data.counter == undefined)
			{
                                _so.data.counter = 0;
			}
                        counter = _so.data.counter;
		}

		/**
		 * Generates a unique ID.
		 * 
		 * @return The generated ID
		 */
		override public function generateID():String
		{
			var id:String = super.generateID();
                        _so.data.counter = counter;
			return id;
		}
	}
}
