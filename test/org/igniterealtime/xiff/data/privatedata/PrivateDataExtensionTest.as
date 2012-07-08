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
package org.igniterealtime.xiff.data.privatedata
{
	import org.flexunit.asserts.*;
	
	public class PrivateDataExtensionTest
	{
		[Test( description="privateName value" )]
		public function testValuePrivateName():void
		{
			var testValue:String = "exodus";
			
			var ext:PrivateDataExtension = new PrivateDataExtension(testValue);
			
			assertEquals( testValue, ext.privateName );
		}
		
		[Test( description="privateNamespace value" )]
		public function testValuePrivateNamespace():void
		{
			var testValue:String = "exodus:prefs";
			
			var ext:PrivateDataExtension = new PrivateDataExtension("exodus", testValue);
			
			assertEquals( testValue, ext.privateNamespace );
		}
		
		
		
		
		
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "jabber:iq:private";
			var elementName:String = "query";
			
			var ext:PrivateDataExtension = new PrivateDataExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		
		[Test( description="parse privateName from XML" )]
		public function testParsePrivateName():void
		{
			var incoming:XML = <query xmlns="jabber:iq:private">
				<exodus xmlns="exodus:prefs">
				  <defaultnick>Hamlet</defaultnick>
				</exodus>
			  </query>;
			var testValue:String = "exodus";
			
			var ext:PrivateDataExtension = new PrivateDataExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.privateName );
		}
		
		[Test( description="parse privateNamespace from XML" )]
		public function testParsePrivateNamespace():void
		{
			var incoming:XML = <query xmlns="jabber:iq:private">
				<exodus xmlns="exodus:prefs">
				  <defaultnick>Hamlet</defaultnick>
				</exodus>
			  </query>;
			var testValue:String = "exodus:prefs";
			
			var ext:PrivateDataExtension = new PrivateDataExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.privateNamespace );
		}
		
		
		
	}
}
