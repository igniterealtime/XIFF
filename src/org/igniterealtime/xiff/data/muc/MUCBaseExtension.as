/*
 * License
 */
package org.igniterealtime.xiff.data.muc{

	
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtendable;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	
	/**
	 * Implements the base functionality shared by all MUC extensions
	 *
	 * @see http://xmpp.org/extensions/xep-0045.html
	 * @param	parent (Optional) The containing XMLNode for this extension
	 */
	public class MUCBaseExtension extends Extension implements IExtendable, ISerializable
	{
		private var myItems:Array = [];
	
		public function MUCBaseExtension( parent:XMLNode=null )
		{
			super(parent);
		}

		/**
		 * Called when this extension is being put back on the network.  Perform any further serialization for Extensions and items
		 */
		public function serialize( parent:XMLNode ):Boolean
		{
			var node:XMLNode = getNode();
	
			for each(var i:* in myItems) {
				if (!i.serialize(node)) {
					return false;
				}
			}
	
			var exts:Array = getAllExtensions();
			for each(var ii:* in exts) {
				if (!ii.serialize(node)) {
					return false;
				}
			}
	
			if (parent != node.parentNode) {
				parent.appendChild(node.cloneNode(true));
			}
	
			return true;
		}
	
		public function deserialize( node:XMLNode ):Boolean
		{
			setNode(node);
			removeAllItems();
	
			for each( var child:XMLNode in node.childNodes ) {
				switch( child.nodeName )
				{
					case "item":
						var item:MUCItem = new MUCItem(getNode());
						item.deserialize(child);
						myItems.push(item);
						break;
	
					default:
						var extClass:Class = ExtensionClassRegistry.lookup(child.attributes.xmlns);
						if (extClass != null) {
							var ext:IExtension = new extClass();
							if (ext != null) {
								if (ext is ISerializable) {
									ISerializable(ext).deserialize(child);
								}
								addExtension(ext);
							}
						}
						break;
				}
			}
			return true;
		}
	
		/**
		 * Item interface to MUCItems if they are contained in this extension
		 *
		 * @return Array of MUCItem objects
		 */
		public function getAllItems():Array
		{
			return myItems;
		}
	
		/**
		 * Use this method to create a new item.  Either the affiliation or role are requried.
		 *
		 * @param	affiliation A predefined string defining the affiliation the JID or nick has in relation to the room
		 * @param	role The role the jid or nick has in the room
		 * @param	nick The nickname of the new item
		 * @param	jid The jid of the new item
		 * @param	actor The user that is actually creating the request
		 * @param	reason The reason why the action associated with this item is being preformed
		 * @return The newly created MUCItem
		 */
		public function addItem(affiliation:String=null, role:String=null, nick:String=null, jid:EscapedJID=null, actor:String=null, reason:String=null):MUCItem
		{
			var item:MUCItem = new MUCItem(getNode());
	
			if (exists(affiliation)){ item.affiliation = affiliation; }
			if (exists(role)) 		{ item.role = role; }
			if (exists(nick)) 		{ item.nick = nick; }
			if (exists(jid)) 		{ item.jid = jid; }
			if (exists(actor)) 		{ item.actor = new EscapedJID(actor); }
			if (exists(reason)) 	{ item.reason = reason; }
			
			myItems.push(item);
			return item;
		}
		
		/**
		 * Use this method to remove all items.
		 *
		 */
		public function removeAllItems():void
		{
			for each(var i:* in myItems) {
				i.setNode(null);
			}
		 	myItems = [];
		}
	}
}
