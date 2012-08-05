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
	 * Contains the implementation for a generic extension container.
	 * Use the static method "decorate" to implement the IExtendable interface on a class.
	 */
	public class ExtensionContainer implements IExtendable
	{
	
		
		/**
		 * From ExtensionContainer
		 * { NS: [ Extension, Extension, ... ], ... }
		 */
		private var _exts:Object = { };
		
		/**
		 * The XML.
		 */
		private var _xml:XML;
		
		/**
		 *
		 */
		public function ExtensionContainer()
		{
			// Initialize here to make sure that methods are available.
			_xml = <xmlstanza/>;
		}
		
		/**
		 * Add extension to the list of the given namespace and insert to the XML element as a child.
		 * @param	extension
		 * @return The same IExtension that was passed via the parameter
		 */
		public function addExtension( extension:IExtension ):IExtension
		{
			if (!_exts.hasOwnProperty(extension.getNS()))
			{
				_exts[extension.getNS()] = [];
			}
			_exts[extension.getNS()].push(extension);
			
			if (!xml.children().contains(extension.xml))
			{
				xml.appendChild(extension.xml);
			}
			
			return extension;
		}
	
		/**
		 *
		 * @param	extension
		 * @return
		 */
		public function removeExtension( extension:IExtension ):Boolean
		{
			var extensions:Object = _exts[extension.getNS()];
			for (var i:String in extensions)
			{
				if (extensions[i] === extension)
				{
					extensions[i].remove();
					extensions.splice(parseInt(i), 1);
					return true;
				}
			}
			return false;
		}
		
		/**
		 *
		 * @param	nameSpace
		 */
		public function removeAllExtensions( nameSpace:String ):void
		{
			if (!_exts.hasOwnProperty(nameSpace))
			{
				return;
			}
			for (var i:String in _exts[nameSpace])
			{
				removeExtension( _exts[nameSpace][i] );
			}
			_exts[nameSpace] = [];
		}
	
		/**
		 *
		 * @param	nameSpace
		 * @return
		 */
		public function getAllExtensionsByNS( nameSpace:String ):Array
		{
			return _exts[nameSpace];
		}
		
		/**
		 * Get the extension having the given element name.
		 * Unfortunetly only takes the oldest of the list...
		 * @param	name
		 * @return
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Array.html#filter%28%29
		 */
		public function getExtension( elementName:String ):IExtension
		{
			var exts:Array = getAllExtensions();
			
			var list:Array = exts.filter( function(obj:IExtension, idx:int, arr:Array):Boolean
			{
				return obj.getElementName() == elementName;
			});
			
			return list[0];
		}
	
		/**
		 *
		 * @return
		 */
		public function getAllExtensions():Array
		{
			var exts:Array = [];
			for (var ns:String in _exts)
			{
				exts = exts.concat(_exts[ns]);
			}
			return exts;
		}
		
		/**
		 * The XML node that should be used for this stanza's internal XML representation,
		 * base of the XMLStanza, XML element.
		 *
		 * <p>Simply by setting this will take care of the required parsing and deserialisation.</p>
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/XML.html
		 * @see http://www.w3.org/TR/xml/
		 */
		public function get xml():XML
		{
			return _xml;
		}
		public function set xml( elem:XML ):void
		{
			var parent:XML = _xml.parent();
			if ( parent != null )
			{
				parent.appendChild(elem);
			}
			
			_xml = elem;
			_xml.normalize();
		}
	}
}
