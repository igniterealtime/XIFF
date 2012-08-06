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
package org.igniterealtime.xiff.auth
{
	import com.hurlant.util.Base64;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.core.IXMPPConnection;

	/**
	 * This class provides SASL authentication using the PLAIN mechanism.
	 * This is used for plain text (base64 encoded) password authentication with an XMPP
	 * server.
	 *
	 * @see http://tools.ietf.org/html/rfc4616
	 * @see http://tools.ietf.org/html/rfc3920#section-6
	 */
	public class Plain extends SASLAuth implements ISASLAuth
	{
		public static const MECHANISM:String = "PLAIN";

		/**
		 * Creates a new Plain authentication object.
		 */
		public function Plain( connection:IXMPPConnection )
		{
			this.connection = connection;

			//should probably use the escaped form, but flex/as handles \\ weirdly for unknown reasons
			var jid:UnescapedJID = connection.jid;
			var authContent:String = jid.bareJID;
			authContent += '\u0000';
			authContent += jid.node;
			authContent += '\u0000';
			authContent += connection.password;

			authContent = Base64.encode(authContent);

			req.setNamespace( SASLAuth.NS );
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
			var success:Boolean = response.localName() == SASLAuth.RESPONSE_SUCCESS;
			return {
				authComplete: true,
				authSuccess: success,
				authStage: stage++
			};
		}
	}
}
