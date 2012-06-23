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
package org.igniterealtime.xiff.auth
{
	import org.flexunit.asserts.assertEquals;
	import org.igniterealtime.xiff.core.XMPPConnection;

	/**
	 * @see http://docs.flexunit.org/index.php?title=Tests_and_Test_Cases
	 */
	public class AnonymousTest
	{
		private var _connection:XMPPConnection;
	
		[Before]
		public function setup():void
		{
			_connection = new XMPPConnection();
		}
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "urn:ietf:params:xml:ns:xmpp-sasl";
			var mechanism:String = "ANONYMOUS";
			var elementName:String = "auth";
			
			var auth:Anonymous = new Anonymous(_connection);
			var request:XML = auth.request;
			var ns:Namespace = request.namespace();
			
			assertEquals( nameSpace, ns.uri );
			assertEquals( elementName, request.localName() );
			assertEquals( mechanism, request.@mechanism );
		}
	}
}
