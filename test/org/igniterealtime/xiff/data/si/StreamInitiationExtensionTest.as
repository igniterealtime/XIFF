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
package org.igniterealtime.xiff.data.si
{
	import org.flexunit.asserts.*;
	
	public class StreamInitiationExtensionTest
	{
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/si";
			var elementName:String = "si";
			
			var ext:StreamInitiationExtension = new StreamInitiationExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="XML parse - id" )]
		public function testParseId():void
		{
			var incoming:XML = <si xmlns='http://jabber.org/protocol/si'
				  id='a0'
				  mime-type='text/plain'
				  profile='http://jabber.org/protocol/si/profile/file-transfer'>
				<file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
					  name='test.txt'
					  size='1022'>
				  <desc>This is info about the file.</desc>
				</file>
				<feature xmlns='http://jabber.org/protocol/feature-neg'>
				  <x xmlns='jabber:x:data' type='form'>
					<field var='stream-method' type='list-single'>
					  <option><value>http://jabber.org/protocol/bytestreams</value></option>
					  <option><value>jabber:iq:oob</value></option>
					  <option><value>http://jabber.org/protocol/ibb</value></option>
					</field>
				  </x>
				</feature>
			  </si>;
			var testValue:String = "a0";
			
			var ext:StreamInitiationExtension = new StreamInitiationExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.id );
		}
		
		[Test( description="XML parse - mimeType" )]
		public function testParseMimeType():void
		{
			var incoming:XML = <si xmlns='http://jabber.org/protocol/si'
				  id='a0'
				  mime-type='text/plain'
				  profile='http://jabber.org/protocol/si/profile/file-transfer'>
				<file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
					  name='test.txt'
					  size='1022'>
				  <desc>This is info about the file.</desc>
				</file>
				<feature xmlns='http://jabber.org/protocol/feature-neg'>
				  <x xmlns='jabber:x:data' type='form'>
					<field var='stream-method' type='list-single'>
					  <option><value>http://jabber.org/protocol/bytestreams</value></option>
					  <option><value>jabber:iq:oob</value></option>
					  <option><value>http://jabber.org/protocol/ibb</value></option>
					</field>
				  </x>
				</feature>
			  </si>;
			var testValue:String = "text/plain";
			
			var ext:StreamInitiationExtension = new StreamInitiationExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.mimeType );
		}
		
		[Test( description="XML parse - profile" )]
		public function testParseProfile():void
		{
			var incoming:XML = <si xmlns='http://jabber.org/protocol/si'
				  id='a0'
				  mime-type='text/plain'
				  profile='http://jabber.org/protocol/si/profile/file-transfer'>
				<file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
					  name='test.txt'
					  size='1022'>
				  <desc>This is info about the file.</desc>
				</file>
				<feature xmlns='http://jabber.org/protocol/feature-neg'>
				  <x xmlns='jabber:x:data' type='form'>
					<field var='stream-method' type='list-single'>
					  <option><value>http://jabber.org/protocol/bytestreams</value></option>
					  <option><value>jabber:iq:oob</value></option>
					  <option><value>http://jabber.org/protocol/ibb</value></option>
					</field>
				  </x>
				</feature>
			  </si>;
			var testValue:String = "http://jabber.org/protocol/si/profile/file-transfer";
			
			var ext:StreamInitiationExtension = new StreamInitiationExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.profile );
		}
		
		
		

	}
}
