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
package org.igniterealtime.xiff.data.register
{
	import org.flexunit.asserts.*;
	
	public class RegisterExtensionTest
	{
		[Test( description="instructions value" )]
		public function testValueInstructions():void
		{
			var testValue:String = "To register, visit http://www.shakespeare.lit/contests.php";
			
			var ext:RegisterExtension = new RegisterExtension();
			ext.instructions = testValue;
			
			assertEquals( testValue, ext.instructions );
		}
		
		
		
		
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "jabber:iq:register";
			var elementName:String = "query";
			
			var ext:RegisterExtension = new RegisterExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		
		[Test( description="Parse XML - getRequiredFieldNames" )]
		public function testParseGetRequiredFieldNames():void
		{
			var incoming:XML = <query xmlns='jabber:iq:register'>
				<instructions>
				  Choose a username and password for use with this service.
				  Please also provide your email address.
				</instructions>
				<username/>
				<password/>
				<email/>
			  </query>;
			var testValue:Array = ["username", "password", "email"];
			
			var ext:RegisterExtension = new RegisterExtension();
			ext.xml = incoming;
			
			assertEquals( testValue.toString(), ext.getRequiredFieldNames().toString() );
		}
		
		[Test( description="Parse XML - unregister" )]
		public function testParseUnregister():void
		{
			var incoming:XML = <query xmlns='jabber:iq:register'>
				<remove/>
			  </query>;
			var testValue:Boolean = true;
			
			var ext:RegisterExtension = new RegisterExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.unregister );
		}
		
		
		[Test( description="Parse XML - password" )]
		public function testParsePassword():void
		{
			var incoming:XML = <query xmlns='jabber:iq:register'>
				<username>bill</username>
				<password>newpass</password>
			  </query>;
			var testValue:String = "newpass";
			
			var ext:RegisterExtension = new RegisterExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.password );
		}
		
		

	}
}
