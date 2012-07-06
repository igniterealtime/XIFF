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
	
	public class DiscoIdentityTest
	{
		
		
		[Test( description="category value" )]
		public function testValueCategory():void
		{
			var testValue:String = "client";
			
			var ext:DiscoIdentity = new DiscoIdentity();
			ext.category = testValue;
			
			assertEquals( testValue, ext.category );
		}
		
		[Test( description="type value" )]
		public function testValueType():void
		{
			var testValue:String = "pc";
			
			var ext:DiscoIdentity = new DiscoIdentity();
			ext.type = testValue;
			
			assertEquals( testValue, ext.type );
		}
		
		[Test( description="name value" )]
		public function testValueName():void
		{
			var testValue:String = "Gabber";
			
			var ext:DiscoIdentity = new DiscoIdentity();
			ext.name = testValue;
			
			assertEquals( testValue, ext.name );
		}
		
		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "identity";
			
			var ext:DiscoIdentity = new DiscoIdentity();
			var node:XML = ext.xml;
			
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="parse category from XML" )]
		public function testParseCategory():void
		{
			var incoming:XML = 	<identity
				category='client'
				type='pc'
				name='Gabber'/>;
			var testValue:String = "client";
			
			var ext:DiscoIdentity = new DiscoIdentity();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.category );
		}
		
		[Test( description="parse type from XML" )]
		public function testParseType():void
		{
			var incoming:XML = 	<identity
				category='client'
				type='pc'
				name='Gabber'/>;
			var testValue:String = "pc";
			
			var ext:DiscoIdentity = new DiscoIdentity();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.type );
		}
		
		[Test( description="parse name from XML" )]
		public function testParseName():void
		{
			var incoming:XML = 	<identity
				category='client'
				type='pc'
				name='Gabber'/>;
			var testValue:String = "Gabber";
			
			var ext:DiscoIdentity = new DiscoIdentity();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.name );
		}
		
	}
}
