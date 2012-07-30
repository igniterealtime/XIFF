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
	
	public class MUCStatusTest
	{
		
		[Test( description="code value" )]
		public function testValueCode():void
		{
			var testValue:int = 200;
			
			var ext:MUCStatus = new MUCStatus();
			ext.code = testValue;
			
			assertEquals( testValue, ext.code );
		}
		
		[Test( description="message value" )]
		public function testValueMessage():void
		{
			var testValue:String = "logging-disabled";
			
			var ext:MUCStatus = new MUCStatus();
			ext.message = testValue;
			
			assertEquals( testValue, ext.message );
		}
		
		
		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "status";
			
			var ext:MUCStatus = new MUCStatus();
			var node:XML = ext.xml;
			
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="XML parse - code" )]
		public function testParseCode():void
		{
			var incoming:XML = <status code='110'>
			  <self-presence xmlns='urn:xmpp:muc:conditions:1'/>
			</status>;
			var testValue:int = 110;
			
			var ext:MUCStatus = new MUCStatus();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.code );
		}
		
		[Test( description="XML parse - message" )]
		public function testParseMessage():void
		{
			var incoming:XML = <status code='110'>
			  <self-presence xmlns='urn:xmpp:muc:conditions:1'/>
			</status>;
			var testValue:String = "self-presence";
			
			var ext:MUCStatus = new MUCStatus();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.message );
		}
		
		

	}
}
