/*
 * License
 */
package org.igniterealtime.xiff.auth
{
  import flash.xml.XMLNode;

  import org.igniterealtime.xiff.core.XMPPConnection;

  /**
   * This class provides SASL authentication using the ANONYMOUS mechanism.
   */
  public class Anonymous extends SASLAuth
  {
    /**
     * Creates a new Anonymous authentication object.
     *
     * @param	connection A reference to the XMPPConnection instance to use.
     */
    public function Anonymous(connection:XMPPConnection)
    {
      var attrs:Object = {
        mechanism: "ANONYMOUS",
        xmlns: "urn:ietf:params:xml:ns:xmpp-sasl"
      };

      req = new XMLNode(1, "auth");
      req.attributes = attrs;

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
