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
	import org.igniterealtime.xiff.core.EscapedJID;

	public class XMPPStanzaTest
	{
		
		[Test( description="to value" )]
		public function testValueTo():void
		{
			var testValue:EscapedJID = new EscapedJID("juliet@capulet.lit/balcony");
			var stanza:XMPPStanza = new XMPPStanza(testValue, null, null, "ID3", XMPPStanza.ELEMENT_IQ);
			
			assertEquals( testValue.toString(), stanza.to.toString() );
		}
		
		[Test( description="from value" )]
		public function testValueFrom():void
		{
			var testValue:EscapedJID = new EscapedJID("juliet@capulet.lit/balcony");
			var stanza:XMPPStanza = new XMPPStanza(null, testValue, null, "ID3", XMPPStanza.ELEMENT_IQ);
			
			assertEquals( testValue.toString(), stanza.from.toString() );
		}
		
		[Test( description="type value" )]
		public function testValueType():void
		{
			var testValue:String = "hoplaa";
			var stanza:XMPPStanza = new XMPPStanza(null, null, testValue, "ID3", XMPPStanza.ELEMENT_IQ);
			
			assertEquals( testValue, stanza.type );
		}
		
		
		[Test( description="XML parse - Error type" )]
		public function testParseErrorType():void
		{
			var incoming:XML = <iq from='juliet@capulet.lit/balcony' to='capulet.lit' id='s2c1' type='error'>
			  <ping xmlns='urn:xmpp:ping'/>
			  <error type='cancel'>
				<service-unavailable xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
			  </error>
			</iq>;
			var testValue:String = "cancel";
			
			var stanza:XMPPStanza = new XMPPStanza(null, null, null, "ID3", XMPPStanza.ELEMENT_TEMP);
			stanza.xml = incoming;
			
			assertEquals( testValue, stanza.errorType );
		}

		[Test( description="XML parse - Error condition" )]
		public function testParseErrorCondition():void
		{
			var incoming:XML = <iq type='error' from='pubsub.shakespeare.lit' to='francisco@denmark.lit/barracks' id='sub1'>
			  <error type='modify'>
				<bad-request xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
			  </error>
			</iq>;
			var testValue:String = "bad-request";
			
			var stanza:XMPPStanza = new XMPPStanza(null, null, null, "ID3", XMPPStanza.ELEMENT_TEMP);
			stanza.xml = incoming;
			
			assertEquals( testValue, stanza.errorCondition );
		}
		
		[Test( description="XML parse - Error code" )]
		public function testParseErrorCode():void
		{
			var incoming:XML = <iq type="error" id="add_user_6" to="flasher@192.168.1.37/xiff">
				<query xmlns="jabber:iq:roster">
					<item jid="apina@192.168.1.37" subscription="null" name="apina@192.168.1.37">
						<group>Buddies</group>
					</item>
				</query>
				<error code="500" type="wait">
					<internal-server-error xmlns="urn:ietf:params:xml:ns:xmpp-stanzas"/>
				</error>
			</iq>;
			var testValue:int = 500;
			
			var stanza:XMPPStanza = new XMPPStanza(null, null, null, "ID3", XMPPStanza.ELEMENT_TEMP);
			stanza.xml = incoming;
			
			assertEquals( testValue, stanza.errorCode );
		}

		[Test( description="XML parse - to" )]
		public function testParseTo():void
		{
			var incoming:XML = <iq type='error' from='pubsub.shakespeare.lit' to='francisco@denmark.lit/barracks' id='sub1'>
			  <error type='modify'>
				<bad-request xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
			  </error>
			</iq>;
			var testValue:String = "francisco@denmark.lit/barracks";
			
			var stanza:XMPPStanza = new XMPPStanza(null, null, null, "ID3", XMPPStanza.ELEMENT_TEMP);
			stanza.xml = incoming;
			
			assertEquals( testValue, stanza.to );
		}

		[Test( description="XML parse - from" )]
		public function testParseFrom():void
		{
			var incoming:XML = <iq type='error' from='pubsub.shakespeare.lit' to='francisco@denmark.lit/barracks' id='sub1'>
			  <error type='modify'>
				<bad-request xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
			  </error>
			</iq>;
			var testValue:String = "pubsub.shakespeare.lit";
			
			var stanza:XMPPStanza = new XMPPStanza(null, null, null, "ID3", XMPPStanza.ELEMENT_TEMP);
			stanza.xml = incoming;
			
			assertEquals( testValue, stanza.from );
		}

		[Test( description="XML parse - id" )]
		public function testParseId():void
		{
			var incoming:XML = <iq type='error' from='pubsub.shakespeare.lit' to='francisco@denmark.lit/barracks' id='sub1'>
			  <error type='modify'>
				<bad-request xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
			  </error>
			</iq>;
			var testValue:String = "sub1";
			
			var stanza:XMPPStanza = new XMPPStanza(null, null, null, "ID3", XMPPStanza.ELEMENT_TEMP);
			stanza.xml = incoming;
			
			assertEquals( testValue, stanza.id );
		}

		[Test( description="XML parse - type" )]
		public function testParseType():void
		{
			var incoming:XML = <iq type='error' from='pubsub.shakespeare.lit' to='francisco@denmark.lit/barracks' id='sub1'>
			  <error type='modify'>
				<bad-request xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
			  </error>
			</iq>;
			var testValue:String = "error";
			
			var stanza:XMPPStanza = new XMPPStanza(null, null, null, "ID3", XMPPStanza.ELEMENT_TEMP);
			stanza.xml = incoming;
			
			assertEquals( testValue, stanza.type );
		}


	}
}
