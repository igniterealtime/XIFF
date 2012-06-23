/*
 * Copyright (C) 2003-2011 Igniterealtime Community Contributors
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
package org.igniterealtime.xiff.collections
{
	import org.flexunit.asserts.assertEquals;
	
	/**
	 * @see http://docs.flexunit.org/index.php?title=Tests_and_Test_Cases
	 */
	public class ArrayCollectionTest
	{
		[Test( description="Empty array" )]
		public function testEmptyArray():void
		{
			var collection:ArrayCollection = new ArrayCollection([]);
			assertEquals( [], collection.source );
		}
		
		[Test( description="Get item at a given index" )]
		public function testValueAtIndex():void
		{
			var collection:ArrayCollection = new ArrayCollection([1, 2, 3, 4]);
			assertEquals( 3, collection.getItemAt(2) );
		}
	}
}