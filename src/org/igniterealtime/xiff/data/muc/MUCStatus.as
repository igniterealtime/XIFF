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
package org.igniterealtime.xiff.data.muc
{
	import org.igniterealtime.xiff.data.XMLStanza;
	
	/**
	 * XEP-0306: Extensible Status Conditions for Multi-User Chat
	 *
	 * <p>Traditionally, Multi-User Chat [1] has used numerical status codes similar to
	 * those used in HTTP and SMTP. Numerical codes were deprecated in the core of
	 * XMPP by RFC 3920 [2] and are no longer even defined in the core schemas provided in
	 * RFC 6120 [3] (see also Error Condition Mappings [4]). In an effort to modernize
	 * the Multi-User Chat (MUC) protocol, this document defines an extensible
	 * format for status conditions in MUC.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0306.html
	 */
	public class MUCStatus
	{
		public static const NS:String = "http://jabber.org/protocol/muc#user"; // same with MUCUserExtension
		public static const ELEMENT_NAME:String = "status";
		
		private var _parent:XMLStanza;
		
		/**
		 * Please note that the xmlNode is not used, only the parent.
		 *
		 * @param	xmlNode
		 * @param	parentStanza
		 */
		public function MUCStatus(xmlNode:XML, parentStanza:XMLStanza)
		{
			super();
			
			var elem:XML = <{ ELEMENT_NAME }/>;
			
			_parent = parentStanza;
		}

		/**
		 * Property used to add or retrieve a status code describing the condition that occurs.
		 *
		 * @see http://xmpp.org/extensions/xep-0306.html#mapping
		 */
		public function get code():Number
		{
			return _parent.xml.status.@code as Number;
		}
		public function set code(value:Number):void
		{
			_parent.xml.status.@code = value.toString();
		}
		
		/**
		 * Property that contains some text with a description of a condition.
		 *
		 * <p> One of the following values:</p>
		 *
		 * <ul>
		 * <li>affiliation-changed</li>
		 * <li>banned</li>
		 * <li>configuration-changed</li>
		 * <li>fully-anonymous</li>
		 * <li>kicked</li>
		 * <li>logging-disabled</li>
		 * <li>logging-enabled</li>
		 * <li>new-nick</li>
		 * <li>nick-assigned</li>
		 * <li>non-anonymous</li>
		 * <li>realjid-public</li>
		 * <li>removed-affiliation</li>
		 * <li>removed-membership</li>
		 * <li>removed-shutdown</li>
		 * <li>room-created</li>
		 * <li>self-presence</li>
		 * <li>semi-anonymous</li>
		 * <li>unavailable-not-shown</li>
		 * <li>unavailable-shown</li>
		 * </ul>
		 *
		 * @see http://xmpp.org/extensions/xep-0306.html#mapping
		 */
		public function get message():String
		{
			return _parent.xml.status.toString();
		}
		public function set message(value:String):void
		{
			_parent.xml.status = value;
			if ( value == null )
			{
				delete _parent.xml.status;
			}
		}
	}
}
