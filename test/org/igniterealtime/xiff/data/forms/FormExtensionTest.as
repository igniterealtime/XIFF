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
	
	public class FormExtensionTest
	{
	
		
		[Test( description="title value" )]
		public function testValueTitle():void
		{
			var testValue:String = "Full of Sand";
			
			var ext:FormExtension = new FormExtension();
			ext.title = testValue;
			
			assertEquals( testValue, ext.title );
		}
		
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "jabber:x:data";
			var elementName:String = "x";
			
			var ext:FormExtension = new FormExtension();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
	
		[Test( description="parse from XML - title" )]
		public function testParseTitle():void
		{
			var incoming:XML = <x xmlns='jabber:x:data' type='form'>
			  <title>Bot Configuration</title>
			  <instructions>Fill out this form to configure your new bot!</instructions>
			  <field type='hidden'
					 var='FORM_TYPE'>
				<value>jabber:bot</value>
			  </field>
			  <field type='fixed'><value>Section 1: Bot Info</value></field>
			  <field type='text-single'
					 label='The name of your bot'
					 var='botname'/>
			  <field type='text-multi'
					 label='Helpful description of your bot'
					 var='description'/>
			  <field type='boolean'
					 label='Public bot?'
					 var='public'>
				<required/>
			  </field>
			  <field type='text-private'
					 label='Password for special access'
					 var='password'/>
			  <field type='fixed'><value>Section 2: Features</value></field>
			  <field type='list-multi'
					 label='What features will the bot support?'
					 var='features'>
				<option label='Contests'><value>contests</value></option>
				<option label='News'><value>news</value></option>
				<option label='Polls'><value>polls</value></option>
				<option label='Reminders'><value>reminders</value></option>
				<option label='Search'><value>search</value></option>
				<value>news</value>
				<value>search</value>
			  </field>
			  <field type='fixed'><value>Section 3: Subscriber List</value></field>
			  <field type='list-single'
					 label='Maximum number of subscribers'
					 var='maxsubs'>
				<value>20</value>
				<option label='10'><value>10</value></option>
				<option label='20'><value>20</value></option>
				<option label='30'><value>30</value></option>
				<option label='50'><value>50</value></option>
				<option label='100'><value>100</value></option>
				<option label='None'><value>none</value></option>
			  </field>
			  <field type='fixed'><value>Section 4: Invitations</value></field>
			  <field type='jid-multi'
					 label='People to invite'
					 var='invitelist'>
				<desc>Tell all your friends about your new bot!</desc>
			  </field>
			</x>;
			var testValue:String = "Bot Configuration";
			
			var ext:FormExtension = new FormExtension();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.title );
		}
		
	}
}
