/*
 * License
 */
package org.igniterealtime.xiff.auth
{
	import flash.xml.XMLNode;

	import mx.utils.Base64Encoder;
	
	import org.igniterealtime.xiff.core.XMPPConnection;
	
	/**
	 * This class provides SASL authentication using the EXTERNAL mechanism.
	 * This is particularly useful when TLS authentication is required.
	 * @see http://xmpp.org/extensions/xep-0178.html
	 */
	public class External extends SASLAuth
	{
		private const MECHANISM:String = "EXTERNAL";

		private const NS:String = "urn:ietf:params:xml:ns:xmpp-sasl";

		/**
		 * Creates a new External authentication object.
		 *
		 * @param	connection A reference to the XMPPConnection instance in use.
		 */
		public function External( connection:XMPPConnection )
		{
			var authContent:String = connection.jid.node;

			//authContent = com.hurlant.util.Base64.encode(authContent);

			var b64coder:Base64Encoder = new Base64Encoder();
			b64coder.insertNewLines = false;
			b64coder.encode( authContent );
			authContent = b64coder.flush();

			req = new XMLNode( 1, "auth" );
			req.appendChild( new XMLNode( 3, authContent ));
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
		override public  function handleResponse( stage:int, response:XMLNode ):Object
		{
			var success:Boolean = response.nodeName == "success";
			return { authComplete: true, authSuccess: success, authStage: stage++ };
		}
	}
}
