/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
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
package org.igniterealtime.xiff.data.muc
{
	import org.igniterealtime.xiff.data.XMLStanza;

	/**
	 * Status codes of the Multi User Chat.
	 * @see http://xmpp.org/extensions/xep-0045.html#errorstatus
	 */
	public class MUCStatus
	{
		private var node:XML;

		private var parent:XMLStanza

		public function MUCStatus( xmlNode:XML, parentStanza:XMLStanza )
		{
			super();
			node = xmlNode ? xmlNode : <status/>;
			parent = parentStanza;
		}

		/**
		 * Property used to add or retrieve a status code describing the condition that occurs.
		 * @see http://xmpp.org/extensions/xep-0045.html#registrar-statuscodes
		 */
		public function get code():int
		{
			return parseInt( node.@code.toString() );
		}

		public function set code( value:int ):void
		{
			node.@code = value.toString();
		}

		/**
		 * Property that contains some text with a description of a condition.
		 */
		public function get message():String
		{
			return node.text();
		}
		public function set message( value:String ):void
		{
			node.setChildren( value );
		}
	}
}
