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
	 * Implements jabber:iq:register namespace.  Use this to create new accounts on the jabber server.
	 * Send an empty IQ.TYPE_GET packet with this extension and the return will either be a conflict,
	 * or the fields you will need to fill out.
	 * Send a IQ.TYPE_SET packet to the server and with the fields that are listed in
	 * getRequiredFieldNames set on this extension.
	 * Check the result and re-establish the connection with the new account.
	 *
	 * @see http://xmpp.org/extensions/xep-0077.html
	 */
	public class RegisterExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:register";
		public static const ELEMENT_NAME:String = "query";
	
	    private static var staticDepends:Class = ExtensionClassRegistry;
		
		private var _fields:Object = {};
	
	
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
	     * Registers this extension with the extension registry for it to be used,
		 * in case incoming data matches the ELEMENT_NAME and NS.
	     */
	    public static function enable():void
	    {
	        ExtensionClassRegistry.register(RegisterExtension);
	    }
	
	
		/**
		 * All fields available in this XML, except "key" and "instructions" are required.
		 * @return
		 */
		public function getRequiredFieldNames():Array
		{
			var fields:Array = [];
			
			for each (var child:XML in xml.children())
			{
				if (child.nodeKind == "element")
				{
					var name:String = child.localName();
					if (name != "key" && name != "instructions")
					{
						fields.push(name);
					}
				}
			}
	
			return fields;
		}
	
		/**
		 *
		 */
		public function get unregister():Boolean
		{
			return xml.children().(localName() == "remove").length() > 0;
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
		 * Use <code>null</code> to remove.
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
		 *
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
		 *
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
