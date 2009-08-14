/*
 * License
 */
package org.igniterealtime.xiff.data.ping
{
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import flash.xml.XMLNode;
	
	/**
	 * @see http://xmpp.org/extensions/xep-0199.html
	 */
	public class PingExtension implements IExtension, ISerializable
	{
		public static const ELEMENT_NAME:String = "ping";
		
		public static const NS:String = "urn:xmpp:ping";
		
		public function getNS():String
		{
			return PingExtension.NS;
		}
		
		public function getElementName():String
		{
			return PingExtension.ELEMENT_NAME;
		}
		
		public static function enable():Boolean
	    {
	        return ExtensionClassRegistry.register(PingExtension);
	    }
		
		/**
		 *
		 * @param	parentNode (XMLNode) The container of the XML.
		 * @return	On success, return true.
		 */
		public function serialize( parentNode:XMLNode ):Boolean
		{
			var xmlNode:XMLNode = new XMLNode(1, PingExtension.ELEMENT_NAME);
			xmlNode.attributes.xmlns = PingExtension.NS;
			parentNode.appendChild(xmlNode);
			return true;
		}
	
		/**
		 * @param	node (XMLNode) The node that should be used as the data container.
		 * @return	On success, return true.
		 */
		public function deserialize( node:XMLNode ):Boolean
		{
			return true;
		}
	}
}
