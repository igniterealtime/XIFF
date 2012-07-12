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
	
	public class FileTransferExtensionTest
	{
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/si/profile/file-transfer";
			var elementName:String = "file";
			
			var ext:FileTransferExtension = new FileTransferExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="XML parse - size" )]
		public function testParseSize():void
		{
			var incoming:XML = <file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
				  name='test.txt'
				  size='1022'
				  hash='552da749930852c69ae5d2141d3766b1'
				  date='1969-07-21T02:56:15Z'>
			  <desc>This is a test. If this were a real file...</desc>
			</file>;
			var testValue:uint = 1022;
			
			var ext:FileTransferExtension = new FileTransferExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.size );
		}
		
		[Test( description="XML parse - name" )]
		public function testParseName():void
		{
			var incoming:XML = <file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
				  name='test.txt'
				  size='1022'
				  hash='552da749930852c69ae5d2141d3766b1'
				  date='1969-07-21T02:56:15Z'>
			  <desc>This is a test. If this were a real file...</desc>
			</file>;
			var testValue:String = "test.txt";
			
			var ext:FileTransferExtension = new FileTransferExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.name );
		}
		
		[Test( description="XML parse - date" )]
		public function testParseDate():void
		{
			var incoming:XML = <file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
				  name='test.txt'
				  size='1022'
				  hash='552da749930852c69ae5d2141d3766b1'
				  date='1969-07-21T02:56:15Z'>
			  <desc>This is a test. If this were a real file...</desc>
			</file>;
			var testValue:String = "Mon Jul 21 02:56:15 1969 UTC";
			
			var ext:FileTransferExtension = new FileTransferExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.date.toUTCString() );
		}
		
		[Test( description="XML parse - hash" )]
		public function testParseHash():void
		{
			var incoming:XML = <file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
				  name='test.txt'
				  size='1022'
				  hash='552da749930852c69ae5d2141d3766b1'
				  date='1969-07-21T02:56:15Z'>
			  <desc>This is a test. If this were a real file...</desc>
			</file>;
			var testValue:String = "552da749930852c69ae5d2141d3766b1";
			
			var ext:FileTransferExtension = new FileTransferExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.hash );
		}
		
		[Test( description="XML parse - desc" )]
		public function testParseDesc():void
		{
			var incoming:XML = <file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
				  name='test.txt'
				  size='1022'
				  hash='552da749930852c69ae5d2141d3766b1'
				  date='1969-07-21T02:56:15Z'>
			  <desc>This is a test. If this were a real file...</desc>
			</file>;
			var testValue:String = "This is a test. If this were a real file...";
			
			var ext:FileTransferExtension = new FileTransferExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.desc );
		}
		
		[Test( description="XML parse - hasRange" )]
		public function testParseHasRange():void
		{
			var incoming:XML = <file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
				  name='test.txt'
				  size='1022'
				  hash='552da749930852c69ae5d2141d3766b1'
				  date='1969-07-21T02:56:15Z'>
			  <desc>This is a test. If this were a real file...</desc>
			  <range offset='128' length='256'/>
			</file>;
			var testValue:Boolean = true;
			
			var ext:FileTransferExtension = new FileTransferExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.hasRange );
		}
		
		[Test( description="XML parse - rangeOffset" )]
		public function testParseRangeOffset():void
		{
			var incoming:XML = <file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
				  name='test.txt'
				  size='1022'
				  hash='552da749930852c69ae5d2141d3766b1'
				  date='1969-07-21T02:56:15Z'>
			  <desc>This is a test. If this were a real file...</desc>
			  <range offset='128' length='256'/>
			</file>;
			var testValue:uint = 128;
			
			var ext:FileTransferExtension = new FileTransferExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.rangeOffset );
		}
		
		[Test( description="XML parse - rangeLength" )]
		public function testParseRangeLength():void
		{
			var incoming:XML = <file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
				  name='test.txt'
				  size='1022'
				  hash='552da749930852c69ae5d2141d3766b1'
				  date='1969-07-21T02:56:15Z'>
			  <desc>This is a test. If this were a real file...</desc>
			  <range offset='128' length='256'/>
			</file>;
			var testValue:uint = 256;
			
			var ext:FileTransferExtension = new FileTransferExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.rangeLength );
		}
		
		

	}
}
