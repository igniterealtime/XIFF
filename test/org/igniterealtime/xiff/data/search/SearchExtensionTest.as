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
package org.igniterealtime.xiff.data.search
{
	import org.flexunit.asserts.*;
	
	public class SearchExtensionTest
	{
		[Test( description="instructions value" )]
		public function testValueInstructions():void
		{
			var testValue:String = "Fill in one or more fields to search for any matching Jabber users.";
			
			var ext:SearchExtension = new SearchExtension();
			ext.instructions = testValue;
			
			assertEquals( testValue, ext.instructions );
		}
		
		
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "jabber:iq:search";
			var elementName:String = "query";
			
			var ext:SearchExtension = new SearchExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		
		[Test( description="parse count items from XML" )]
		public function testParseItemsCount():void
		{
			var incoming:XML = <query xmlns='jabber:iq:search'>
				<item jid='juliet@capulet.com'>
				  <first>Juliet</first>
				  <last>Capulet</last>
				  <nick>JuliC</nick>
				  <email>juliet@shakespeare.lit</email>
				</item>
				<item jid='tybalt@shakespeare.lit'>
				  <first>Tybalt</first>
				  <last>Capulet</last>
				  <nick>ty</nick>
				  <email>tybalt@shakespeare.lit</email>
				</item>
			  </query>;
			var testValue:uint = 2;
			
			var ext:SearchExtension = new SearchExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.items.length );
		}
		
		
		
	}
}
