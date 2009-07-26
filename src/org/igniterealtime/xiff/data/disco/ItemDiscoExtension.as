/*
 * License
 */
package org.igniterealtime.xiff.data.disco
{
	
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	
	/**
	 * Implements <a href="http://xmpp.org/extensions/xep-0030.html">XEP-0030<a> 
	 * for service item discovery.
	 */
	public class ItemDiscoExtension extends DiscoExtension implements IExtension
	{
		// Static class variables to be overridden in subclasses;
		public static const NS:String = "http://jabber.org/protocol/disco#items";
	
		private var myItems:Array;
		
		public function ItemDiscoExtension(xmlNode:XMLNode=null)
		{
			super(xmlNode);
		}
		
		public function getElementName():String
		{
			return DiscoExtension.ELEMENT;
		}
	
		public function getNS():String
		{
			return ItemDiscoExtension.NS;
		}
	
	    /**
	     * Performs the registration of this extension into the extension 
	     * registry.  
	     */
	    public static function enable():void
	    {
	        ExtensionClassRegistry.register(ItemDiscoExtension);
	    }
	
		/**
		 * An array of objects that represent the items discovered
		 *
		 * <p>The objects in the array have the following possible 
		 * attributes:</p>
		 * 
		 * <ul>
		 * <li><code>jid</code>: the resource name</li>
		 * <li><code>node</code>: a path to a resource that can be discovered 
		 * without a JID</li>
		 * <li><code>name</code>: the friendly name of the jid</li>
		 * <li><code>action</code>: the kind of action that occurs during 
		 * publication of services it can be either "remove" or "update"</li>
		 * </ul>
		 */
		public function get items():Array
		{
			return myItems;
		}
	
		override public function deserialize(node:XMLNode):Boolean
		{
			if (!super.deserialize(node))
				return false;
				
			myItems = [];
			
			for each(var item:XMLNode in getNode().childNodes) 
			{
				myItems.push(item.attributes);
			}
			return true;
		}
	}
}