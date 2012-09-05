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
package org.igniterealtime.xiff.data.im
{
	import org.flexunit.asserts.*;

	public class UserNicknameExtensionTest
	{

		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/nick";
			var elementName:String = "nick";
			
			var ext:UserNicknameExtension = new UserNicknameExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}

		[Test( description="Value of nickname" )]
		public function testValueNickname():void
		{
			var testValue:String = "Ishmael";

			var ext:UserNicknameExtension = new UserNicknameExtension();
			ext.nickname = testValue;

			assertEquals( testValue, ext.nickname );
		}

		[Test( description="Parse XML - nickname" )]
		public function testParseNickname():void
		{
			var incoming:XML = <nick xmlns='http://jabber.org/protocol/nick'>Ishmael</nick>;
			var testValue:String = "Ishmael";

			var ext:UserNicknameExtension = new UserNicknameExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.nickname );
		}

	


	}
}
