/*
 * License
 */
package org.igniterealtime.xiff.data.chat
{

	import org.igniterealtime.xiff.data.IExtension;
	
	/**
	 * @see	http://xmpp.org/extensions/xep-0085.html
	 */
	public class ChatStateExtension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/chatstates";
		
		/**
		 * TODO: Can be any of the ChatState constants...
		 * @return
		 */
		public function getElementName():String
		{
			return "active";
		}
	
		public function getNS():String
		{
			return ChatStateExtension.NS;
		}
	}
}
