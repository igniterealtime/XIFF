/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
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

	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.IExtendable;

	/**
	 * Contains the implementation for a generic extension container.
	 * Use the static method "decorate" to implement the IExtendable interface on a class.
	 */
	public class ExtensionContainer implements IExtendable
	{
		/**
		 * Extensions stored in arrays, indexed by their name spaces.
		 */
		public var _exts:Object = {};

		/**
		 *
		 */
		public function ExtensionContainer()
		{

		}

		/**
		 * Add an extension
		 * @param	ext
		 * @return
		 */
		public function addExtension( ext:IExtension ):IExtension
		{
			var ns:String = ext.getNS();
			if ( _exts[ ns ] == null )
			{
				_exts[ ns ] = [];
			}
			_exts[ ns ].push( ext );
			return ext;
		}

		/**
		 * Remove a specific extension.
		 * @param	ext
		 * @return
		 */
		public function removeExtension( ext:IExtension ):Boolean
		{
			var value:Boolean = false;
			var extensions:Array = _exts[ ext.getNS() ];
			if (extensions != null)
			{
				var len:uint = extensions.length;
				for ( var i:uint = 0; i < len; ++i )
				{
					if ( extensions[ i ] === ext )
					{
						extensions[ i ].remove();
						extensions.splice( i, 1 );
						value = true;
					}
				}
			}
			return value;
		}

		/**
		 * Remove extensions
		 * @param	ns Namespace of the extensions to be removed.
		 */
		public function removeAllExtensions( ns:String ):void
		{
			var extensions:Array = _exts[ ns ];
			if (extensions != null)
			{
				var len:uint = extensions.length;
				for ( var i:uint = 0; i < len; ++i )
				{
					extensions[ i ].ns(); // ?
				}
			}
			_exts[ ns ] = [];
		}

		/**
		 * Get an array of extensions having the given namespace.
		 * @param	ns
		 * @return
		 */
		public function getAllExtensionsByNS( ns:String ):Array
		{
			return _exts[ ns ];
		}

		/**
		 * Get a specific extension by its element name.
		 * @param	name
		 * @return
		 */
		public function getExtension( name:String ):Extension
		{
			return getAllExtensions().filter( 
				function( obj:IExtension, idx:int, arr:Array ):Boolean
				{
					return obj.getElementName() == name;
				}
			)[ 0 ];
		}

		/**
		 * Get the extensions in an array.
		 * @return
		 */
		public function getAllExtensions():Array
		{
			var exts:Array = [];
			for ( var ns:String in _exts )
			{
				exts = exts.concat( _exts[ ns ] );
			}
			return exts;
		}
	}
}
