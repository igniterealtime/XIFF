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
package org.igniterealtime.xiff.data.xhtml
{
	import org.flexunit.asserts.*;
	
	public class XHTMLExtensionTest
	{
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/xhtml-im";
			var elementName:String = "html";
			
			var ext:XHTMLExtension = new XHTMLExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		/*
		[Test( description="parse from XML - body" )]
		public function testParseBody():void
		{
			var incoming:XML = <html xmlns='http://jabber.org/protocol/xhtml-im'>
				<body xmlns='http://www.w3.org/1999/xhtml'>
				  <p style='font-weight:bold'>hi!</p>
				</body>
			  </html>;
			var testValue:String = "<p style='font-weight:bold'>hi!</p>";
			
			var ext:XHTMLExtension = new XHTMLExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.body );
		}
		*/

	}
}
