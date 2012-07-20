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
package org.igniterealtime.xiff.data.version
{
	import org.flexunit.asserts.*;
	
	public class SoftwareVersionExtensionTest
	{
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "jabber:iq:version";
			var elementName:String = "query";
			
			var ext:SoftwareVersionExtension = new SoftwareVersionExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="XML parse - name" )]
		public function testParseName():void
		{
			var incoming:XML = <query xmlns='jabber:iq:version'>
				<name>Exodus</name>
				<version>0.7.0.4</version>
				<os>Windows-XP 5.01.2600</os>
			  </query>;
			var testValue:String = "Exodus";
			
			var ext:SoftwareVersionExtension = new SoftwareVersionExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.name );
		}
		
		[Test( description="XML parse - version" )]
		public function testParseVersion():void
		{
			var incoming:XML = <query xmlns='jabber:iq:version'>
				<name>Exodus</name>
				<version>0.7.0.4</version>
				<os>Windows-XP 5.01.2600</os>
			  </query>;
			var testValue:String = "0.7.0.4";
			
			var ext:SoftwareVersionExtension = new SoftwareVersionExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.version );
		}
		
		[Test( description="XML parse - os" )]
		public function testParseOs():void
		{
			var incoming:XML = <query xmlns='jabber:iq:version'>
				<name>Exodus</name>
				<version>0.7.0.4</version>
				<os>Windows-XP 5.01.2600</os>
			  </query>;
			var testValue:String = "Windows-XP 5.01.2600";
			
			var ext:SoftwareVersionExtension = new SoftwareVersionExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.os );
		}
		
	}
}
