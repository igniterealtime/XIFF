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
package org.igniterealtime.xiff.data.muc
{
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * Implements the base MUC user protocol schema from XEP-0045 for multi-user chat.
	 * @see http://xmpp.org/extensions/xep-0045.html
	 */
	public class MUCUserExtension extends MUCBaseExtension implements IExtension
	{
		public static const TYPE_DECLINE:String = "decline";
		public static const TYPE_DESTROY:String = "destroy";
		public static const TYPE_INVITE:String = "invite";
		public static const TYPE_OTHER:String = "other";
		
		public static const ELEMENT_NAME:String = "x";
		public static const NS:String = "http://jabber.org/protocol/muc#user";
<<<<<<< .mine

		private var _actionNode:XML;

=======
		public static const ELEMENT:String = "x";
	
		public static const TYPE_DECLINE:String = "decline";
		public static const TYPE_DESTROY:String = "destroy";
		public static const TYPE_INVITE:String = "invite";
		public static const TYPE_OTHER:String = "other";
	
		private var _actionNode:XMLNode;
		private var _passwordNode:XMLNode;
>>>>>>> .r11468
		private var _statuses:Array = [];

		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function MUCUserExtension( parent:XML = null )
		{
			super( parent );
		}

		/**
		 * Use this extension to decline an invitation
		 */
		public function decline( to:EscapedJID, from:EscapedJID, reason:String ):void
		{
			updateActionNode( TYPE_DECLINE, { to: to.toString(), from: from ? from.toString() :
									  null }, reason );
		}

		override public function deserialize( node:XML ):Boolean
		{
			super.deserialize( node );

			for each ( var child:XML in node.children() )
			{
				switch ( child.name() )
				{
					case TYPE_DECLINE:
						_actionNode = child;
						break;
<<<<<<< .mine

					case TYPE_DESTROY:
=======
						
					case TYPE_DESTROY:
>>>>>>> .r11468
						_actionNode = child;
						break;
<<<<<<< .mine

					case TYPE_INVITE:
=======
						
					case TYPE_INVITE:
>>>>>>> .r11468
						_actionNode = child;
						break;

					case "status":
						_statuses.push( new MUCStatus( child, this ) );
						break;
				}
			}
			return true;
		}

		/**
<<<<<<< .mine
=======
		 * Use this extension to invite another user
		 */
		public function invite(to:EscapedJID, from:EscapedJID, reason:String):void
		{
			updateActionNode(TYPE_INVITE, {to:to.toString(), from:from ? from.toString() : null}, reason);
		}
	
		/**
>>>>>>> .r11468
		 * Use this extension to destroy a room
		 */
		public function destroy( room:EscapedJID, reason:String ):void
		{
<<<<<<< .mine
			updateActionNode( TYPE_DESTROY, { jid: room.toString() }, reason );
=======
			updateActionNode(TYPE_DESTROY, {jid: room.toString()}, reason);
>>>>>>> .r11468
		}

		public function getNS():String
		{
<<<<<<< .mine
			return MUCUserExtension.NS;
=======
			updateActionNode(TYPE_DECLINE, {to:to.toString(), from:from ? from.toString() : null}, reason);
>>>>>>> .r11468
		}

		public function getElementName():String
		{
			return MUCUserExtension.ELEMENT_NAME;
		}

		/**
		 * @param	code
		 * @return
		 */
		public function hasStatusCode( code:int ):Boolean
		{
			for each ( var status:MUCStatus in statuses )
			{
				if ( status.code == code )
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * Use this extension to invite another user
		 */
		public function invite( to:EscapedJID, from:EscapedJID, reason:String ):void
		{
<<<<<<< .mine
			updateActionNode( TYPE_INVITE, { to: to.toString(), from: from ? from.toString() :
									  null }, reason );
=======
			if (_actionNode == null)
				return null;
			return _actionNode.nodeName == null ? TYPE_OTHER : _actionNode.nodeName;
>>>>>>> .r11468
		}

		/**
		 * Internal method that manages the type of node that we will use for invite/destroy/decline messages
		 */
		private function updateActionNode( type:String, attrs:Object, reason:String ):void
		{
				
			_actionNode = <{ type }/> ;
			for ( var i:String in attrs )
			{
				if ( exists( attrs[ i ] ) )
				{
					_actionNode.@[ i ] = attrs[ i ];
				}
			}
			node.appendChild( _actionNode );

			if ( reason.length > 0 )
			{
				_actionNode.reason = reason;
			}
		}

		/**
		 * The from property for invite and decline action types
		 */
		public function get from():EscapedJID
		{
			return new EscapedJID( _actionNode.@from );
		}

		/**
		 * The jid property for destroy the action type
		 */
		public function get jid():EscapedJID
		{
			return new EscapedJID( _actionNode.@jid );
		}

		/**
		 * Property to use if the concerned room is password protected
		 */
		public function get password():String
		{
			return node.password.text();
		}
		public function set password( value:String ):void
		{
			node.password = value;
		}

		/**
		 * The reason for the invite/decline/destroy
		 */
		public function get reason():String
		{
			if ( _actionNode[0] != null )
			{
				if ( _actionNode[0].firstChild != null )
				{
					return _actionNode[0].firstChild.toString();
				}
			}
			return null;
		}


		public function get statuses():Array
		{
			return _statuses;
		}

		public function set statuses( value:Array ):void
		{
			_statuses = value;
		}

		/**
		 * The to property for invite and decline action types
		 */
		public function get to():EscapedJID
		{
			return new EscapedJID( _actionNode.@to );
		}

		/**
		 * The type of user extension this is
		 */
		public function get type():String
		{
			if ( _actionNode == null )
				return null;
			return _actionNode.name() == null ? TYPE_OTHER : _actionNode.name();
		}
	}
}
