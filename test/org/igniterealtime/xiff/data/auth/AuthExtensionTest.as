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
package org.igniterealtime.xiff.data.auth
{
	import org.flexunit.asserts.*;
	
	/**
	 * @see http://docs.flexunit.org/index.php?title=Tests_and_Test_Cases
	 */
	public class AuthExtensionTest
	{
		[Test( description="Username value set and get" )]
		public function testUsernameValue():void
		{
			var testValue:String = "whoami";
			
			var ext:AuthExtension = new AuthExtension();
			ext.username = testValue;
			assertEquals( testValue, ext.username );
		}
		
		[Test( description="Password value set and get" )]
		public function testPasswordValue():void
		{
			var testValue:String = "secret";
			
			var ext:AuthExtension = new AuthExtension();
			ext.password = testValue;
			assertEquals( testValue, ext.password );
		}
		
		[Test( description="Digest value set and get" )]
		public function testDigestValue():void
		{
			var testValue:String = "whoami";
			
			var ext:AuthExtension = new AuthExtension();
			ext.digest = testValue;
			assertEquals( testValue, ext.digest );
		}
		
		[Test( description="Digest calculation" )]
		public function testDigestCalculation():void
		{
			var sessionId:String = "555";
			var password:String = "secret";
	
			var calculated:String = AuthExtension.computeDigest(sessionId, password);
			
			// http://www.sha1.cz/
			assertEquals( "7b5611ad4f407915f3dec83957fe2c72320c459f", calculated );
		}
		
		[Test( description="Resource value set and get" )]
		public function testResourceValue():void
		{
			var testValue:String = "whoami";
			
			var ext:AuthExtension = new AuthExtension();
			ext.resource = testValue;
			assertEquals( testValue, ext.resource );
		}
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "jabber:iq:auth";
			var elementName:String = "query";
			
			var ext:AuthExtension = new AuthExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
	}
}
