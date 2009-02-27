/*
 * Copyright 2003-2009
 * Sean Voisen <sean@voisen.org>
 * Sean Treadway <seant@oncotype.dk>
 * Nick Velloff <nick.velloff@gmail.com>
 * Derrick Grigg <dgrigg@rogers.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at 
 *
 *   http://www.apache.org/licenses/LICENSE-2.0 
 * 
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and 
 * limitations under the License. 
 */

package org.jivesoftware.xiff.auth
{
	import flash.xml.XMLNode;
	
  /**
   * This is a base class for use with Simple Authentication and Security Layer
   * (SASL) mechanisms. Sub-class this class when creating new SASL mechanisms.
   */
	public class SASLAuth
	{
    /**
     * The current response stage.
     */
		protected var stage:int;

    /**
     * The XML of the authentication request.
     */
		protected var req:XMLNode;
		
    /**
     * The XML for the authentication request.
     */
		public function get request():XMLNode
		{
			return req;
		}

    /**
     * Called when a response to this authentication is received.
     * 
     * @param stage The current stage in the authentication process.
     * @param response The XML of the actual authentication response.
     *
     * @return An object specifying the current state of the authentication.
     */
    public function handleResponse(stage:int, response:XMLNode):Object
		{
			throw new Error("Don't call this method on SASLAuth; use a subclass");
		}
	}
}
