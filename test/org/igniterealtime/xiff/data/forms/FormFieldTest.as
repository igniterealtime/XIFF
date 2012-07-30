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
package org.igniterealtime.xiff.data.forms
{
	import org.flexunit.asserts.*;

	public class FormFieldTest
	{

		[Test( description="type value" )]
		public function testValueType():void
		{
			var testValue:String = "text-single";

			var ext:FormField = new FormField();
			ext.type = testValue;

			assertEquals( testValue, ext.type );
		}
		
		[Test( description="varName value" )]
		public function testValueVarName():void
		{
			var testValue:String = "botname";

			var ext:FormField = new FormField();
			ext.varName = testValue;

			assertEquals( testValue, ext.varName );
		}
		
		[Test( description="label value" )]
		public function testValueLabel():void
		{
			var testValue:String = "The name of your bot";

			var ext:FormField = new FormField();
			ext.label = testValue;

			assertEquals( testValue, ext.label );
		}
		
		/*
		[Test( description="desc value" )]
		public function testValueDesc():void
		{
			var testValue:String = "";

			var ext:FormField = new FormField();
			ext.desc = testValue;

			assertEquals( testValue, ext.desc );
		}
		
		[Test( description="values value" )]
		public function testValueValues():void
		{
			var testValue:Array = [];

			var ext:FormField = new FormField();
			ext.values = testValue;

			assertEquals( testValue, ext.values );
		}
		
		[Test( description="options value" )]
		public function testValueOptions():void
		{
			var testValue:Array = [];

			var ext:FormField = new FormField();
			ext.options = testValue;

			assertEquals( testValue, ext.options );
		}
		*/
		[Test( description="required value" )]
		public function testValueRequired():void
		{
			var testValue:Boolean = true;

			var ext:FormField = new FormField();
			ext.required = testValue;

			assertEquals( testValue, ext.required );
		}


		[Test( description="XML element name checking" )]
		public function testElement():void
		{
			var elementName:String = "field";

			var ext:FormField = new FormField();
			var node:XML = ext.xml;

			assertEquals( elementName, node.localName() );
		}

		[Test( description="parse from XML - type" )]
		public function testParseType():void
		{
			var incoming:XML = <field type='text-single'
             label='The name of your bot'
             var='botname'/>;
			var testValue:String = "text-single";

			var ext:FormField = new FormField();
			ext.xml = incoming;

			assertEquals( testValue, ext.type );
		}

		[Test( description="parse from XML - required" )]
		public function testParseRequired():void
		{
			var incoming:XML = <field type='text-single'
					 var='search_request'>
				<required/>
			  </field>;
			var testValue:Boolean = true;

			var ext:FormField = new FormField();
			ext.xml = incoming;

			assertEquals( testValue, ext.required );
		}

		[Test( description="parse from XML - label" )]
		public function testParseLabel():void
		{
			var incoming:XML = <field type='text-single'
             label='The name of your bot'
             var='botname'/>;
			var testValue:String = "The name of your bot";

			var ext:FormField = new FormField();
			ext.xml = incoming;

			assertEquals( testValue, ext.label );
		}
		

	}
}
