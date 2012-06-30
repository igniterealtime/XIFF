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
package org.igniterealtime.xiff.data.browse
{
	import org.flexunit.asserts.*;
	
	public class BrowseItemTest
	{
		
		
		[Test( description="jid value" )]
		public function testValueJid():void
		{
			var testValue:String = "plain@text.jid/FullSand";
			
			var ext:BrowseItem = new BrowseItem(<empty/>);
			ext.jid = testValue;
			
			assertEquals( testValue, ext.jid );
		}
		
		[Test( description="category value" )]
		public function testValueCategory():void
		{
			var testValue:String = "plain@text.jid/FullSand";
			
			var ext:BrowseItem = new BrowseItem(<empty/>);
			ext.category = testValue;
			
			assertEquals( testValue, ext.category );
		}
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var elementName:String = "item";
			
			var ext:BrowseItem = new BrowseItem(<empty/>);
			var node:XML = ext.xml;
			
			assertEquals( elementName, node.localName() );
		}
		
	}
}
