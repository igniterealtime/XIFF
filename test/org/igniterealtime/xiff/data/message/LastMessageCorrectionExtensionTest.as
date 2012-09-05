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

	public class LastMessageCorrectionExtensionTest
	{

		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "urn:xmpp:message-correct:0";
			var elementName:String = "replace";
			
			var ext:LastMessageCorrectionExtension = new LastMessageCorrectionExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}

		[Test( description="Value of id" )]
		public function testValueId():void
		{
			var testValue:String = "msgId";

			var ext:LastMessageCorrectionExtension = new LastMessageCorrectionExtension();
			ext.id = testValue;

			assertEquals( testValue, ext.id );
		}

		[Test( description="Parse XML - id" )]
		public function testParseId():void
		{
			var incoming:XML = <replace id='bad1' xmlns='urn:xmpp:message-correct:0'/>;
			var testValue:String = "bad1";

			var ext:LastMessageCorrectionExtension = new LastMessageCorrectionExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.id );
		}

	


	}
}
