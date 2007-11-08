package org.jivesoftware.xiff.data
{
	import flash.xml.XMLNode;

	public class AbstractExtension extends Extension implements ISerializable {
		public function AbstractExtension(parent:XMLNode=null) {
			super(parent);
		}
		
		public function serialize(parentNode:XMLNode):Boolean
		{
			var node:XMLNode = getNode().cloneNode(true);
			var extensions:Array = getAllExtensions();
			for (var i:int = 0; i < extensions.length; i++) {
				if (extensions[i] is ISerializable) {
					ISerializable(extensions[i]).serialize(node);
				}
			}
			parentNode.appendChild(node);
			return true;
		}
		
		public function deserialize(node:XMLNode):Boolean
		{
			setNode(node);
			var childNodes:Array = node.childNodes;
			for (var i:int = 0; i < childNodes.length; i++) {
				var extClass:Class = ExtensionClassRegistry.lookup(childNodes[i].attributes.xmlns);
				if (extClass == null) {
					continue;
				}
				var ext:IExtension = new extClass();
				if (ext == null) {
					continue;
				}
				if (ext is ISerializable) {
					ISerializable(ext).deserialize(childNodes[i]);
				}
				addExtension(ext);
			}
			return true;
		}
		
	}
}