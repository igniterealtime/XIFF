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
package org.igniterealtime.xiff.data
{
	import org.flexunit.asserts.assertEquals;
	
	import flash.xml.XMLNode;
	
	/**
	 * First tests are about setting values to a new Message.
	 *
	 * Further down the class there are tests that are used to
	 * parse a given XML as it would come from the server.
	 * XML snippets from http://xmpp.org/extensions/xep-0085.html
	 */
	public class MessageTest
	{
		private var _xml:XML;
		
		[Before]
		public function setupMessage():void
		{
			_xml = <message/>;
		}
		
		[Test( description="Message body" )]
		public function testValueBody():void
		{
			var body:String = "body of the message could be anything";
			var message:Message = new Message();
			message.body = body;
			
			assertEquals( body, message.body );
		}
		
		[Test( description="Message HTML body" )]
		public function testValueHtmlBody():void
		{
			var htmlBody:String = "<strong>Hi there</strong>";
			var message:Message = new Message();
			message.htmlBody = htmlBody;
			
			assertEquals( htmlBody, message.htmlBody );
		}
		
		[Test( description="Message thread" )]
		public function testValueThread():void
		{
			var thread:String = "chatting123";
			var message:Message = new Message();
			message.thread = thread;
			
			assertEquals( thread, message.thread );
		}
		
		[Test( description="Message subject" )]
		public function testValueSubject():void
		{
			var subject:String = "Hello there everybody. Please download something...";
			var message:Message = new Message();
			message.subject = subject;
			
			assertEquals( subject, message.subject );
		}
		
		[Test( description="Message state active" )]
		public function testValueStateActive():void
		{
			var state:String = "active";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}
		
		[Test( description="Message state composing" )]
		public function testValueStateComposing():void
		{
			var state:String = "composing";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}
		
		[Test( description="Message state paused" )]
		public function testValueStatePaused():void
		{
			var state:String = "paused";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}
		
		[Test( description="Message state inactive" )]
		public function testValueStateInactive():void
		{
			var state:String = "inactive";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}
		
		[Test( description="Message state gone" )]
		public function testValueStateGone():void
		{
			var state:String = "gone";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}

		/**
		 * @see http://xmpp.org/extensions/xep-0184.html
		 *
		[Test( description="Message receipt request" )]
		public function testReceiptRequest():void
		{
			var receipt:String = "request";
			var message:Message = new Message();
			message.receipt = receipt;
			
			assertEquals( receipt, message.receipt );
		}
		
		[Test( description="Message receipt received" )]
		public function testReceiptReceived():void
		{
			var receipt:String = "received";
			var message:Message = new Message();
			message.receipt = receipt;
			
			// The <received/> element SHOULD be the only child of
			// the <message/> stanza and MUST mirror the 'id' of the sent message.
			assertEquals( receipt, message.receipt );
			assertEquals( 1, message.xml.children().length() );
		}
		*/
		
		
		
		
		
		[Test( description="Message parse from XML - state composing" )]
		public function testParseStateComposing():void
		{
			var incoming:XML = <message
				from='bernardo@shakespeare.lit/pda'
				to='francisco@shakespeare.lit/elsinore'
				type='chat'>
			  <composing xmlns='http://jabber.org/protocol/chatstates'/>
			</message>;
			var testValue:String = "composing";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.state );
		}
		
		[Test( description="Message parse from XML - state active" )]
		public function testParseStateActive():void
		{
			var incoming:XML = <message
				from='bernardo@shakespeare.lit/pda'
				to='francisco@shakespeare.lit/elsinore'
				type='chat'>
			  <body>Long live the king!</body>
			  <active xmlns='http://jabber.org/protocol/chatstates'/>
			</message>;
			var testValue:String = "active";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.state );
		}
		
		[Test( description="Message parse from XML - state gone" )]
		public function testParseStateGone():void
		{
			var incoming:XML = <message
				from='juliet@capulet.com/balcony'
				to='romeo@shakespeare.lit/orchard'
				type='chat'>
			  <thread>act2scene2chat1</thread>
			  <gone xmlns='http://jabber.org/protocol/chatstates'/>
			</message>;
			var testValue:String = "gone";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.state );
		}
		
		[Test( description="Message parse from XML - state inactive" )]
		public function testParseStateInactive():void
		{
			var incoming:XML = <message
				from='juliet@capulet.com/balcony'
				to='romeo@shakespeare.lit/orchard'
				type='chat'>
			  <thread>act2scene2chat1</thread>
			  <inactive xmlns='http://jabber.org/protocol/chatstates'/>
			</message>;
			var testValue:String = "inactive";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.state );
		}
		
		
		[Test( description="Message parse from XML - state paused" )]
		public function testParseStatePaused():void
		{
			var incoming:XML = <message
				from='romeo@montague.net/orchard'
				to='juliet@capulet.com/balcony'
				type='chat'>
			  <thread>act2scene2chat1</thread>
			  <paused xmlns='http://jabber.org/protocol/chatstates'/>
			</message>;
			var testValue:String = "paused";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.state );
		}
		
		[Test( description="Message parse from XML - thread" )]
		public function testParseThread():void
		{
			var incoming:XML = <message
				from='romeo@montague.net/orchard'
				to='juliet@capulet.com/balcony'
				type='chat'>
			  <thread>act2scene2chat1</thread>
			  <composing xmlns='http://jabber.org/protocol/chatstates'/>
			</message>;
			var testValue:String = "act2scene2chat1";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.thread );
		}
		
		[Test( description="Message parse from XML - body" )]
		public function testParseBody():void
		{
			var incoming:XML = <message
				from='romeo@shakespeare.lit/orchard'
				to='juliet@capulet.com'
				type='chat'>
			  <thread>act2scene2chat1</thread>
			  <body>
				I take thee at thy word:
				Call me but love, and I'll be new baptized;
				Henceforth I never will be Romeo.
			  </body>
			  <active xmlns='http://jabber.org/protocol/chatstates'/>
			</message>;
			var testValue:String = "I take thee at thy word: Call me but love, and I'll be new baptized; Henceforth I never will be Romeo.";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.body );
		}
		
		[Test( description="Message parse from XML - subject" )]
		public function testParseSubject():void
		{
			var incoming:XML = <message
				from='coven@chat.shakespeare.lit/secondwitch'
				id='F437C672-D438-4BD3-9BFF-091050D32EE2'
				to='crone1@shakespeare.lit/desktop'
				type='groupchat'>
			  <subject>Fire Burn and Cauldron Bubble!</subject>
			</message>;
			var testValue:String = "Fire Burn and Cauldron Bubble!";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.subject );
		}
		
		/**
		 * @see http://xmpp.org/extensions/xep-0203.html
		 */
		[Test( description="Message parse from XML - time" )]
		public function testParseTime():void
		{
			var incoming:XML = <message
				from='romeo@montague.net/orchard'
				to='juliet@capulet.com'
				type='chat'>
			  <body>
				O blessed, blessed night! I am afeard.
				Being in night, all this is but a dream,
				Too flattering-sweet to be substantial.
			  </body>
			  <delay xmlns='urn:xmpp:delay'
				 from='capulet.com'
				 stamp='2002-09-10T23:08:25Z'>
				Offline Storage
			  </delay>
			</message>;
			var testValue:String = "Tue Sep 10 23:08:25 2002 UTC";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.time.toUTCString() );
		}
		
		/**
		 * @see http://xmpp.org/extensions/xep-0091.html
		 */
		[Test( description="Message parse from XML - time (legacy version)" )]
		public function testParseTimeLegacy():void
		{
			var incoming:XML = <message
				from='romeo@montague.net/orchard'
				to='juliet@capulet.com'
				type='chat'>
			  <body>
				O blessed, blessed night! I am afeard.
				Being in night, all this is but a dream,
				Too flattering-sweet to be substantial.
			  </body>
			  <x xmlns='jabber:x:delay'
				 from='capulet.com'
				 stamp='20020910T23:08:25'>
				Offline Storage
			  </x>
			</message>;
			var testValue:String = "Tue Sep 10 23:08:25 2002 UTC";

			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.time.toUTCString() );
		}
		
		
		[Test( description="Message parse from XML - type chat" )]
		public function testParseTypeChat():void
		{
			var incoming:XML = <message
				from='romeo@montague.net/orchard'
				to='juliet@capulet.com/balcony'
				type='chat'>
			  <thread>act2scene2chat1</thread>
			  <paused xmlns='http://jabber.org/protocol/chatstates'/>
			</message>;
			var testValue:String = "chat";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.type );
		}
		
		[Test( description="Message parse from XML - type error" )]
		public function testParseTypeError():void
		{
			var incoming:XML = <message type='error' id='another-id'>
				 <error type='modify'>
				   <undefined-condition
						 xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
				   <text xml:lang='en'
						 xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'>
					 Some special application diagnostic information...
				   </text>
				   <special-application-condition xmlns='application-ns'/>
				 </error>
			   </message>;
			var testValue:String = "error";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.type );
		}
		
		// http://xmpp.org/extensions/xep-0045.html
		[Test( description="Message parse from XML - type groupchat" )]
		public function testParseTypeGroupchat():void
		{
			var incoming:XML = <message
				from='coven@chat.shakespeare.lit/secondwitch'
				id='F437C672-D438-4BD3-9BFF-091050D32EE2'
				to='crone1@shakespeare.lit/desktop'
				type='groupchat'>
			  <subject>Fire Burn and Cauldron Bubble!</subject>
			</message>;
			var testValue:String = "groupchat";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.type );
		}
		
		/*
		[Test( description="Message parse from XML - type headline" )]
		public function testParseTypeHeadline():void
		{
			var incoming:XML = ;
			var testValue:String = "headline";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.type );
		}

		
		[Test( description="Message parse from XML - type normal" )]
		public function testParseTypeNormal():void
		{
			var incoming:XML = ;
			var testValue:String = "normal";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.type );
		}
		*/


		
		/**
		 * @see http://xmpp.org/extensions/xep-0184.html
		 *
		[Test( description="Message parse from XML - receipt request" )]
		public function testParseReceiptRequest():void
		{
			var incoming:XML = <message
				from='northumberland@shakespeare.lit/westminster'
				id='richard2-4.1.247'
				to='kingrichard@royalty.england.lit/throne'>
			  <body>My lord, dispatch; read o'er these articles.</body>
			  <request xmlns='urn:xmpp:receipts'/>
			</message>;
			var testValue:String = "receipt";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.receipt );
		}
		*/
		
		/**
		 * @see http://xmpp.org/extensions/xep-0184.html
		 *
		[Test( description="Message parse from XML - receipt request" )]
		public function testParseReceiptReceived():void
		{
			var incoming:XML = <message
				from='kingrichard@royalty.england.lit/throne'
				id='bi29sg183b4v'
				to='northumberland@shakespeare.lit/westminster'>
			  <received xmlns='urn:xmpp:receipts' id='richard2-4.1.247'/>
			</message>;
			var testValue:String = "received";
			
			var message:Message = new Message();
			message.xml = incoming;
			
			assertEquals( testValue, message.receipt );
		}
		*/
	}
}
