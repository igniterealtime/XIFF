/*
 * License
 */
package org.igniterealtime.xiff.data.vcard
{
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	
	public class VCardExtension extends Extension implements IExtension, ISerializable {
		
		public function getNS():String{
			return "vcard-temp";
		}
		
		public function getElementName():String 
		{
			return "vCard";
		}
		
		/**
		 * Called when the library need to retrieve the state of the instance.  If the instance manages its own state, then the state should be copied into the XMLNode passed.  If the instance also implements INodeProxy, then the parent should be verified against the parent XMLNode passed to determine if the serialization is in the same namespace.
		 *
		 * @param	parentNode (XMLNode) The container of the XML.
		 * @return	On success, return true.
		 */
		public function serialize( parentNode:XMLNode ):Boolean 
		{
			parentNode.appendChild(getNode());			
			return true;
		}
	
		/**
		 * Called when data is retrieved from the XMLSocket, use this method to extract any state into internal state.
		 * @param	node (XMLNode) The node that should be used as the data container.
		 * @return	On success, return true.
		 */
		public function deserialize( node:XMLNode ):Boolean 
		{
			return true;
		}
		
		
		
	}
}