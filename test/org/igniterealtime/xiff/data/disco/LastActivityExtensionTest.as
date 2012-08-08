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
	
	public class LastActivityExtensionTest
	{
		
		
		[Test( description="seconds value" )]
		public function testValueSeconds():void
		{
			var testValue:uint = 77661;
			
			var ext:LastActivityExtension = new LastActivityExtension();
			ext.seconds = testValue;
			
			assertEquals( testValue, ext.seconds );
		}
		
		[Test( description="text value" )]
		public function testValueText():void
		{
			var testValue:String = "Heading Home";
			
			var ext:LastActivityExtension = new LastActivityExtension();
			ext.text = testValue;
			
			assertEquals( testValue, ext.text );
		}
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "jabber:iq:last";
			var elementName:String = "query";
			
			var ext:LastActivityExtension = new LastActivityExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
	
		[Test( description="XML parse - seconds" )]
		public function testParseSeconds():void
		{
			var incoming:XML = <query xmlns='jabber:iq:last' seconds='903'>Heading Home</query>;
			var testValue:uint = 903;
			
			var ext:LastActivityExtension = new LastActivityExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.seconds );
		}
	
		[Test( description="XML parse - text" )]
		public function testParseText():void
		{
			var incoming:XML = <query xmlns='jabber:iq:last' seconds='903'>Heading Home</query>;
			var testValue:String = "Heading Home";
			
			var ext:LastActivityExtension = new LastActivityExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.text );
		}
		
	}
}
