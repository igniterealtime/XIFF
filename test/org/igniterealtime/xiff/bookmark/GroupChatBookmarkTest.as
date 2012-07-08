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
package org.igniterealtime.xiff.bookmark
{
	import org.flexunit.asserts.assertEquals;
	import org.igniterealtime.xiff.core.EscapedJID;
	
	public class GroupChatBookmarkTest
	{
		[Test( description="JID checking" )]
		public function testJid():void
		{
			var testValue:EscapedJID = new EscapedJID("batman@gotham-city.gov");
			var ext:GroupChatBookmark = new GroupChatBookmark(testValue);
			
			assertEquals( testValue.toString(), ext.jid.toString() );
		}
		
		[Test( description="name checking" )]
		public function testName():void
		{
			var testValue:String = "batman";
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("batman@gotham-city.gov"), testValue);
			
			assertEquals( testValue, ext.name );
		}
		
		[Test( description="autoJoin true checking" )]
		public function testAutoJoinTrue():void
		{
			var testValue:Boolean = true;
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("batman@gotham-city.gov"), "batman", testValue);
			
			assertEquals( testValue, ext.autoJoin );
		}
		
		[Test( description="autoJoin false checking" )]
		public function testAutoJoinFalse():void
		{
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("batman@gotham-city.gov"));
			
			assertEquals( false, ext.autoJoin );
		}
		
		[Test( description="nickname checking" )]
		public function testNickname():void
		{
			var testValue:String = "batman";
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("batman@gotham-city.gov"), null, false, testValue);
			
			assertEquals( testValue, ext.nickname );
		}
		
		[Test( description="password checking" )]
		public function testPassword():void
		{
			var testValue:String = "secret";
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("batman@gotham-city.gov"), null, false, null, testValue);
			
			assertEquals( testValue, ext.password );
		}
		
		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "conference";
			
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("batman@gotham-city.gov"));
			var node:XML = ext.xml;
			
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="parse from XML - jid" )]
		public function testParseJid():void
		{
			var incoming:XML = <conference name='Council of Oberon'
                  autojoin='true'
                  jid='council@conference.underhill.org'>
				<nick>Puck</nick>
			  </conference>;
			var testValue:String = "council@conference.underhill.org";
			
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("temp@temp.tmp"));
			ext.xml = incoming;
			
			assertEquals( testValue, ext.jid.toString() );
		}
		
		[Test( description="parse from XML - name" )]
		public function testParseName():void
		{
			var incoming:XML = <conference name='Council of Oberon'
                  autojoin='true'
                  jid='council@conference.underhill.org'>
				<nick>Puck</nick>
			  </conference>;
			var testValue:String = "Council of Oberon";
			
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("temp@temp.tmp"));
			ext.xml = incoming;
			
			assertEquals( testValue, ext.name );
		}
		
		[Test( description="parse from XML - autoJoin" )]
		public function testParseAutoJoin():void
		{
			var incoming:XML = <conference name='Council of Oberon'
                  autojoin='true'
                  jid='council@conference.underhill.org'>
				<nick>Puck</nick>
			  </conference>;
			var testValue:Boolean = true;
			
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("temp@temp.tmp"));
			ext.xml = incoming;
			
			assertEquals( testValue, ext.autoJoin );
		}
		
		[Test( description="parse from XML - nickname" )]
		public function testParseNickname():void
		{
			var incoming:XML = <conference name='Council of Oberon'
                  autojoin='true'
                  jid='council@conference.underhill.org'>
				<nick>Puck</nick>
			  </conference>;
			var testValue:String = "Puck";
			
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("temp@temp.tmp"));
			ext.xml = incoming;
			
			assertEquals( testValue, ext.nickname );
		}
		
		[Test( description="parse from XML - password" )]
		public function testParsePassword():void
		{
			var incoming:XML = <conference name='Council of Oberon'
                  autojoin='true'
                  jid='council@conference.underhill.org'>
				<nick>Puck</nick>
				<password>OMG do not use</password>
			  </conference>;
			var testValue:String = "OMG do not use";
			
			var ext:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("temp@temp.tmp"));
			ext.xml = incoming;
			
			assertEquals( testValue, ext.password );
		}
		
	}
}
