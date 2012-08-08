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
package org.igniterealtime.xiff.data.message
{
	import org.flexunit.asserts.*;
	
	public class OutOfBoundDataExtensionTest
	{
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "jabber:x:oob";
			var elementName:String = "x";
			
			
			var ext:OutOfBoundDataExtension = new OutOfBoundDataExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="XML parse - url" )]
		public function testParseUrl():void
		{
			var incoming:XML = <x xmlns='jabber:x:oob'>
				<url>http://www.jabber.org/images/psa-license.jpg</url>
			  </x>;
			var testValue:String = "http://www.jabber.org/images/psa-license.jpg";
			
			var ext:OutOfBoundDataExtension = new OutOfBoundDataExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.url );
		}
		
		[Test( description="XML parse - description" )]
		public function testParseDescription():void
		{
			var incoming:XML = <x xmlns='jabber:x:oob'>
				<url>http://www.jabber.org/images/psa-license.jpg</url>
				<desc>A license to Jabber!</desc>
			  </x>;
			var testValue:String = "A license to Jabber!";
			
			var ext:OutOfBoundDataExtension = new OutOfBoundDataExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.description );
		}

	}
}
