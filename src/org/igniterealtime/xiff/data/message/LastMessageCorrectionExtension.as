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
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * XEP-0308: Last Message Correction (version 0.1, 2011-11-10)
	 *
	 * <p>When a user indicates to the client that he wants to correct 
	 * the most recently sent message to a contact, the client will resend
	 * the corrected message with a new id, and with the replace payload 
	 * refering to the previous message by id.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0308.html
	 */
	public class LastMessageCorrectionExtension extends Extension implements IExtension
	{
		public static const NS:String = "urn:xmpp:message-correct:0";
		public static const ELEMENT_NAME:String = "replace";

		/**
		 * A receiving client can choose to replace the previous message in 
		 * whatever display is used for messages, or in any stored history,  
		 * or can choose to display the correction in another way. 
		 *  
		 * <p>A client SHOULD alert the user that the displayed message has  
		 * been edited since it was originally sent.</p> 
		 *  
		 * <p>Clients MUST send ids on messages if they allow the user to  
		 * correct messages.</p> 
		 *  
		 * <p>To deal with multiple payloads, the sender MUST re-send the  
		 * entire stanza with only the id and the corrections changed. It is  
		 * expected that the receiver will then treat the new stanza as  
		 * complete replacement, but such logic is ultimately the resposibility  
		 * of the client.</p> 
		 *  
		 * <p>The Sender MUST NOT include a correction for a message with  
		 * non-messaging payloads. For example, a sender MUST NOT include  
		 * a correction for a roster item exchange request.</p> 
		 * 
		 * @param	parent
		 */
		public function LastMessageCorrectionExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return LastMessageCorrectionExtension.NS;
		}

		public function getElementName():String
		{
			return LastMessageCorrectionExtension.ELEMENT_NAME;
		}

		/**
		 * The 'id' attribute is included on the replace to prevent situations
		 * where messages being routed to a different resource than the 
		 * intended cause incorrect replacements.
		 */
		public function get id():String
		{
			return getAttribute("id");
		}
		public function set id( value:String ):void
		{
			setAttribute("id", value);
		}

		
	}
}
