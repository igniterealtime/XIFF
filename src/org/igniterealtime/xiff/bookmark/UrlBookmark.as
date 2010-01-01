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
package org.igniterealtime.xiff.bookmark
{

	import org.igniterealtime.xiff.data.ISerializable;

	public class UrlBookmark implements ISerializable
	{
		private var _node:XML;

		/**
		 *
		 * @param	name
		 * @param	url
		 */
		public function UrlBookmark( name:String = null, url:String = null )
		{
			if ( !name && !url )
			{
				return;
			}
			else if ( !name || !url )
			{
				throw new Error( "Name and url cannot be null, they must either both be null or an Object" );
			}

			_node = <url/>;
			_node.@name = name;
			_node.@url = url;
		}

		public function deserialize( node:XML ):Boolean
		{
			_node = node;
			return true;
		}

		public function serialize( parentNode:XML ):Boolean
		{
			parentNode.appendChild( _node );
			return true;
		}

		public function get name():String
		{
			return _node.@name.toString();
		}

		public function get url():String
		{
			return _node.@uri.toString();
		}
	}
}
