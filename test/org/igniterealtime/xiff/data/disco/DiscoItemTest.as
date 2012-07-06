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
package org.igniterealtime.xiff.data.disco
{
	import org.flexunit.asserts.*;
	
	public class DiscoItemTest
	{
		
		[Test( description="name value" )]
		public function testValueName():void
		{
			var testValue:String = "Books by and about Shakespeare";
			
			var ext:DiscoItem = new DiscoItem();
			ext.name = testValue;
			
			assertEquals( testValue, ext.name );
		}
		
		[Test( description="jid value" )]
		public function testValueJid():void
		{
			var testValue:String = "catalog.shakespeare.lit";
			
			var ext:DiscoItem = new DiscoItem();
			ext.jid = testValue;
			
			assertEquals( testValue, ext.jid );
		}
		
		[Test( description="node value" )]
		public function testValueNode():void
		{
			var testValue:String = "books";
			
			var ext:DiscoItem = new DiscoItem();
			ext.node = testValue;
			
			assertEquals( testValue, ext.node );
		}
		
		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "item";
			
			var ext:DiscoItem = new DiscoItem();
			var node:XML = ext.xml;
			
			assertEquals( elementName, node.localName() );
		}
	
		[Test( description="parse name from XML" )]
		public function testParseName():void
		{
			var incoming:XML = <item jid='catalog.shakespeare.lit'
			  node='books'
			  name='Books by and about Shakespeare'/>;
			var testValue:String = "Books by and about Shakespeare";
			
			var ext:DiscoItem = new DiscoItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.name );
		}
	
		[Test( description="parse jid from XML" )]
		public function testParseJid():void
		{
			var incoming:XML = <item jid='catalog.shakespeare.lit'
			  node='books'
			  name='Books by and about Shakespeare'/>;
			var testValue:String = "catalog.shakespeare.lit";
			
			var ext:DiscoItem = new DiscoItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.jid );
		}
	
		[Test( description="parse node from XML" )]
		public function testParseNode():void
		{
			var incoming:XML = <item jid='catalog.shakespeare.lit'
			  node='books'
			  name='Books by and about Shakespeare'/>;
			var testValue:String = "books";
			
			var ext:DiscoItem = new DiscoItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.node );
		}
		
	}
}
