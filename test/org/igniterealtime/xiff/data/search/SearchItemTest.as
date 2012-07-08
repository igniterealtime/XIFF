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
	
	public class SearchItemTest
	{
		[Test( description="jid value" )]
		public function testValueJid():void
		{
			var testValue:String = "juliet@capulet.com";
			
			var ext:SearchItem = new SearchItem();
			ext.jid = testValue;
			
			assertEquals( testValue, ext.jid );
		}
		
		[Test( description="username value" )]
		public function testValueUsername():void
		{
			var testValue:String = "confucius";
			
			var ext:SearchItem = new SearchItem();
			ext.username = testValue;
			
			assertEquals( testValue, ext.username );
		}
		
		[Test( description="nick value" )]
		public function testValueNick():void
		{
			var testValue:String = "JuliC";
			
			var ext:SearchItem = new SearchItem();
			ext.nick = testValue;
			
			assertEquals( testValue, ext.nick );
		}
		
		[Test( description="first value" )]
		public function testValueFirst():void
		{
			var testValue:String = "Juliet";
			
			var ext:SearchItem = new SearchItem();
			ext.first = testValue;
			
			assertEquals( testValue, ext.first );
		}
		
		[Test( description="last value" )]
		public function testValueLast():void
		{
			var testValue:String = "Capulet";
			
			var ext:SearchItem = new SearchItem();
			ext.last = testValue;
			
			assertEquals( testValue, ext.last );
		}
		
		[Test( description="email value" )]
		public function testValueEmail():void
		{
			var testValue:String = "juliet@shakespeare.lit";
			
			var ext:SearchItem = new SearchItem();
			ext.email = testValue;
			
			assertEquals( testValue, ext.email );
		}
		
		[Test( description="name value" )]
		public function testValueName():void
		{
			var testValue:String = "Juliet Capulet";
			
			var ext:SearchItem = new SearchItem();
			ext.name = testValue;
			
			assertEquals( testValue, ext.name );
		}
		
		
		
		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "item";
			
			var ext:SearchItem = new SearchItem();
			var node:XML = ext.xml;
			
			assertEquals( elementName, node.localName() );
		}
		
		
		[Test( description="parse first from XML" )]
		public function testParseFirst():void
		{
			var incoming:XML = <item jid='juliet@capulet.com'>
			  <first>Juliet</first>
			  <last>Capulet</last>
			  <nick>JuliC</nick>
			  <email>juliet@shakespeare.lit</email>
			</item>;
			var testValue:String = "Juliet";
			
			var ext:SearchItem = new SearchItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.first );
		}
		

		[Test( description="parse last from XML" )]
		public function testParseLast():void
		{
			var incoming:XML = <item jid='juliet@capulet.com'>
			  <first>Juliet</first>
			  <last>Capulet</last>
			  <nick>JuliC</nick>
			  <email>juliet@shakespeare.lit</email>
			</item>;
			var testValue:String = "Capulet";
			
			var ext:SearchItem = new SearchItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.last );
		}
		
		[Test( description="parse nick from XML" )]
		public function testParseNick():void
		{
			var incoming:XML = <item jid='juliet@capulet.com'>
			  <first>Juliet</first>
			  <last>Capulet</last>
			  <nick>JuliC</nick>
			  <email>juliet@shakespeare.lit</email>
			</item>;
			var testValue:String = "JuliC";
			
			var ext:SearchItem = new SearchItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.nick );
		}
		
		[Test( description="parse jid from XML" )]
		public function testParseJid():void
		{
			var incoming:XML = <item jid='juliet@capulet.com'>
			  <first>Juliet</first>
			  <last>Capulet</last>
			  <nick>JuliC</nick>
			  <email>juliet@shakespeare.lit</email>
			</item>;
			var testValue:String = "juliet@capulet.com";
			
			var ext:SearchItem = new SearchItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.jid );
		}
		
		[Test( description="parse email from XML" )]
		public function testParseEmail():void
		{
			var incoming:XML = <item jid='juliet@capulet.com'>
			  <first>Juliet</first>
			  <last>Capulet</last>
			  <nick>JuliC</nick>
			  <email>juliet@shakespeare.lit</email>
			</item>;
			var testValue:String = "juliet@shakespeare.lit";
			
			var ext:SearchItem = new SearchItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.email );
		}
	}
}
