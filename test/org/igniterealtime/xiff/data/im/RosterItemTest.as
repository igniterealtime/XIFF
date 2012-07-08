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
	import org.igniterealtime.xiff.core.EscapedJID;
	
	public class RosterItemTest
	{
		
		[Test( description="jid value" )]
		public function testValueJid():void
		{
			var testValue:String = "contact@example.org";
			
			var ext:RosterItem = new RosterItem();
			ext.jid = new EscapedJID(testValue);
			
			assertEquals( testValue, ext.jid.toString() );
		}
		
		[Test( description="name value" )]
		public function testValueName():void
		{
			var testValue:String = "MyContact";
			
			var ext:RosterItem = new RosterItem();
			ext.name = testValue;
			
			assertEquals( testValue, ext.name );
		}
		
		[Test( description="subscription value" )]
		public function testValueSubscription():void
		{
			var testValue:String = "none";
			
			var ext:RosterItem = new RosterItem();
			ext.subscription = testValue;
			
			assertEquals( testValue, ext.subscription );
		}
		
		[Test( description="askType value" )]
		public function testValueaAskType():void
		{
			var testValue:String = "subscribe";
			
			var ext:RosterItem = new RosterItem();
			ext.askType = testValue;
			
			assertEquals( testValue, ext.askType );
		}
		
		[Test( description="addGroupNamed method" )]
		public function testAddGroupNamed():void
		{
			var testValue:String = "MyBuddies";
			
			var ext:RosterItem = new RosterItem();
			ext.addGroupNamed(testValue);
			
			var list:Array = [testValue];
			
			assertEquals( list.toString(), ext.groupNames.toString() );
		}
		
		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "item";
			
			var ext:RosterItem = new RosterItem();
			var node:XML = ext.xml;
			
			assertEquals( elementName, node.localName() );
		}
	
		[Test( description="parse from XML - jid" )]
		public function testParseJid():void
		{
			var incoming:XML = <item
				   jid='contact@example.org'
				   subscription='none'
				   name='MyContact'>
				 <group>MyBuddies</group>
			   </item>;
			var testValue:String = "contact@example.org";
			
			var ext:RosterItem = new RosterItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.jid.toString() );
		}
	
		[Test( description="parse from XML - name" )]
		public function testParseName():void
		{
			var incoming:XML = <item
				   jid='contact@example.org'
				   subscription='none'
				   name='MyContact'>
				 <group>MyBuddies</group>
			   </item>;
			var testValue:String = "MyContact";
			
			var ext:RosterItem = new RosterItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.name );
		}
	
		[Test( description="parse from XML - subscription" )]
		public function testParseSubscription():void
		{
			var incoming:XML = <item
				   jid='contact@example.org'
				   subscription='none'
				   name='MyContact'>
				 <group>MyBuddies</group>
			   </item>;
			var testValue:String = "none";
			
			var ext:RosterItem = new RosterItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.subscription );
		}
	
		[Test( description="parse from XML - groupCount" )]
		public function testParseGroupCount():void
		{
			var incoming:XML = <item
				   jid='contact@example.org'
				   subscription='none'
				   name='MyContact'>
				 <group>MyBuddies</group>
			   </item>;
			var testValue:int = 1;
			
			var ext:RosterItem = new RosterItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.groupCount );
		}
	
		[Test( description="parse from XML - groupNames" )]
		public function testParseGroupNames():void
		{
			var incoming:XML = <item
				   jid='contact@example.org'
				   subscription='none'
				   name='MyContact'>
				 <group>MyBuddies</group>
			   </item>;
			var testValue:String = "MyBuddies";
			
			var ext:RosterItem = new RosterItem();
			ext.xml = incoming;
			
			var list:Array = [testValue];
			
			assertEquals( list.toString(), ext.groupNames.toString() );
		}
	}
}
