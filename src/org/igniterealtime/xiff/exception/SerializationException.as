/*
 * License
 */
package org.igniterealtime.xiff.exception
{	
	/**
	 * This exception is thrown whenever there is a problem serializing or 
	 * deserializing data for sending to the server.
	 */
	public class SerializationException extends Error
	{
		private static var MSG:String = "Could not properly serialize/deserialize stanza."
		
		public function SerializationException()
		{
			super( MSG );
		}
	}
	
}