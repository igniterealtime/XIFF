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
package org.igniterealtime.xiff.data.pubsub
{
	import org.flexunit.asserts.*;
	
	public class UserLocationExtensionTest
	{
		
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "http://jabber.org/protocol/geoloc";
			var elementName:String = "geoloc";
			
			var ext:UserLocationExtension = new UserLocationExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
		
		
		[Test( description="Parse XML - accuracy" )]
		public function testParseAccuracy():void
		{
			var incoming:XML = <geoloc xmlns='http://jabber.org/protocol/geoloc' xml:lang='en'>
		      <accuracy>20</accuracy>
		      <country>Italy</country>
		      <lat>45.44</lat>
		      <locality>Venice</locality>
		      <lon>12.33</lon>
		    </geoloc>;
			var testValue:Number = 20;
			
			var ext:UserLocationExtension = new UserLocationExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.accuracy );
		}
		
		
		[Test( description="Parse XML - country" )]
		public function testParseCountry():void
		{
			var incoming:XML = <geoloc xmlns='http://jabber.org/protocol/geoloc' xml:lang='en'>
		      <accuracy>20</accuracy>
		      <country>Italy</country>
		      <lat>45.44</lat>
		      <locality>Venice</locality>
		      <lon>12.33</lon>
		    </geoloc>;
			var testValue:String = "Italy";
			
			var ext:UserLocationExtension = new UserLocationExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.country );
		}
		

		
		

	}
}
