/*
 * Copyright (C) 2003-2012 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
 *     Michael McCarthy <mikeycmccarthy@gmail.com>
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.igniterealtime.xiff.data
{
	
	/**
	 * This is a static class that contains class constructors for all
	 * extensions that could come from the network.
	 */
	public class ExtensionClassRegistry
	{
        private static var _classes:Object = {};
		
		/**
	     * Registers the given extension with the extension registry for it to be used,
		 * in case incoming data matches its ELEMENT_NAME and NS.
	     */
		public static function register( extensionClass:Class ):Boolean
		{
			var extensionInstance:IExtension = new extensionClass();
			
			//if (extensionInstance instanceof IExtension) {
			if (extensionInstance is IExtension)
			{
				var key:String = extensionInstance.getNS() + ":" + extensionInstance.getElementName();
				trace ("ExtensionClassRegistry.register. key: " + key);
				_classes[ key ] = extensionClass;
				return true;
			}
			return false;
		}

		/**
		 * Remove the given extension from the registery.
		 */
		public static function remove( extensionClass:Class ):Boolean
		{
			var extensionInstance:IExtension = new extensionClass();

			//if (extensionInstance instanceof IExtension) {
			if (extensionInstance is IExtension)
			{
				var key:String = extensionInstance.getNS() + ":" + extensionInstance.getElementName();
				trace ("ExtensionClassRegistry.remove. key: " + key);
				delete _classes[ key ];
				return true;
			}
			return false;
		}
		
		/**
		 * Find the extension with the given NS and ELEMENT_NAME if availale in the registery.
		 */
		public static function lookup( ns:String, elementName:String ):Class
		{
			var key:String = ns + ":" + elementName;
			return _classes[ key ] as Class;
		}

		/**
		 * Get a list of namespaces of the currently enabled extensions.
		 */
		public static function getNamespaces():Array
		{
			var list:Array = [];
			for (var key:String in _classes)
			{
				if (_classes.hasOwnProperty(key))
				{
					var namespace:String = key.substr(0, key.lastIndexOf(":"));
					trace("getNamespaces. namespace: " + namespace + ", key: " + key);
					list.push(namespace);
				}
			}

			return list;
		}
	}
}
