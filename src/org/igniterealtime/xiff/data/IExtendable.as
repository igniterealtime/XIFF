/*
 * License
 */
package org.igniterealtime.xiff.data
{
	import org.igniterealtime.xiff.data.IExtension;
	
	/**
	 * This interface provides access to contained extensions and methods to modify the contained extensions.  
	 * All XMPP stanzas that can be extended should implement this interface.
	 *
	 * @see	org.igniterealtime.xiff.data.ExtensionContainer
	 * @see	org.igniterealtime.xiff.data.IExtension
	 */
	public interface IExtendable
	{
		function addExtension( extension:IExtension ):IExtension;
		function getAllExtensionsByNS( ns:String ):Array;
		function getAllExtensions():Array;
		function removeExtension( extension:IExtension ):Boolean;
		function removeAllExtensions( ns:String ):void;
	}
}