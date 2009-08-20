/*
 * License
 */
package org.igniterealtime.xiff.data.xhtml
{



	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;

	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;

	/**
	 * This class provides an extension for XHTML body text in messages.
	 * @see http://xmpp.org/extensions/xep-0071.html
	 */
	public class XHTMLExtension extends Extension implements IExtension, ISerializable
	{
		// Static class variables to be overridden in subclasses;
		public static const NS:String = "http://www.w3.org/1999/xhtml";
		public static const ELEMENT:String = "html";

	    private static var staticDepends:Class = ExtensionClassRegistry;

		/**
		 *
		 * @param	parent The parent node for this extension
		 */
		public function XHTMLExtension(parent:XMLNode = null)
		{
			super(parent);
		}

		/**
		 *
		 * @param	parent The parent node for this extension
		 */
		public function serialize( parent:XMLNode ):Boolean
        {
             return true;
        }

		/**
		 *
		 * @param	parent The parent node for this extension
		 */
        public function deserialize( node:XMLNode ):Boolean
        {
        	return true;
        }

		/**
		 * Gets the namespace associated with this extension.
		 * The namespace for the XHTMLExtension is "http://www.w3.org/1999/xhtml".
		 *
		 * @return The namespace
		 */
		public function getNS():String
		{
			return XHTMLExtension.NS;
		}

		/**
		 * Gets the element name associated with this extension.
		 * The element for this extension is "html".
		 *
		 * @return The element name
		 */
		public function getElementName():String
		{
			return XHTMLExtension.ELEMENT;
		}

	    /**
	     * Performs the registration of this extension into the extension registry.
	     *
	     */
	    public static function enable():void
	    {
	        ExtensionClassRegistry.register(XHTMLExtension);
	    }

		/**
		 * The XHTML body text. Valid XHTML is REQUIRED. Because XMPP operates using
		 * valid XML, standard HTML, which is not necessarily XML-parser compliant, will
		 * not work.
		 *
		 */
		public function get body():String
		{
			var html:Array = [];
			for each(var child:XMLNode in getNode().childNodes)
			{
				html.unshift(child.toString());
			}
			return html.join();
		}
		public function set body(value:String):void
		{
			for each(var child:XMLNode in getNode().childNodes)
			{
				child.removeNode();
			}
			getNode().appendChild(new XMLDocument(value));
		}
	}
}
