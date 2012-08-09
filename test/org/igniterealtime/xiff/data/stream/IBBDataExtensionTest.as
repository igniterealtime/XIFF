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

	public class IBBDataExtensionTest
	{

		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/ibb";
			var elementName:String = "data";

			var ext:IBBDataExtension = new IBBDataExtension();
			var node:XML = ext.xml;

			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}

		[Test( description="XML parse - seq" )]
		public function testParseSeq():void
		{
			var incoming:XML = <data xmlns='http://jabber.org/protocol/ibb' seq='8' sid='i781hf64'>
				qANQR1DBwU4DX7jmYZnncmUQB/9KuKBddzQH+tZ1ZywKK0yHKnq57kWq+RFtQdCJ
				WpdWpR0uQsuJe7+vh3NWn59/gTc5MDlX8dS9p0ovStmNcyLhxVgmqS8ZKhsblVeu
				IpQ0JgavABqibJolc3BKrVtVV1igKiX/N7Pi8RtY1K18toaMDhdEfhBRzO/XB0+P
				AQhYlRjNacGcslkhXqNjK5Va4tuOAPy2n1Q8UUrHbUd0g+xJ9Bm0G0LZXyvCWyKH
				kuNEHFQiLuCY6Iv0myq6iX6tjuHehZlFSh80b5BVV9tNLwNR5Eqz1klxMhoghJOA
			  </data>;
			var testValue:uint = 8

			var ext:IBBDataExtension = new IBBDataExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.seq );
		}

		[Test( description="XML parse - sid" )]
		public function testParseSid():void
		{
			var incoming:XML = <data xmlns='http://jabber.org/protocol/ibb' seq='0' sid='i781hf64'>
				qANQR1DBwU4DX7jmYZnncmUQB/9KuKBddzQH+tZ1ZywKK0yHKnq57kWq+RFtQdCJ
				WpdWpR0uQsuJe7+vh3NWn59/gTc5MDlX8dS9p0ovStmNcyLhxVgmqS8ZKhsblVeu
				IpQ0JgavABqibJolc3BKrVtVV1igKiX/N7Pi8RtY1K18toaMDhdEfhBRzO/XB0+P
				AQhYlRjNacGcslkhXqNjK5Va4tuOAPy2n1Q8UUrHbUd0g+xJ9Bm0G0LZXyvCWyKH
				kuNEHFQiLuCY6Iv0myq6iX6tjuHehZlFSh80b5BVV9tNLwNR5Eqz1klxMhoghJOA
			  </data>;

			var testValue:String = "i781hf64";

			var ext:IBBDataExtension = new IBBDataExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.sid );
		}

		[Test( description="XML parse - data" )]
		public function testParseData():void
		{
			var incoming:XML = <data xmlns='http://jabber.org/protocol/ibb' seq='0' sid='i781hf64'>
				qANQR1DBwU4DX7jmYZnncmUQB/9KuKBddzQH+tZ1ZywKK0yHKnq57kWq+RFtQdCJ
				WpdWpR0uQsuJe7+vh3NWn59/gTc5MDlX8dS9p0ovStmNcyLhxVgmqS8ZKhsblVeu
			  </data>;

			var testValue:String = "qANQR1DBwU4DX7jmYZnncmUQB/9KuKBddzQH+tZ1ZywKK0yHKnq57kWq+RFtQdCJWpdWpR0uQsuJe7+vh3NWn59/gTc5MDlX8dS9p0ovStmNcyLhxVgmqS8ZKhsblVeu";

			var ext:IBBDataExtension = new IBBDataExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.data );
		}





	}
}
