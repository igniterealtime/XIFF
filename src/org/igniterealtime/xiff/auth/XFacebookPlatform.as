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
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.core.IXMPPConnection;

	/**
	 * This class provides SASL authentication using the X-FACEBOOK-PLATFORM mechanism.
	 *
	 * <p>Facebook Chat currently supports the following features, related to authentication:</p>
	 * <ul>
	 * <li>Facebook Platform authentication using the X-FACEBOOK-PLATFORM SASL authentication mechanism</li>
	 * <li>Username/password authentication using the DIGEST-MD5 authentication mechanism</li>
	 * </ul>
	 *
	 * @see http://tools.ietf.org/html/rfc3920#section-6
	 * @see https://developers.facebook.com/docs/chat/
	 */
	public class XFacebookPlatform extends SASLAuth implements ISASLAuth
	{
		public static const MECHANISM:String = "X-FACEBOOK-PLATFORM";

		public static var fb_app_id:String;
		public static var fb_access_token:String;

		/**
		 * Creates a new XFacebookPlatform authentication object.
		 *
		 * @param	connection A reference to the XMPPConnection instance in use.
		 */
		public function XFacebookPlatform( connection:IXMPPConnection )
		{
			this.connection = connection;

			req.setNamespace( SASLAuth.NS );
			req.@mechanism = XFacebookPlatform.MECHANISM;

			response.setNamespace( SASLAuth.NS );

			stage = 0;
		}

		/**
		 * Called when a challenge to this authentication is received.
		 *
		 * <p>The mechanism starts with a server challenge, in the form of a common HTTP query string:
		 * an ampersand-separated sequence of equals-sign-delimited key/value pairs.
		 * The keys and values are UTF-8-encoded and URL-encoded.
		 * The query string contains two items: method and nonce.</p>
		 *
		 * <p>The client's reply should be a similarly-encoded query string prepared as if it were
		 * going to call a method against the Facebook API. The call should contain the
		 * following parameters:</p>
		 * <ul>
		 * <li>string method: Should be the same as the method specified by the server.</li>
		 * <li>string api_key: The application key associated with the calling application.</li>
		 * <li>string access_token: The access_token obtained in the above step.</li>
		 * <li>float call_id: The request's sequence number.</li>
		 * <li>string v: This must be set to 1.0 to use this version of the API.</li>
		 * <li>string format: Optional - Ignored.</li>
		 * <li>string cnonce: Optional - Client-selected nonce. Ignored.</li>
		 * <li>string nonce: Should be the same as the nonce specified by the server.</li>
		 * </ul>
		 *
		 * <p>The server will then respond with a success or failure message.
		 * Note that this needs to be over TLS or you'll get an error.</p>
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
			var success:Boolean = response.localName() == SASLAuth.RESPONSE_SUCCESS;
			return {
				authComplete: true,
				authSuccess: success,
				authStage: stage++
			};
		}
	}
}
