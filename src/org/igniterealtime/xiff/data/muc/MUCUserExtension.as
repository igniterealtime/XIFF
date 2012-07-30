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
package org.igniterealtime.xiff.data.muc
{
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * Implements the base MUC user protocol schema from
	 * <a href="http://www.xmpp.org/extensions/xep-0045.html">XEP-0045</a> for multi-user chat.
	 *
	 * @see http://xmpp.org/extensions/xep-0045.html
	 */
	public class MUCUserExtension extends MUCBaseExtension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/muc#user";
		public static const ELEMENT_NAME:String = "x";

		public static const TYPE_DECLINE:String = "decline";
		public static const TYPE_DESTROY:String = "destroy";
		public static const TYPE_INVITE:String = "invite";
		public static const TYPE_OTHER:String = "other";

		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function MUCUserExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return MUCUserExtension.NS;
		}

		public function getElementName():String
		{
			return MUCUserExtension.ELEMENT_NAME;
		}

		/**
		 * Use this extension to invite another user
		 */
		public function invite(to:EscapedJID, from:EscapedJID, reason:String):void
		{
			updateActionNode(TYPE_INVITE, {to:to.toString(), from:from ? from.toString() : null}, reason);
		}

		/**
		 * Use this extension to destroy a room
		 */
		public function destroy(room:EscapedJID, reason:String):void
		{
			updateActionNode(TYPE_DESTROY, {jid: room.toString()}, reason);
		}

		/**
		 * Use this extension to decline an invitation
		 */
		public function decline(to:EscapedJID, from:EscapedJID, reason:String):void
		{
			updateActionNode(TYPE_DECLINE, {to:to.toString(), from:from ? from.toString() : null}, reason);
		}

		/**
		 * Does the given status code exist in the list of statuses saved in this extension.
		 * @param	code
		 * @return
		 */
		public function hasStatusCode(code:Number):Boolean
		{
			for each(var status:MUCStatus in statuses)
			{
				if (status.code == code)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * Internal method that manages the type of node that we will use for invite/destroy/decline messages
		 *
		 * @param	type
		 * @param	attrs
		 * @param	reason
		 */
		private function updateActionNode(type:String, attrs:Object, reason:String) : void
		{
			xml[type] = "";

			for (var i:String in attrs)
			{
				if (attrs.hasOwnProperty(i))
				{
					xml[type].@[i] = attrs[i];
				}
			}

			if (reason == null)
			{
				delete xml[type].reason;
			}
			else
			{
				xml[type].reason = reason;
			}
		}

		/**
		 * The type of user extension this is
		 */
		public function get type():String
		{
			var list:Array = [
				TYPE_DECLINE,
				TYPE_DESTROY,
				TYPE_INVITE,
				TYPE_OTHER
			];

			var len:uint = list.length;
			for (var i:uint = 0; i < len; ++i)
			{
				var key:String = list[i] as String;
				if (xml.children().(localName() == key).length() > 0)
				{
					return key;
				}
			}

			return null;
		}

		/**
		 * The to property for invite and decline action types
		 */
		public function get to():EscapedJID
		{
			var list:XMLList = xml.children()[0].attribute("to");
			if ( list.length() > 0 )
			{
				return new EscapedJID(list[0]);
			}
			return null;
		}

		/**
		 * The from property for invite and decline action types
		 */
		public function get from():EscapedJID
		{
			var list:XMLList = xml.children()[0].attribute("from");
			if ( list.length() > 0 )
			{
				return new EscapedJID(list[0]);
			}
			return null;
		}

		/**
		 * The jid property for destroy the action type
		 */
		public function get jid():EscapedJID
		{
			var value:String = getChildAttribute(TYPE_DESTROY, "jid");
			if ( value != null )
			{
				return new EscapedJID(value);
			}
			return null;
		}

		/**
		 * The reason for the invite/decline/destroy
		 */
		public function get reason():String
		{
			return getChildField(type, "reason");
		}
		public function set reason(value:String):void
		{
			if (type == null)
			{
				throw new Error("type needs to be defined for MUCUserExtension");
			}
			xml[type].reason = value;
		}

		/**
		 * Property to use if the concerned room is password protected
		 */
		public function get password():String
		{
			return getField("password");
		}
		public function set password(value:String):void
		{
			setField("password", value);
		}

		/**
		 * List of MUCStatus.
		 *
		 * @see org.igniterealtime.xiff.data.muc.MUCStatus
		 */
		public function get statuses():Array
		{
			var list:Array = [];
			for each( var child:XML in xml.children() )
			{
				if ( child.localName() == MUCStatus.ELEMENT_NAME )
				{
					var item:MUCStatus = new MUCStatus();
					item.xml = child;
					list.push(item);
				}
			}
			return list;
		}
		public function set statuses(value:Array):void
		{
			removeFields(MUCStatus.ELEMENT_NAME);

			if ( value != null )
			{
				var len:uint = value.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var item:MUCStatus = value[i] as MUCStatus;
					xml.appendChild( item.xml );
				}
			}
		}
	}
}
