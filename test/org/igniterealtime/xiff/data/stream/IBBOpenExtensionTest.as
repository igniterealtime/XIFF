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
package org.igniterealtime.xiff.data.stream
{
	import org.flexunit.asserts.*;

	public class IBBOpenExtensionTest
	{

		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/ibb";
			var elementName:String = "open";

			var ext:IBBOpenExtension = new IBBOpenExtension();
			var node:XML = ext.xml;

			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}

		[Test( description="XML parse - blockSize" )]
		public function testParseBlockSize():void
		{
			var incoming:XML = <open xmlns='http://jabber.org/protocol/ibb'
				block-size='4096'
				sid='i781hf64'
				stanza='iq'/>;

			var testValue:uint = 4096;

			var ext:IBBOpenExtension = new IBBOpenExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.blockSize );
		}

		[Test( description="XML parse - stanza" )]
		public function testParseStanza():void
		{
			var incoming:XML = <open xmlns='http://jabber.org/protocol/ibb'
				block-size='4096'
				sid='i781hf64'
				stanza='iq'/>;

			var testValue:String = "iq";

			var ext:IBBOpenExtension = new IBBOpenExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.stanza );
		}

		[Test( description="XML parse - sid" )]
		public function testParseSid():void
		{
			var incoming:XML = <open xmlns='http://jabber.org/protocol/ibb'
				block-size='4096'
				sid='i781hf64'
				stanza='iq'/>;

			var testValue:String = "i781hf64";

			var ext:IBBOpenExtension = new IBBOpenExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.sid );
		}





	}
}
