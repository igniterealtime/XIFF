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
	
	public class MessageTest
	{
		
		
		[Test( description="Message body" )]
		public function testBody():void
		{
			var body:String = "body of the message could be anything";
			var message:Message = new Message();
			
			assertEquals( body, message.body );
		}
		
		[Test( description="Message HTML body" )]
		public function testHtmlBody():void
		{
			var htmlBody:String = "<strong>Hi there</strong>";
			var message:Message = new Message();
			
			assertEquals( htmlBody, message.htmlBody );
		}
		
		[Test( description="Message thread" )]
		public function testThread():void
		{
			var thread:String = "a numeric value maybe?";
			var message:Message = new Message();
			
			assertEquals( thread, message.thread );
		}
		
		/*
		[Test( description="Message time" )]
		public function testTime():void
		{
			var time:Date = new Date();
			var message:Message = new Message();
			
			assertEquals( time, message.time );
		}
		*/
		
		[Test( description="Message state active" )]
		public function testStateActive():void
		{
			var state:String = "active";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}
		
		[Test( description="Message state composing" )]
		public function testStateComposing():void
		{
			var state:String = "composing";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}
		
		[Test( description="Message state paused" )]
		public function testStatePaused():void
		{
			var state:String = "paused";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}
		
		[Test( description="Message state inactive" )]
		public function testStateInactive():void
		{
			var state:String = "inactive";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}
		
		[Test( description="Message state gone" )]
		public function testStateGone():void
		{
			var state:String = "gone";
			var nameSpace:String = "http://jabber.org/protocol/chatstates";
			var message:Message = new Message();
			message.state = state;
			
			assertEquals( state, message.state );
		}

		/*
		[Test( description="Message receipt request" )]
		public function testReceiptRequest():void
		{
			var receipt:String = "request";
			var nameSpace:String = "urn:xmpp:receipts";
			var message:Message = new Message();
			
			//assertEquals( state, message.state );
		}
		
		[Test( description="Message receipt received" )]
		public function testReceiptReceived():void
		{
			var receipt:String = "received";
			var nameSpace:String = "urn:xmpp:receipts";
			var message:Message = new Message();
			
			// The <received/> element SHOULD be the only child of
			// the <message/> stanza and MUST mirror the 'id' of the sent message.
			assertEquals( 1, message.getNode().childNodes.length );
			
		}
		*/
		
	}
}
