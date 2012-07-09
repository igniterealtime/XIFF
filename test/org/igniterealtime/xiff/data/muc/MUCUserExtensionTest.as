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
	
	public class MUCUserExtensionTest
	{
				
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/muc#user";
			var elementName:String = "x";
			
			var ext:MUCUserExtension = new MUCUserExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
	
		[Test( description="parse from XML - type invite" )]
		public function testParseTypeInvite():void
		{
			var incoming:XML = <x xmlns='http://jabber.org/protocol/muc#user'>
				<invite to='hecate@shakespeare.lit'>
				  <reason>
					Hey Hecate, this is the place for all good witches!
				  </reason>
				</invite>
			  </x>;
			var testValue:String = "invite";
			
			var ext:MUCUserExtension = new MUCUserExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.type );
		}
	
		[Test( description="parse from XML - to" )]
		public function testParseTo():void
		{
			var incoming:XML = <x xmlns='http://jabber.org/protocol/muc#user'>
				<invite to='hecate@shakespeare.lit'>
				  <reason>
					Hey Hecate, this is the place for all good witches!
				  </reason>
				</invite>
			  </x>;
			var testValue:String = "hecate@shakespeare.lit";
			
			var ext:MUCUserExtension = new MUCUserExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.to.toString() );
		}
	
		[Test( description="parse from XML - from" )]
		public function testParseFrom():void
		{
			var incoming:XML = <x xmlns='http://jabber.org/protocol/muc#user'>
				<invite from='crone1@shakespeare.lit/desktop'>
				  <reason>
					Hey Hecate, this is the place for all good witches!
				  </reason>
				</invite>
				<password>cauldronburn</password>
			  </x>;
			var testValue:String = "crone1@shakespeare.lit/desktop";
			
			var ext:MUCUserExtension = new MUCUserExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.from.toString() );
		}
	
		[Test( description="parse from XML - password" )]
		public function testParsePassword():void
		{
			var incoming:XML = <x xmlns='http://jabber.org/protocol/muc#user'>
				<invite from='crone1@shakespeare.lit/desktop'>
				  <reason>
					Hey Hecate, this is the place for all good witches!
				  </reason>
				</invite>
				<password>cauldronburn</password>
			  </x>;
			var testValue:String = "cauldronburn";
			
			var ext:MUCUserExtension = new MUCUserExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.password );
		}
	
		[Test( description="parse from XML - reason" )]
		public function testParseReason():void
		{
			var incoming:XML = <x xmlns='http://jabber.org/protocol/muc#user'>
				<invite from='crone1@shakespeare.lit/desktop'>
				  <reason>
					Hey Hecate, this is the place for all good witches!
				  </reason>
				</invite>
				<password>cauldronburn</password>
			  </x>;
			var testValue:String = "Hey Hecate, this is the place for all good witches!";
			
			var ext:MUCUserExtension = new MUCUserExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.reason );
		}
		
	}
}
