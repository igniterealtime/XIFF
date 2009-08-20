/*
 * License
 */
package org.igniterealtime.xiff.data.muc
{
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.data.XMLStanza;
	
	public class MUCStatus
	{
		private var node:XMLNode;
		private var parent:XMLStanza
		public function MUCStatus(xmlNode:XMLNode, parentStanza:XMLStanza)
		{
			super();
			node = xmlNode ? xmlNode : new XMLNode(1, "status");
			parent = parentStanza;
		}

		/**
		 * Property used to add or retrieve a status code describing the condition that occurs.
		 */
		public function get code():Number
		{
			return node.attributes.code;
		}
		
		public function set code(value:Number):void
		{
			node.attributes.code = value.toString();
		}
		
		/**
		 * Property that contains some text with a description of a condition.
		 */
		public function get message():String
		{
			if(node.firstChild)
				return node.firstChild.nodeValue;
			
			return null;
		}
	
		public function set message(value:String):void
		{
			node = parent.replaceTextNode(parent.getNode(), node, "status", value);
		}
	}
}
