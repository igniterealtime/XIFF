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

	public class AbstractExtension extends Extension implements ISerializable
	{
		public function AbstractExtension( parent:XML = null )
		{
			super( parent );
		}

		public function serialize( parentNode:XML ):Boolean
		{
			var node:XML = node.copy();
			var extensions:Array = getAllExtensions();
			for ( var i:int = 0; i < extensions.length; ++i )
			{
				if ( extensions[ i ] is ISerializable )
				{
					ISerializable( extensions[ i ] ).serialize( node );
				}
			}
			parentNode.appendChild( node );
			return true;
		}

		public function deserialize( node:XML ):Boolean
		{
			node = node;
			for each ( var extNode:XML in node.children() )
			{
				var extClass:Class = ExtensionClassRegistry.lookup( extNode.@xmlns );
				if ( extClass == null )
				{
					continue;
				}
				var ext:IExtension = new extClass();
				if ( ext == null )
				{
					continue;
				}
				if ( ext is ISerializable )

				{
					ISerializable( ext ).deserialize( extNode );
				}
				addExtension( ext );
			}
			return true;
		}

	}
}