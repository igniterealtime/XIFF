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
package org.igniterealtime.xiff.data.bind
{
	import org.flexunit.asserts.*;
	import org.igniterealtime.xiff.core.*;
	
	public class BindExtensionTest
	{
		
		[Test( description="resource value" )]
		public function testValueResource():void
		{
			var testValue:String = "FullSand";
			
			var ext:BindExtension = new BindExtension();
			ext.resource = testValue;
			
			assertEquals( testValue, ext.resource );
		}
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "urn:ietf:params:xml:ns:xmpp-bind";
			var elementName:String = "bind";
			
			var ext:BindExtension = new BindExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="XML parse - jid" )]
		public function testParseJid():void
		{
			var incoming:XML = <bind xmlns='urn:ietf:params:xml:ns:xmpp-bind'>
				 <jid>
				   juliet@im.example.com/4db06f06-1ea4-11dc-aca3-000bcd821bfb
				 </jid>
			   </bind>;
			var testValue:String = "juliet@im.example.com/4db06f06-1ea4-11dc-aca3-000bcd821bfb";
			
			var ext:BindExtension = new BindExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.jid.toString() );
		}
		
	}
}
