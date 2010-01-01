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

	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.ISerializable;

	public class GroupChatBookmark implements ISerializable
	{
		private var _node:XML;

		/**
		 *
		 * @param	name
		 * @param	jid
		 * @param	autoJoin
		 * @param	nickname
		 * @param	password
		 */
		public function GroupChatBookmark( name:String = null, jid:EscapedJID = null,
										   autoJoin:Boolean = false, nickname:String = null,
										   password:String = null )
		{
			if ( !name && !jid )
			{
				return;
			}
			else if ( !name || !jid )
			{
				throw new Error( "Name and jid cannot be null, they must either both be null or an Object" );
			}
			_node = <conference/>;
			_node.@name = name;
			_node.@jid = jid.toString();
			if ( autoJoin )
			{
				_node.@autojoin = "true";
			}
			if ( nickname )
			{
				_node.nick = nickname;
			}
			if ( password )
			{
				_node.password = password;
			}
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

		public function get autoJoin():Boolean
		{
			return _node.@autojoin == "true";
		}

		public function set autoJoin( value:Boolean ):void
		{
			_node.@autojoin = value.toString();
		}

		public function get jid():EscapedJID
		{
			return new EscapedJID( _node.@jid );
		}

		public function get name():String
		{
			return _node.@name.toString();
		}

		public function get nickname():String
		{
			return _node.nick.toString();
		}

		public function get password():String
		{
			return _node.password.toString();
		}
	}
}
