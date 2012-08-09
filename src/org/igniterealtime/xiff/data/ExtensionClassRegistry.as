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
		/**
		 * Array of the Extension classes.
		 */
		private static var _classes:Array = [];

		/**
		 * Registers the given extension with the extension registry for it to be used,
		 * in case incoming data matches its ELEMENT_NAME and NS.
		 *
		 * @return In case the Extension was already added or it was not proper type, returns false.
		 */
		public static function register( extensionClass:Class ):Boolean
		{
			var extensionInstance:IExtension = new extensionClass();

			//if (extensionInstance instanceof IExtension) {
			if (extensionInstance is IExtension)
			{
				if (_classes.indexOf(extensionClass) === -1)
				{
					_classes.push(extensionClass);
					return true;
				}
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
				var index:int = _classes.indexOf(extensionClass);
				if (index !== -1)
				{
					_classes.splice(index, 1);
					return true;
				}
			}
			return false;
		}

		/**
		 * Find the extension with the given NS and ELEMENT_NAME if availale in the registery.
		 *
		 * @param	ns
		 * @param	elementName Optional ELEMENT_NAME, used if there are several extensions with the same NS
		 * @return
		 */
		public static function lookup( ns:String, elementName:String = null ):Class
		{
			var len:uint = _classes.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var candidateClass:Class = _classes[ i ] as Class;
				var candidateInstance:IExtension = new candidateClass() as IExtension;
				if (candidateInstance != null && ns == candidateInstance.getNS())
				{
					if (elementName == null)
					{
						return candidateClass;
					}
					else if (elementName != null && elementName == candidateInstance.getElementName())
					{
						return candidateClass;
					}
				}
			}
			return null;
		}

		/**
		 * Get a list of namespaces of the currently enabled extensions.
		 */
		public static function getNamespaces():Array
		{
			var list:Array = [];
			var len:uint = _classes.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var candidateClass:Class = _classes[ i ] as Class;
				var candidateInstance:IExtension = new candidateClass() as IExtension;
				list.push(candidateInstance.getNS());
			}

			return list;
		}
	}
}
