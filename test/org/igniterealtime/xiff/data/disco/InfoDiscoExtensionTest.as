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
	
	public class InfoDiscoExtensionTest
	{
		
		/*
		[Test( description="node value" )]
		public function testValueNode():void
		{
			var testValue:String = "music";
			
			var ext:InfoDiscoExtension = new InfoDiscoExtension();
			ext.node = testValue;
			
			assertEquals( testValue, ext.node );
		}
		*/
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/disco#info";
			var elementName:String = "query";
			
			var ext:InfoDiscoExtension = new InfoDiscoExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
	
		[Test( description="parse from XML" )]
		public function testParseShowDnd():void
		{
			var incoming:XML = <query xmlns='http://jabber.org/protocol/disco#info'>
				<identity
					category='client'
					type='pc'
					name='Gabber'/>
				<feature var='jabber:iq:time'/>
				<feature var='jabber:iq:version'/>
			  </query>;
			var testValue:int = 2;
			
			var ext:InfoDiscoExtension = new InfoDiscoExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.features.length );
		}
		
	}
}
