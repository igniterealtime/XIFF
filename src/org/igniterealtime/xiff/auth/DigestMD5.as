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
package org.igniterealtime.xiff.auth
{
	
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Base64

	import org.igniterealtime.xiff.core.XMPPConnection;

	/**
	 * TODO
	 * This class provides SASL authentication using the DIGEST-MD5 mechanism, a HTTP Digest
	 * compatible challenge-response scheme based upon MD5. DIGEST-MD5 offers a data security layer.
	 * @see http://en.wikipedia.org/wiki/Digest_access_authentication
	 * @see http://tools.ietf.org/html/rfc1321
	 */
	public class DigestMD5 extends SASLAuth
	{
		private const MECHANISM:String = "DIGEST-MD5";
		private const NS:String = "urn:ietf:params:xml:ns:xmpp-sasl";

		/**
		* Creates a new External authentication object.
		*
		* @param	connection A reference to the XMPPConnection instance in use.
		*/
		public function DigestMD5( connection:XMPPConnection )
		{
			var authContent:String = Base64.encode(connection.jid.node);
			
			req.setNamespace( Plain.NS );
			req.@mechanism = Plain.MECHANISM;
			req.setChildren( authContent );

			stage = 0;
		}

		/**
		* Called when a response to this authentication is received.
		*
		* @param	stage The current stage in the authentication process.
		* @param	response The XML of the actual authentication response.
		*
		* @return An object specifying the current state of the authentication.
		*/
		override public function handleResponse( stage:int, response:XML ):Object
		{
			var success:Boolean = response.nodeName == "success";
			return {
				authComplete: true,
				authSuccess: success,
				authStage: stage++
			};
		}
	}
}
