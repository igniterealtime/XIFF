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

  import mx.utils.Base64Encoder;

  import org.jivesoftware.xiff.core.UnescapedJID;
  import org.jivesoftware.xiff.core.XMPPConnection;

  /**
   * This class provides SASL authentication using the EXTERNAL mechanism.
   * This is particularly useful when TLS authentication is required.
   */
  public class External extends SASLAuth
  {
    /**
     * Creates a new External authentication object.
     *
     * @param connection A reference to the XMPPConnection instance in use.
     */
    public function External(connection:XMPPConnection)
    {
      var jid:UnescapedJID = connection.jid;
      var authContent:String = jid.node;

      var b64coder:Base64Encoder = new Base64Encoder();
      b64coder.insertNewLines = false;
      b64coder.encode(authContent);
      authContent = b64coder.flush();

      var attrs:Object = {
        mechanism: "EXTERNAL",
        xmlns: "urn:ietf:params:xml:ns:xmpp-sasl"
      };

      req = new XMLNode(1, "auth");
      req.appendChild(new XMLNode(3, authContent));
      req.attributes = attrs;

      stage = 0;
    }

    /**
     * Called when a response to this authentication is received.
     * 
     * @param stage The current stage in the authentication process.
     * @param response The XML of the actual authentication response.
     *
     * @return An object specifying the current state of the authentication.
     */
    public override function handleResponse(stage:int, response:XMLNode):Object 
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
