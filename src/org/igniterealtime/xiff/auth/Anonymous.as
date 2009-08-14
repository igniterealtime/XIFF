/*
 * License
 */
package org.igniterealtime.xiff.auth
{
	import flash.xml.XMLNode;

	import org.igniterealtime.xiff.core.XMPPConnection;

	/**
	 * This class provides SASL authentication using the ANONYMOUS mechanism.
	 * @see http://xmpp.org/extensions/xep-0175.html
	 * @see http://tools.ietf.org/html/rfc4505
	 */
	public class Anonymous extends SASLAuth
	{
		private const MECHANISM:String = "ANONYMOUS";

		private const NS:String = "urn:ietf:params:xml:ns:xmpp-sasl";

		/**
		 * Creates a new Anonymous authentication object.
		 *
		 * @param	connection A reference to the XMPPConnection instance to use.
		 */
		public function Anonymous( connection:XMPPConnection )
		{
			req = new XMLNode( 1, "auth" );
			req.attributes = { mechanism: MECHANISM, xmlns: NS };

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
		override public function handleResponse( stage:int, response:XMLNode ):Object
		{
			var success:Boolean = response.nodeName == "success";
			return { authComplete: true, authSuccess: success, authStage: stage++ };
		}
	}
}
