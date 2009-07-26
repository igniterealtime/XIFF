/*
 * License
 */
package org.igniterealtime.xiff.data.id
{	
	/**
	 * To use custom ID generators call the static function on the
	 * XMPPStanza class with an instance that implements IIDGenerator.
	 * 
	 * @example	<code>XMPPStanza.setIDGenerator( 
	 * 	new org.igniterealtime.xiff.data.id.SharedObjectGenerator() );</code>
	 */
	public interface IIDGenerator
	{
		/**
		 * Gets the generated ID.
		 *
		 * @param	prefix The prefix to use for the ID (for namespacing purposes)
		 * @return The generated ID
		 */
		function getID(prefix:String):String;
	}
}