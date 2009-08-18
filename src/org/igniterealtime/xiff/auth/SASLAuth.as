/*
 * License
 */
package org.igniterealtime.xiff.auth
{
	import flash.xml.XMLNode;

	/**
	 * This is a base class for use with Simple Authentication and Security Layer
	 * (SASL) mechanisms. Sub-class this class when creating new SASL mechanisms.
	 * @see http://tools.ietf.org/html/rfc4422
	 * @see http://en.wikipedia.org/wiki/Simple_Authentication_and_Security_Layer
	 */
	public class SASLAuth
	{

		/**
		 * The XML of the authentication request.
		 */
		protected var req:XMLNode;

		/**
		 * The current response stage.
		 */
		protected var stage:int;
		
		public function SASLAuth()
		{
			throw new Error( "Don't call directly SASLAuth; use a subclass" );
		}

		/**
		 * Called when a response to this authentication is received.
		 *
		 * @param	stage The current stage in the authentication process.
		 * @param	response The XML of the actual authentication response.
		 *
		 * @return An object specifying the current state of the authentication.
		 */
		public function handleResponse( stage:int, response:XMLNode ):Object
		{
			throw new Error( "Don't call this method on SASLAuth; use a subclass" );
		}

		/**
		 * The XML for the authentication request.
		 */
		public function get request():XMLNode
		{
			return req;
		}
	}
}
