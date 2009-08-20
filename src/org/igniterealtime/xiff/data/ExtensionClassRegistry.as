/*
 * License
 */
package org.igniterealtime.xiff.data
{

	
	import org.igniterealtime.xiff.data.IExtension;
	import flash.xml.XMLDocument;
	
	/**
	 * This is a static class that contains class constructors for all extensions that could come from the network.
	 */
	public class ExtensionClassRegistry
	{
		private static var _classes:Array = [];
		
		public static function register( extensionClass:Class ):Boolean
		{
			//trace ("ExtensionClassRegistry.register(" + extensionClass + ")");
			
			var extensionInstance:IExtension = new extensionClass();
			
			//if (extensionInstance instanceof IExtension) {
			if (extensionInstance is IExtension)
			{
				_classes[extensionInstance.getNS()] = extensionClass;
				return true;
			}
			return false;
		}
		
		public static function lookup( ns:String ):Class
		{
			return _classes[ ns ];
		}
	}
}
