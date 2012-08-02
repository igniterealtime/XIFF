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
package org.igniterealtime.xiff.data.session
{

    import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	
	/**
	 * Session Establishment
	 *
	 * <p>Most instant messaging and presence applications based on XMPP are
	 * implemented via a client-server architecture that requires a client
	 * to establish a session on a server in order to engage in the expected
	 * instant messaging and presence activities.  However, there are
	 * several pre-conditions that MUST be met before a client can establish
     * an instant messaging and presence session.</p>
	 *
	 * @see http://tools.ietf.org/html/rfc3921#section-3
	 */
	public class SessionExtension extends Extension implements IExtension
	{
		public static const NS:String = "urn:ietf:params:xml:ns:xmpp-session";
		public static const ELEMENT_NAME:String = "session";
		
		/**
		 * Session Establishment as defined in RFC 3921
		 *
		 * @param	parent
		 * @see org.igniterealtime.xiff.core.XMPPConnection#establishSession
		 */
		public function SessionExtension( parent:XML = null )
		{
			super(parent);
		}
		
		public function getNS():String
		{
			return SessionExtension.NS;
		}
		
		public function getElementName():String
		{
			return SessionExtension.ELEMENT_NAME;
                }
		
		
	}
}
