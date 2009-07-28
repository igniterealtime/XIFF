/*
 * License
 */
package org.igniterealtime.xiff.data.disco
{

	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ISerializable;
	
	/**
	 * Base class for service discovery extensions.
	 * @see http://xmpp.org/protocols/disco/
	 */
	public class DiscoExtension extends Extension implements ISerializable
	{
		// Static class variables to be overridden in subclasses;
		public static const NS:String = "http://jabber.org/protocol/disco";
		public static const ELEMENT:String = "query";
		
		public var myService:EscapedJID;
	
		/**
		 * The name of the resource of the service queried if the resource
		 * doesn't have a JID. For more information, see
		 * <a href="http://www.jabber.org/registrar/disco-nodes.html">
		 * http://www.jabber.org/registrar/disco-nodes.html</a>.
		 */
		public function DiscoExtension(xmlNode:XMLNode)
		{
			super(xmlNode);
		}
		
		public function get serviceNode():String
		{
			return getNode().parentNode.attributes.node;
		}
	
		/**
		 * @private
		 */
		public function set serviceNode(val:String):void
		{
			getNode().parentNode.attributes.node = val;
		}
	
		/**
		 * The service name of the discovery procedure
		 */
		public function get service():EscapedJID
		{
			var parent:XMLNode = getNode().parentNode;
	
			if (parent.attributes.type == "result") {
				return new EscapedJID(parent.attributes.from);
			} else {
				return new EscapedJID(parent.attributes.to);
			}
		}
		
		/**
		 * @private
		 */
		public function set service(val:EscapedJID):void
		{
			var parent:XMLNode = getNode().parentNode;
	
			if (parent.attributes.type == "result") {
				parent.attributes.from = val.toString();
			} else {
				parent.attributes.to = val.toString();
			}
		}
	
		public function serialize(parentNode:XMLNode):Boolean
		{
			if (parentNode != getNode().parentNode) {
				parentNode.appendChild(getNode().cloneNode(true));
			}
			return true;
		}
	
		public function deserialize(node:XMLNode):Boolean
		{
			setNode(node);
			return true;
		}
	}
}
