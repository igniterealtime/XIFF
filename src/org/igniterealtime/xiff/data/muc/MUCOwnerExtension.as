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
	
	
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.IExtension;
	
	/**
	 * Implements the administration command data model in <a href="http://xmpp.org/extensions/xep-0045.html">XEP-0045</a> for multi-user chat.
	 *
	 * @see http://xmpp.org/extensions/xep-0045.html
	 */
	public class MUCOwnerExtension extends MUCBaseExtension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/muc#owner";
		public static const ELEMENT_NAME:String = "query";
		
		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function MUCOwnerExtension( parent:XML = null )
		{
			super(parent);
		}
	
		public function getNS():String
		{
			return MUCOwnerExtension.NS;
		}
	
		public function getElementName():String
		{
			return MUCOwnerExtension.ELEMENT_NAME;
		}

	
	    /**
	     * Replaces the <code>destroy</code> node with a new node and sets
	     * the <code>reason</code> element and <code>jid</code> attribute
	     *
	     * @param	reason A string describing the reason for room destruction. Use <code>null</code> to remove.
	     * @param	alternateJID A string containing a JID that room members can use instead of this room
	     */
	    public function destroy(reason:String, alternateJID:EscapedJID = null):void
	    {
			xml.destroy = ""; // Reset the whole element
			xml.destroy.reason = reason;
			if (reason == null)
			{
				delete xml.destroy.reason;
			}
			
	        if ( alternateJID != null )
			{
				xml.destroy.@jid = alternateJID.toString();
			}
	    }
	}
}
