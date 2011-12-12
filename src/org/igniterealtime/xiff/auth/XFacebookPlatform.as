/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
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
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.core.XMPPConnection;

	/**
	 * This class provides SASL authentication using the X-FACEBOOK-PLATFORM mechanism.
	 */
	public class XFacebookPlatform extends SASLAuth
	{
		public static const MECHANISM:String = "X-FACEBOOK-PLATFORM";

		public static const NS:String = "urn:ietf:params:xml:ns:xmpp-sasl";

		public static var fb_app_id:String;
		public static var fb_access_token:String;

		/**
		 * Creates a new XFacebookPlatform authentication object.
		 *
		 * @param	connection A reference to the XMPPConnection instance in use.
		 */
		public function XFacebookPlatform( connection:XMPPConnection )
		{
			req.setNamespace( XFacebookPlatform.NS );
			req.@mechanism = XFacebookPlatform.MECHANISM;

			response.setNamespace( XFacebookPlatform.NS );

			stage = 0;
		}

		/**
		 * Called when a challenge to this authentication is received.
		 *
		 * @param	stage The current stage in the authentication process.
		 * @param	challenge The XML of the actual authentication challenge.
		 *
		 * @return The XML response to the challenge.
		 */
		override public function handleChallenge( stage:int, challenge:XML ):XML
		{
			var decodedChallenge:String = Base64.decode( challenge );
			var challengeKeyValuePairs:Array = decodedChallenge.split( "&" );
			var challengeMap:Dictionary = new Dictionary();
			for each( var keyValuePair:String in challengeKeyValuePairs )
			{
				var keyValue:Array = keyValuePair.split( "=" );
				challengeMap[ keyValue[ 0 ] ] = keyValue[ 1 ];
			}

			var responseMap:Dictionary = new Dictionary();
			responseMap.method = challengeMap.method;
			responseMap.api_key = fb_app_id;
			responseMap.access_token = fb_access_token;
			responseMap.call_id = new Date().time;
			responseMap.v = "1.0";
			responseMap.nonce = challengeMap.nonce;

			var challengeResponse:String = "method=" + responseMap.method;
			challengeResponse += "&api_key=" + responseMap.api_key;
			challengeResponse += "&access_token=" + responseMap.access_token;
			challengeResponse += "&call_id=" + responseMap.call_id;
			challengeResponse += "&v=" + responseMap.v;
			challengeResponse += "&nonce=" + responseMap.nonce;
			challengeResponse = Base64.encode( challengeResponse );

			var resp:XML = response;
			resp.setChildren( challengeResponse );
			return resp;
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
			var success:Boolean = response.localName() == "success";
			return {
				authComplete: true,
				authSuccess: success,
				authStage: stage++
			};
		}
	}
}
