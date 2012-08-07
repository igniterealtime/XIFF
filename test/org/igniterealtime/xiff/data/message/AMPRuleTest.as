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

	public class AMPRuleTest
	{

		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "rule";

			var ext:AMPRule = new AMPRule();
			var node:XML = ext.xml;

			assertEquals( elementName, node.localName() );
		}

		[Test( description="XML parse - action" )]
		public function testParseAction():void
		{
			var incoming:XML = <rule action='notify' condition='deliver' value='stored'/>;
			var testValue:String = "notify";

			var ext:AMPRule = new AMPRule();
			ext.xml = incoming;

			assertEquals( testValue, ext.action );
		}

		[Test( description="XML parse - condition" )]
		public function testParseCondition():void
		{
			var incoming:XML = <rule action='notify' condition='deliver' value='stored'/>;
			var testValue:String = "deliver";

			var ext:AMPRule = new AMPRule();
			ext.xml = incoming;

			assertEquals( testValue, ext.condition );
		}


		[Test( description="XML parse - value" )]
		public function testParseValue():void
		{
			var incoming:XML = <rule action='notify' condition='deliver' value='stored'/>;
			var testValue:String = "stored";

			var ext:AMPRule = new AMPRule();
			ext.xml = incoming;

			assertEquals( testValue, ext.value );
		}



	}
}
