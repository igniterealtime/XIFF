/*
 * License
 */
package org.igniterealtime.xiff.data.sharedgroups
{
	import flash.xml.XMLNode;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * Similar idea to XEP-0140 (http://xmpp.org/extensions/xep-0140.html) which was
	 * retracted in favor of XEP-0144 (http://xmpp.org/extensions/xep-0144.html).
	 */
	public class SharedGroupsExtension implements IExtension, ISerializable
	{
		public function getNS():String
		{
			return "http://www.jivesoftware.org/protocol/sharedgroup";
		}
		
		public function getElementName():String
		{
			return "sharedgroup";
		}

		public function serialize(parentNode:XMLNode):Boolean
		{
			var xmlNode:XMLNode = new XMLNode(1, getElementName() + " xmlns='" + getNS() + "'");
			parentNode.appendChild(xmlNode);
			return true;
		}
		
		public function deserialize(node:XMLNode):Boolean
		{
			return true;
		}
		
	}
}
