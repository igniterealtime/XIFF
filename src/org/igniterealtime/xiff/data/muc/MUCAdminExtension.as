/*
 * License
 */
package org.igniterealtime.xiff.data.muc{

	
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	
	import org.igniterealtime.xiff.data.muc.MUCBaseExtension;
	import flash.xml.XMLNode;
	
	/**
	 * Implements the administration command data model in <a href="http://xmpp.org/extensions/xep-0045.html">XEP-0045<a> for multi-user chat.
	 *
	 * @param	parent (Optional) The containing XMLNode for this extension
	 */
	public class MUCAdminExtension extends MUCBaseExtension implements IExtension
	{
		// Static class variables to be overridden in subclasses;
		public static var NS:String = "http://jabber.org/protocol/muc#admin";
		public static var ELEMENT:String = "query";
	
		private var myItems:Array;
	
		public function MUCAdminExtension( parent:XMLNode=null )
		{
			super(parent);
		}
	
		public function getNS():String
		{
			return MUCAdminExtension.NS;
		}
	
		public function getElementName():String
		{
			return MUCAdminExtension.ELEMENT;
		}
	}
}