/*
 * License
 */
package org.igniterealtime.xiff.data
{

	
	/**
	 * All XMPP stanzas that will interact with the library should implement this interface.
	 */
	import flash.xml.XMLNode;

	public interface ISerializable
	{
		/**
		 * Called when the library need to retrieve the state of the instance.  If the instance manages its own state, then the state should be copied into the XMLNode passed.  If the instance also implements INodeProxy, then the parent should be verified against the parent XMLNode passed to determine if the serialization is in the same namespace.
		 *
		 * @param	parentNode (XMLNode) The container of the XML.
		 * @return	On success, return true.
		 */
		function serialize( parentNode:XMLNode ):Boolean;
	
		/**
		 * Called when data is retrieved from the XMLSocket, use this method to extract any state into internal state.
		 * @param	node (XMLNode) The node that should be used as the data container.
		 * @return	On success, return true.
		 */
		function deserialize( node:XMLNode ):Boolean;
		
	}
}