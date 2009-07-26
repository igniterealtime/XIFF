/*
 * License
 */
package org.igniterealtime.xiff.data.muc
{
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;
	
	/**
	 * This class is used by the MUCExtension for internal representation of
	 * information pertaining to occupants in a multi-user conference room.
	 */
	public class MUCItem extends XMLStanza implements ISerializable
	{
		public static const ELEMENT:String = "item";
	
		private var myActorNode:XMLNode;
		private var myReasonNode:XMLNode;
	
		public function MUCItem(parent:XMLNode=null)
		{
			super();
	
			getNode().nodeName = ELEMENT;
	
			if (exists(parent)) {
				parent.appendChild(getNode());
			}
		}
	
		public function serialize(parent:XMLNode):Boolean
		{
			if (parent != getNode().parentNode) {
				parent.appendChild(getNode().cloneNode(true));
			}
	
			return true;
		}
	
		public function deserialize(node:XMLNode):Boolean
		{
			setNode(node);
	
			var children:Array = node.childNodes;
			for( var i:String in children ) {
				switch( children[i].nodeName )
				{
					case "actor":
						myActorNode = children[i];
						break;
						
					case "reason":
						myReasonNode = children[i];
						break;
				}
			}
			return true;
		}
	
		public function get actor():EscapedJID
		{
			return new EscapedJID(myActorNode.attributes.jid);
		}
	
		public function set actor(val:EscapedJID):void
		{
			myActorNode = ensureNode(myActorNode, "actor");
			myActorNode.attributes.jid = val.toString();
		}
	
		public function get reason():String
		{
			if(myReasonNode && myReasonNode.firstChild)
				return myReasonNode.firstChild.nodeValue;
			
			return null;
		}
	
		public function set reason(val:String):void
		{
			myReasonNode = replaceTextNode(getNode(), myReasonNode, "reason", val);
		}
	
		public function get affiliation():String
		{
			return getNode().attributes.affiliation;
		}
	
		public function set affiliation(val:String):void
		{
			getNode().attributes.affiliation = val;
		}
	
		public function get jid():EscapedJID
		{
			if(getNode().attributes.jid == null)
				return null;
			return new EscapedJID(getNode().attributes.jid);
		}
	
		public function set jid(val:EscapedJID):void
		{
			getNode().attributes.jid = val.toString();
		}
	
		/**
		 * The nickname of the conference occupant.
		 *
		 */
		public function get nick():String
		{
			return getNode().attributes.nick;
		}
	
		public function set nick(val:String):void
		{
			getNode().attributes.nick = val;
		}
	
		public function get role():String
		{
			return getNode().attributes.role;
		}
	
		public function set role(val:String):void
		{
			getNode().attributes.role = val;
		}
	}
}
