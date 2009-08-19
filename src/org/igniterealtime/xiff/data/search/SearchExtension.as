/*
 * License
 */
package org.igniterealtime.xiff.data.search{
	
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.forms.FormExtension;
		
	/**
	 * Implements jabber:iq:search namespace.  Use this to perform user searches.
	 * Send an empty IQ.GET_TYPE packet with this extension and the return will either be 
	 * a conflict, or the fields you will need to fill out.  
	 * Send a IQ.SET_TYPE packet to the server and with the fields that are listed in 
	 * getRequiredFieldNames set on this extension.  
	 * Check the result and re-establish the connection with the new account.
	 * @see http://xmpp.org/extensions/xep-0055.html
	 */
	public class SearchExtension extends Extension implements IExtension, ISerializable
	{
		// Static class variables to be overridden in subclasses;
		public static const NS:String = "jabber:iq:search";
		public static const ELEMENT:String = "query";
	
		private var _fields:Object = {};
		private var _instructionsNode:XMLNode;
		private var _items:Array = [];
	
	    private static var staticDepends:Class = ExtensionClassRegistry;
	
		/**
		 * 
		 * @param	parent (Optional) The parent node used to build the XML tree.
		 */
		public function SearchExtension( parent:XMLNode=null )
		{
			super(parent);
		}
	
		public function getNS():String
		{
			return SearchExtension.NS;
		}
	
		public function getElementName():String
		{
			return SearchExtension.ELEMENT;
		}
	
	    /**
	     * Performs the registration of this extension into the extension registry. 
	     */
	    public static function enable():void
	    {
	        ExtensionClassRegistry.register(SearchExtension);
	    }
		
		public function serialize( parentNode:XMLNode ):Boolean
		{
			if (!exists(getNode().parentNode))
			{
				parentNode.appendChild(getNode().cloneNode( true ));
			}
			return true;
		}
	
		public function deserialize( node:XMLNode ):Boolean
		{
			setNode(node);
	
			var children:Array = getNode().childNodes;
			for (var i:String in children) 
			{
	
				switch (children[i].nodeName) 
				{
					case "instructions":
						_instructionsNode = children[i];
						break;
						
					case "x":
						if (children[i].namespaceURI == FormExtension.NS)
						{
							var dataFormExt:FormExtension = new FormExtension(getNode());
							dataFormExt.deserialize(children[i]);
							addExtension(dataFormExt);
						}
						break;
						
					case "item":
						var item:SearchItem = new SearchItem(getNode());
						item.deserialize(children[i]);
						_items.push(item);
						break;
	
					default:
						_fields[children[i].nodeName] = children[i];
						break;
				}
			}
			return true;
	
		}
	
		public function getRequiredFieldNames():Array
		{
			var fields:Array = [];
	
			for (var i:String in _fields) 
			{
				fields.push(i);
			}
	
			return fields;
		}
		
		public function getAllItems():Array
		{
			return _items;
		}
	
		public function get instructions():String 
		{
			if (_instructionsNode && _instructionsNode.firstChild)
			{
				return _instructionsNode.firstChild.nodeValue;
			}
			
			return null;
		}
	
		public function set instructions(value:String):void
		{
			_instructionsNode = replaceTextNode(getNode(), _instructionsNode, "instructions", value);
		}
	
		public function getField(name:String):String
		{
			var node:XMLNode = _fields[name];
			if (node && node.firstChild)
			{
				return node.firstChild.nodeValue;
			}
			
			return null;
		}
	
		public function setField(name:String, value:String):void
		{
			_fields[name] = replaceTextNode(getNode(), _fields[name], name, value);
		}
				
	}
}
