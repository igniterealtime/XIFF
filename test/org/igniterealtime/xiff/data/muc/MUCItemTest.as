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
package org.igniterealtime.xiff.data.muc
{
	import org.flexunit.asserts.*;
	import org.igniterealtime.xiff.core.EscapedJID;
	
	public class MUCItemTest
	{
		
		
		[Test( description="actor value" )]
		public function testValueActor():void
		{
			var testValue:EscapedJID = new EscapedJID("");
			
			var ext:MUCItem = new MUCItem();
			ext.actor = testValue;
			
			assertEquals( testValue.toString(), ext.actor.toString() );
		}
		
		[Test( description="actorNick value" )]
		public function testValueActorNick():void
		{
			var testValue:String = "NikkyNiccy";
			
			var ext:MUCItem = new MUCItem();
			ext.actorNick = testValue;
			
			assertEquals( testValue, ext.actorNick );
		}
		
		[Test( description="affiliation value" )]
		public function testValueAffiliation():void
		{
			var testValue:String = "secretPassWord01234";
			
			var ext:MUCItem = new MUCItem();
			ext.affiliation = testValue;
			
			assertEquals( testValue, ext.affiliation );
		}
		
		[Test( description="reason value" )]
		public function testValueReason():void
		{
			var testValue:String = "secretPassWord01234";
			
			var ext:MUCItem = new MUCItem();
			ext.reason = testValue;
			
			assertEquals( testValue, ext.reason );
		}
		
		[Test( description="role value" )]
		public function testValueRole():void
		{
			var testValue:String = "participant";
			
			var ext:MUCItem = new MUCItem();
			ext.role = testValue;
			
			assertEquals( testValue, ext.role );
		}
		
		[Test( description="jid value" )]
		public function testValueJid():void
		{
			var testValue:EscapedJID = new EscapedJID("hag66@shakespeare.lit/pda");
			
			var ext:MUCItem = new MUCItem();
			ext.jid = testValue;
			
			assertEquals( testValue.toString(), ext.jid.toString() );
		}
		
		[Test( description="nick value" )]
		public function testValueNick():void
		{
			var testValue:String = "secretPassWord01234";
			
			var ext:MUCItem = new MUCItem();
			ext.nick = testValue;
			
			assertEquals( testValue, ext.nick );
		}
		
		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "item";
			
			var ext:MUCItem = new MUCItem();
			var node:XML = ext.xml;
			
			assertEquals( elementName, node.localName() );
		}
		
		[Test( description="XML parse - actor" )]
		public function testParseActor():void
		{
			var incoming:XML = <item affiliation='none' role='none'>
			  <actor nick='Fluellen' jid="flue@llen.tt/rapidRate"/>
			  <reason>Avaunt, you cullion!</reason>
			</item>;
			var testValue:String = "flue@llen.tt/rapidRate";
			
			var ext:MUCItem = new MUCItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.actor.toString() );
		}
		
		[Test( description="XML parse - actor nick" )]
		public function testParseActorNick():void
		{
			var incoming:XML = <item affiliation='none' role='none'>
			  <actor nick='Fluellen' jid="flue@llen.tt/rapidRate"/>
			  <reason>Avaunt, you cullion!</reason>
			</item>;
			var testValue:String = "Fluellen";
			
			var ext:MUCItem = new MUCItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.actorNick );
		}
		
		[Test( description="XML parse - affiliation" )]
		public function testParseAffiliation():void
		{
			var incoming:XML = <item affiliation='none'
			  jid='hag66@shakespeare.lit/pda'
			  role='participant'/>;
			var testValue:String = "none";
			
			var ext:MUCItem = new MUCItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.affiliation );
		}
		
		[Test( description="XML parse - reason" )]
		public function testParseReason():void
		{
			var incoming:XML = <item affiliation='none' role='none'>
			  <actor nick='Fluellen' jid="flue@llen.tt/rapidRate"/>
			  <reason>Avaunt, you cullion!</reason>
			</item>;
			var testValue:String = "Avaunt, you cullion!";
			
			var ext:MUCItem = new MUCItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.reason );
		}
		
		[Test( description="XML parse - role" )]
		public function testParseRole():void
		{
			var incoming:XML = <item affiliation='none'
			  jid='hag66@shakespeare.lit/pda'
			  role='participant'/>;
			var testValue:String = "participant";
			
			var ext:MUCItem = new MUCItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.role );
		}
		
		[Test( description="XML parse - jid" )]
		public function testParseJid():void
		{
			var incoming:XML = <item affiliation='none'
			  jid='hag66@shakespeare.lit/pda'
			  role='participant'/>;
			var testValue:String = "hag66@shakespeare.lit/pda";
			
			var ext:MUCItem = new MUCItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.jid.toString() );
		}
		
		[Test( description="XML parse - nick" )]
		public function testParseNick():void
		{
			var incoming:XML = <item affiliation='member'
			  jid='hag66@shakespeare.lit/pda'
			  nick='oldhag'
			  role='participant'/>;
			var testValue:String = "oldhag";
			
			var ext:MUCItem = new MUCItem();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.nick );
		}
		
		

	}
}
