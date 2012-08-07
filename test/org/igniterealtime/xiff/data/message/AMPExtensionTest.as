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
package org.igniterealtime.xiff.data.message
{
	import org.flexunit.asserts.*;

	public class AMPExtensionTest
	{

		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/amp";
			var elementName:String = "amp";

			var ext:AMPExtension = new AMPExtension();
			var node:XML = ext.xml;

			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}

		[Test( description="XML parse - status" )]
		public function testParseStatus():void
		{
			var incoming:XML = <amp xmlns='http://jabber.org/protocol/amp'
					status='notify'
					to='bernardo@hamlet.lit/elsinore'
					from='francisco@hamlet.lit'>
				 <rule action='notify' condition='deliver' value='stored'/>
			   </amp>;
			var testValue:String = "notify";

			var ext:AMPExtension = new AMPExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.status );
		}

		[Test( description="XML parse - to" )]
		public function testParseTo():void
		{
			var incoming:XML = <amp xmlns='http://jabber.org/protocol/amp'
					status='notify'
					to='bernardo@hamlet.lit/elsinore'
					from='francisco@hamlet.lit'>
				 <rule action='notify' condition='deliver' value='stored'/>
			   </amp>;
			var testValue:String = "bernardo@hamlet.lit/elsinore";

			var ext:AMPExtension = new AMPExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.to.toString() );
		}

		[Test( description="XML parse - from" )]
		public function testParseFrom():void
		{
			var incoming:XML = <amp xmlns='http://jabber.org/protocol/amp'
					status='notify'
					to='bernardo@hamlet.lit/elsinore'
					from='francisco@hamlet.lit'>
				 <rule action='notify' condition='deliver' value='stored'/>
			   </amp>;
			var testValue:String = "francisco@hamlet.lit";

			var ext:AMPExtension = new AMPExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.from.toString() );
		}

		[Test( description="XML parse - perHop" )]
		public function testParsePerHop():void
		{
			var incoming:XML = <amp xmlns='http://jabber.org/protocol/amp'
					per-hop='true'>
				 <rule condition='expire-at'
					   action='drop'
					   value='2004-01-01T00:00:00Z'/>
			   </amp>;
			var testValue:Boolean = true;

			var ext:AMPExtension = new AMPExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.perHop );
		}

		[Test( description="XML parse - perHop is false" )]
		public function testParsePerHopFalse():void
		{
			var incoming:XML = <amp xmlns='http://jabber.org/protocol/amp'
					status='notify'
					to='bernardo@hamlet.lit/elsinore'
					from='francisco@hamlet.lit'>
				 <rule action='notify' condition='deliver' value='stored'/>
			   </amp>;
			var testValue:Boolean = false;

			var ext:AMPExtension = new AMPExtension();
			ext.xml = incoming;

			assertEquals( testValue, ext.perHop );
		}

	}
}
