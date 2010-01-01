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
	public class RegisterExtension extends Extension implements IExtension, ISerializable
	{
		public static const ELEMENT_NAME:String = "query";

		public static const NS:String = "jabber:iq:register";

		private static var staticDepends:Class = ExtensionClassRegistry;

		private var _fields:Object = {};

		private var _instructionsNode:XML;

		private var _keyNode:XML;

		private var _removeNode:XML;


		/**
		 *
		 * @param	parent (Optional) The parent node used to build the XML tree.
		 */
<<<<<<< .mine
		public function RegisterExtension( parent:XML = null )
=======
		public function RegisterExtension( parent:XMLNode = null )
>>>>>>> .r11468
		{
			super( parent );
		}

		/**
		 * Performs the registration of this extension into the extension registry.
		 *
		 */
		public static function enable():void
		{
			ExtensionClassRegistry.register( RegisterExtension );
		}

		/**
		 *
		 */
		public function get address():String
		{
			return node.address.text();
		}

		public function set address( value:String ):void
		{
			node.address = value;
		}

		/**
		 *
		 */
		public function get city():String
		{
			return node.city.text();
		}

		public function set city( value:String ):void
		{
			node.city = value;
		}

		/**
		 *
		 */
		public function get date():String
		{
			return node.date.text();
		}

		public function set date( value:String ):void
		{
			node.date = value;
		}

		/**
		 *
		 * @param	node
		 * @return
		 */
		public function deserialize( node:XML ):Boolean
		{
			node = node;

			for each ( var child:XML in node.children() )
			{
				switch ( child.name() )
				{

					default:
						_fields[ child.name() ] = child;
						break;
				}
			}
			return true;

		}

		/**
		 *
		 */
		public function get email():String
		{
			return node.email.text();
		}

		public function set email( value:String ):void
		{
			node.email = value;
		}

		/**
		 *
		 */
		public function get first():String
		{
			return node.first.text();
		}

		public function set first( value:String ):void
		{
			node.first = value;
		}

		public function getElementName():String
		{
			return RegisterExtension.ELEMENT_NAME;
		}

		public function getNS():String
		{
			return RegisterExtension.NS;
		}

		/**
		 *
		 * @return
		 */
		public function getRequiredFieldNames():Array
		{
			var fields:Array = [];

			for ( var i:String in _fields )
			{
				fields.push( i );
			}

			return fields;
		}

		/**
		 *
		 */
		public function get instructions():String
		{
			return node.instructions.text();
		}
		public function set instructions( value:String ):void
		{
			node.instructions = value;
		}

		/**
		 *
		 */
		public function get key():String
		{
			return node.key.text();
		}
		public function set key( value:String ):void
		{
			node.key = value;
		}

		/**
		 *
		 */
		public function get last():String
		{
			return node.last.text();
		}

		public function set last( value:String ):void
		{
			node.last = value;
		}

		/**
		 *
		 */
		public function get misc():String
		{
			return node.misc.text();
		}

		public function set misc( value:String ):void
		{
			node.misc = value;
		}

		/**
		 *
		 */
		public function get nick():String
		{
			return node.nick.text();
		}

		public function set nick( value:String ):void
		{
			node.nick = value;
		}

		/**
		 *
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
		 *
		 */
		public function get phone():String
		{
			return node.phone.text();
		}

		public function set phone( value:String ):void
		{
			node.phone = value;
		}

		/**
		 *
		 * @param	parentNode
		 * @return
		 */
		public function serialize( parentNode:XML ):Boolean
		{
			if ( !exists( node.parent() ) )
			{
				parentNode.appendChild( node );
			}
			return true;
		}

		/**
		 *
		 */
		public function get state():String
		{
			return node.state.text();
		}

		public function set state( value:String ):void
		{
			node.state = value;
		}

		/**
		 *
		 */
		public function get text():String
		{
			return node.text.text();
		}

		public function set text( value:String ):void
		{
			node.text = value;
		}

		/**
		 *
		 */
		public function get unregister():Boolean
		{
			return exists( node.remove );
		}
		public function set unregister( value:Boolean ):void
		{
			delete node.remove;
			if (value)
			{
				node.remove = "";
			}
		}

		/**
		 *
		 */
		public function get url():String
		{
			return node.url.text();
		}

		public function set url( value:String ):void
		{
			node.url = value;
		}

		/**
		 *
		 */
		public function get username():String
		{
			return node.username.text();
		}

		public function set username( value:String ):void
		{
			node.username = value;
		}

		/**
		 *
		 */
		public function get zip():String
		{
			return node.zip.text();
		}

		public function set zip( value:String ):void
		{
			node.zip = value;
		}
	}
}
