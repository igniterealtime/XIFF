/*
 * License
 */
package org.igniterealtime.xiff.data
{
	
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.XMLStanza;
	import flash.xml.XMLNode;
	
	/**
	 * This is a base class for all data extensions.
	 * @param	parent The parent node that this extension should be appended to
	 */
	public class Extension extends XMLStanza
	{
		public function Extension(parent:XMLNode=null)
		{
			super();
	
			getNode().nodeName = IExtension(this).getElementName();
			getNode().attributes.xmlns = IExtension(this).getNS();
	
			if (exists(parent)) {
				parent.appendChild(getNode());
			}
		}
	
		/**
		 * Removes the extension from its parent.
		 *
		 */
		public function remove():void
		{
			getNode().removeNode();
		}
		
		/**
		 * Converts the extension stanza XML to a string.
		 *
		 * @return The extension XML in string form
		 */
		public function toString():String
		{
			return getNode().toString();
		}
	}
}