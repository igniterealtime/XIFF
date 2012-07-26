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
package org.igniterealtime.xiff.data.register
{
	
	import org.igniterealtime.xiff.data.*;
	
	/**
	 * XEP-0077: In-Band Registration
	 *
	 * <p>Implements jabber:iq:register namespace.  Use this to create new accounts on the jabber server.
	 * Send an empty IQ.TYPE_GET packet with this extension and the return will either be a conflict,
	 * or the fields you will need to fill out.</p>
	 *
	 * <p>Send a IQ.TYPE_SET packet to the server and with the fields that are listed in
	 * 'getRequiredFieldNames()' set on this extension.
	 * Check the result and re-establish the connection with the new account.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0077.html
	 */
	public class RegisterExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:register";
		public static const ELEMENT_NAME:String = "query";
	
		/**
		 *
		 * @param	parent (Optional) The parent node used to build the XML tree.
		 */
		public function RegisterExtension( parent:XML = null )
		{
			super(parent);
		}
	
		public function getNS():String
		{
			return RegisterExtension.NS;
		}
	
		public function getElementName():String
		{
			return RegisterExtension.ELEMENT_NAME;
		}
	
		/**
		 * In order to determine which fields are required for registration with a host,
		 * an entity SHOULD first send an IQ get to the host. The entity SHOULD NOT attempt
		 * to guess at the required fields by first sending an IQ set, since the nature
		 * of the required data is subject to service provisioning.
		 *
		 * <p>All fields available in this XML, except "key" and "instructions" are required.</p>
		 * @return Names of the required fields
		 */
		public function getRequiredFieldNames():Array
		{
			var fields:Array = [];
			var reservedNames:Array = ["key", "instructions"];
			
			for each (var child:XML in xml.children())
			{
				if (child.nodeKind() == "element")
				{
					var name:String = child.localName();
					if (reservedNames.indexOf(name) === -1)
					{
						fields.push(name);
					}
				}
			}
	
			return fields;
		}
	
		/**
		 * The 'jabber:iq:register' namespace also makes it possible for an entity to cancel a
		 * registration with a host by sending a <strong>remove</strong> element in an IQ set.
		 * The host MUST determine the identity of the requesting entity based on the 'from'
		 * address of the IQ get.
		 */
		public function get unregister():Boolean
		{
			return getField("remove") != null;
		}
		public function set unregister(value:Boolean):void
		{
			if (value)
			{
				xml.remove = "";
			}
			else
			{
				delete xml.remove;
			}
		}
	
		/**
		 * This element is obsolete, but is included here for historical completeness.
		 *
		 * <p>The <strong>key</strong> element was used as a "transaction key" in certain
		 * IQ interactions in order to verify the identity of the sender. In particular,
		 * it was used by servers (but generally not services) during in-band registration,
		 * since normally a user does not yet have a 'from' address before registering.</p>
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 */
		public function get key():String
		{
			return getField("key");
		}
		public function set key(value:String):void
		{
			setField("key", value);
		}
	
		/**
		 * Use <code>null</code> to remove.
		 */
		public function get instructions():String
		{
			return getField("instructions");
		}
		public function set instructions(value:String):void
		{
			setField("instructions", value);
		}
	
		/**
		 * The 'jabber:iq:register' namespace enables a user to change his or her
		 * password with a server or service. Once registered, the user can
		 * change passwords by setting <code>username</code> and <code>password</code>.
		 *
		 * @see http://xmpp.org/extensions/xep-0077.html#usecases-changepw
		 */
		public function get username():String
		{
			return getField("username");
		}
		public function set username(value:String):void
		{
			setField("username", value);
		}
	
		/**
		 *
		 */
		public function get nick():String
		{
			return getField("nick");
		}
		public function set nick(value:String):void
		{
			setField("nick", value);
		}
	
		/**
		 * The 'jabber:iq:register' namespace enables a user to change his or her
		 * password with a server or service. Once registered, the user can
		 * change passwords by setting <code>username</code> and <code>password</code>.
		 *
		 * @see http://xmpp.org/extensions/xep-0077.html#usecases-changepw
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
		 *
		 */
		public function get first():String
		{
			return getField("first");
		}
		public function set first(value:String):void
		{
			setField("first", value);
		}
	
		/**
		 *
		 */
		public function get last():String
		{
			return getField("last");
		}
		public function set last(value:String):void
		{
			setField("last", value);
		}
	
		/**
		 *
		 */
		public function get email():String
		{
			return getField("email");
		}
		public function set email(value:String):void
		{
			setField("email", value);
		}
	
		/**
		 *
		 */
		public function get address():String
		{
			return getField("address");
		}
		public function set address(value:String):void
		{
			setField("address", value);
		}
	
		/**
		 *
		 */
		public function get city():String
		{
			return getField("city");
		}
		public function set city(value:String):void
		{
			setField("city", value);
		}
	
		/**
		 *
		 */
		public function get state():String
		{
			return getField("state");
		}
		public function set state(value:String):void
		{
			setField("state", value);
		}
	
		/**
		 *
		 */
		public function get zip():String
		{
			return getField("zip");
		}
		public function set zip(value:String):void
		{
			setField("zip", value);
		}
	
		/**
		 *
		 */
		public function get phone():String
		{
			return getField("phone");
		}
		public function set phone(value:String):void
		{
			setField("phone", value);
		}
	
		/**
		 *
		 */
		public function get url():String
		{
			return getField("url");
		}
		public function set url(value:String):void
		{
			setField("url", value);
		}
	
		/**
		 *
		 */
		public function get date():String
		{
			return getField("date");
		}
		public function set date(value:String):void
		{
			setField("date", value);
		}
	
		/**
		 *
		 */
		public function get misc():String
		{
			return getField("misc");
		}
		public function set misc(value:String):void
		{
			setField("misc", value);
		}
	
		/**
		 *
		 */
		public function get text():String
		{
			return getField("text");
		}
		public function set text(value:String):void
		{
			setField("text", value);
		}
	}
}
