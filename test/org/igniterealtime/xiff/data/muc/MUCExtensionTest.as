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
package org.igniterealtime.xiff.data.muc
{
	import org.flexunit.asserts.*;
	
	public class MUCExtensionTest
	{
		
		[Test( description="password value" )]
		public function testValuePassword():void
		{
			var testValue:String = "secretPassWord01234";
			
			var ext:MUCExtension = new MUCExtension();
			ext.password = testValue;
			
			assertEquals( testValue, ext.password );
		}
		
		[Test( description="history true value" )]
		public function testValueHistoryTrue():void
		{
			var testValue:Boolean = true;
			
			var ext:MUCExtension = new MUCExtension();
			ext.history = testValue;
			
			assertEquals( testValue, ext.history );
		}
		
		[Test( description="history false value" )]
		public function testValueHistoryFalse():void
		{
			var testValue:Boolean = false;
			
			var ext:MUCExtension = new MUCExtension();
			ext.history = testValue;
			
			assertEquals( testValue, ext.history );
		}
		
		[Test( description="maxchars value" )]
		public function testValueMaxchars():void
		{
			var testValue:int = 44;
			
			var ext:MUCExtension = new MUCExtension();
			ext.maxchars = testValue;
			
			assertEquals( testValue, ext.maxchars );
		}
		
		[Test( description="maxstanzas value" )]
		public function testValueMaxstanzas():void
		{
			var testValue:int = 7;
			
			var ext:MUCExtension = new MUCExtension();
			ext.maxstanzas = testValue;
			
			assertEquals( testValue, ext.maxstanzas );
		}
		
		[Test( description="seconds value" )]
		public function testValueSeconds():void
		{
			var testValue:Number = 7.5;
			
			var ext:MUCExtension = new MUCExtension();
			ext.seconds = testValue;
			
			assertEquals( testValue, ext.seconds );
		}
		
		
		[Test( description="since value" )]
		public function testValueSince():void
		{
			var testValue:String = "1969-07-21T02:56:15Z";
			
			var ext:MUCExtension = new MUCExtension();
			ext.since = testValue;
			
			assertEquals( testValue, ext.since );
		}
		
		
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/muc";
			var elementName:String = "x";
			
			var ext:MUCExtension = new MUCExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
	
		
		
	}
}
