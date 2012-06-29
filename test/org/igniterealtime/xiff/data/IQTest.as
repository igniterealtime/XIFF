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

	public class IQTest
	{
		[Test( description="IQ callback" )]
		public function testCallback():void
		{
			var callback:Function = Math.abs;
			var iq:IQ = new IQ();
			iq.callback = callback;
			
			assertEquals( callback, iq.callback );
		}
		
		[Test( description="IQ errorCallback" )]
		public function testErrorCallback():void
		{
			var errorCallback:Function = Math.max;
			var iq:IQ = new IQ();
			iq.errorCallback = errorCallback;
			
			assertEquals( errorCallback, iq.errorCallback );
		}
		

		// http://xmpp.org/extensions/xep-0199.html
		[Test( description="IQ parse from XML - Ping Extension gets created" )]
		public function testParsePingExtension():void
		{
			var incoming:XML = <iq from='juliet@capulet.lit/balcony' to='capulet.lit' id='c2s1' type='get'>
			  <ping xmlns='urn:xmpp:ping'/>
			</iq>;
			var testValue:String = "error";
			
			var iq:IQ = new IQ();
			iq.xml = incoming;
			
			assertEquals( testValue, iq.type );
		}
		
		// http://xmpp.org/extensions/xep-0199.html
		[Test( description="IQ parse from XML - Ping Error" )]
		public function testParsePingError():void
		{
			var incoming:XML = <iq from='juliet@capulet.lit/balcony' to='capulet.lit' id='s2c1' type='error'>
			  <ping xmlns='urn:xmpp:ping'/>
			  <error type='cancel'>
				<service-unavailable xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
			  </error>
			</iq>;
			var testValue:String = "error";
			
			var iq:IQ = new IQ();
			iq.xml = incoming;
			
			assertEquals( testValue, iq.type );
		}


	}
}
