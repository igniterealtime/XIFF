/*
 * License
 */
package org.igniterealtime.xiff.data.browse
{
	
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	
	/**
	 * Implements jabber:iq:browse namespace.  Use this extension to request the items
	 * of an agent or service such as the rooms of a conference server or the members of
	 * a room.
	 * OBSOLETE
	 * @see http://xmpp.org/extensions/xep-0011.html
	 */
	public class BrowseExtension extends BrowseItem implements IExtension, ISerializable
	{
		// Static class variables to be overridden in subclasses;
		public static const NS:String = "jabber:iq:browse";
		public static const ELEMENT:String = "query";
	
	    private static var staticDepends:Class = ExtensionClassRegistry;
	
		private var myItems:Array;
	
		public function BrowseExtension(parent:XMLNode = null)
		{
			super(parent);
	
			getNode().attributes.xmlns = getNS();
			getNode().nodeName = getElementName();
	
			myItems = [];
		}
	
		/**
		 * Gets the namespace associated with this extension.
		 * The namespace for the BrowseExtension is "jabber:iq:browse".
		 *
		 * @return The namespace
		 */
		public function getNS():String
		{
			return BrowseExtension.NS;
		}
	
		/**
		 * Gets the element name associated with this extension.
		 * The element for this extension is "query".
		 */
		public function getElementName():String
		{
			return BrowseExtension.ELEMENT;
		}
	
	    /**
	     * Performs the registration of this extension into the extension registry.
	     */
	    public static function enable():void
	    {
	        ExtensionClassRegistry.register(BrowseExtension);
	    }
	
		/**
		 * If you are generating a browse response to a browse request, then
		 * fill out the items list with this method.
		 *
		 * @param	item BrowseItem which contains the info related to the browsed resource
		 * @return	the item added
		 * @see	org.igniterealtime.xiff.data.browse.BrowseItem
		 */
		public function addItem(item:BrowseItem):BrowseItem
		{
			myItems.push(item);
			return item;
		}
	
		/**
		 * An array of BrowseItems containing information about the browsed resource
		 *
		 * @return	array of BrowseItems
		 * @see	org.igniterealtime.xiff.data.browse.BrowseItem
		 */
		public function get items():Array
		{
			return myItems;
		}
	
		/**
		 * ISerializable implementation which loads this extension from XML
		 *
		 * @see	org.igniterealtime.xiff.data.ISerializable
		 */
		override public function serialize(parentNode:XMLNode):Boolean
		{
			var node:XMLNode = getNode();
			for each (var item:BrowseItem in myItems) {
				item.serialize(node);
			}
	
			if (!exists(node.parentNode)) {
				parentNode.appendChild(node.cloneNode(true));
			}
	
			return true;
		}
	
		/**
		 * ISerializable implementation which saves this extension to XML
		 *
		 * @see	org.igniterealtime.xiff.data.ISerializable
		 */
		override public function deserialize(node:XMLNode):Boolean
		{
			setNode(node);
	
			this['deserialized'] = true;
	
			myItems = [];
	
			for each (var child:XMLNode in node.childNodes) {
				switch(child.nodeName) {
					case "item":
						var item:BrowseItem = new BrowseItem(getNode());
						item.deserialize(child);
						myItems.push(item);
						break;
				}
			}
			return true;
		}
	}
}
