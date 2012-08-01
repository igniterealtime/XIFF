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
	
	public class ArchiveListExtensionTest
	{
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "urn:xmpp:archive";
			var elementName:String = "list";
			
			
			var ext:ArchiveListExtension = new ArchiveListExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="XML parse - withJid" )]
		public function testParseWithJid():void
		{
			var incoming:XML = <list xmlns='urn:xmpp:archive'
					with='juliet@capulet.com'>
				<set xmlns='http://jabber.org/protocol/rsm'>
				  <max>30</max>
				</set>
			  </list>;
			var testValue:String = "juliet@capulet.com";
			
			var ext:ArchiveListExtension = new ArchiveListExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.withJid.toString() );
		}
		
		[Test( description="XML parse - start" )]
		public function testParseStart():void
		{
			var incoming:XML = <list xmlns='urn:xmpp:archive'
					with='juliet@capulet.com'
					start='1469-07-21T02:00:00Z'
					end='1479-07-21T04:00:00Z'>
				<set xmlns='http://jabber.org/protocol/rsm'>
				  <max>30</max>
				</set>
			  </list>;
			var testValue:String = "Wed Jul 21 02:00:00 1469 UTC";
			
			var ext:ArchiveListExtension = new ArchiveListExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.start.toUTCString() );
		}
		
		[Test( description="XML parse - end" )]
		public function testParseEnd():void
		{
			var incoming:XML = <list xmlns='urn:xmpp:archive'
					with='juliet@capulet.com'
					start='1469-07-21T02:00:00Z'
					end='1479-07-21T04:00:00Z'>
				<set xmlns='http://jabber.org/protocol/rsm'>
				  <max>30</max>
				</set>
			  </list>;
			var testValue:String = "Mon Jul 21 04:00:00 1479 UTC";
			
			var ext:ArchiveListExtension = new ArchiveListExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.end.toUTCString() );
		}
		
	}
}
