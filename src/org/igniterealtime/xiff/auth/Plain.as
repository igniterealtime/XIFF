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
  import flash.utils.ByteArray;
  import flash.xml.XMLNode;

  import mx.utils.Base64Encoder;

  import org.jivesoftware.xiff.core.UnescapedJID;
  import org.jivesoftware.xiff.core.XMPPConnection;

  /**
   * This class provides SASL authentication using the PLAIN mechanism.
   * This is used for plain text password authentication with an XMPP
   * server.
   */
  public class Plain extends SASLAuth
  {
    /**
     * Creates a new Plain authentication object.
     *
     * @param connection A reference to the XMPPConnection instance in use.
     */
    public function Plain(connection:XMPPConnection)
    {
      //should probably use the escaped form, but flex/as handles \\ weirdly for unknown reasons
      var jid:UnescapedJID = connection.jid;
      var authContent:String = jid.bareJID;
      authContent += '\u0000';
      authContent += jid.node;
      authContent += '\u0000';
      authContent += connection.password;

      var b64coder:Base64Encoder = new Base64Encoder();
      b64coder.insertNewLines = false;
      b64coder.encodeUTFBytes(authContent);
      authContent = b64coder.flush();

      var attrs:Object = {
        mechanism: "PLAIN",
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
