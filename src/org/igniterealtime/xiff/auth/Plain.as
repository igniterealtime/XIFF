/*
 * License
 */
package org.igniterealtime.xiff.auth
{
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;

	import mx.utils.Base64Encoder;
	
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.core.XMPPConnection;

	/**
	 * This class provides SASL authentication using the PLAIN mechanism.
	 * This is used for plain text password authentication with an XMPP
	 * server.
	 * @see http://tools.ietf.org/html/rfc4616
	 */
	public class Plain extends SASLAuth
	{
		private const MECHANISM:String = "PLAIN";

		private const NS:String = "urn:ietf:params:xml:ns:xmpp-sasl";

		/**
		 * Creates a new Plain authentication object.
		 *
		 * @param	connection A reference to the XMPPConnection instance in use.
		 */
		public function Plain( connection:XMPPConnection )
		{
			//should probably use the escaped form, but flex/as handles \\ weirdly for unknown reasons
			var jid:UnescapedJID = connection.jid;
			var authContent:String = jid.bareJID;
			authContent += '\u0000';
			authContent += jid.node;
			authContent += '\u0000';
			authContent += connection.password;

			//authContent = com.hurlant.util.Base64.encode(authContent);

			var b64coder:Base64Encoder = new Base64Encoder();
			b64coder.insertNewLines = false;
			b64coder.encodeUTFBytes( authContent );
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
		override public function handleResponse( stage:int, response:XMLNode ):Object
		{
			var success:Boolean = response.nodeName == "success";
			return { authComplete: true, authSuccess: success, authStage: stage++ };
		}
	}
}
