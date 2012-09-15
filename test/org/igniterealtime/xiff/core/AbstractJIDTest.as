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
package org.igniterealtime.xiff.core
{
	import org.flexunit.asserts.assertEquals;

	public class AbstractJIDTest
	{


		[Test( description="value - BareJID" )]
		public function testBareJID():void
		{
			var testValue:String = "catalog@shakespeare.lit";

			var jid:AbstractJID = new AbstractJID("catalog@shakespeare.lit/Secrets");

			assertEquals( testValue, jid.bareJID );
		}

		[Test( description="value - resource" )]
		public function testResource():void
		{
			var testValue:String = "Secrets";

			var jid:AbstractJID = new AbstractJID("catalog@shakespeare.lit/Secrets");

			assertEquals( testValue, jid.resource );
		}

		[Test( description="value - localpart" )]
		public function testLocalpart():void
		{
			var testValue:String = "catalog";

			var jid:AbstractJID = new AbstractJID("catalog@shakespeare.lit/Secrets");

			assertEquals( testValue, jid.localpart );
		}

		[Test( description="value - domain" )]
		public function testDomain():void
		{
			var testValue:String = "shakespeare.lit";

			var jid:AbstractJID = new AbstractJID("catalog@shakespeare.lit/Secrets");

			assertEquals( testValue, jid.domain );
		}

	}
}
