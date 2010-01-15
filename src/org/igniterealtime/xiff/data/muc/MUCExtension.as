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
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.util.DateTimeParser;

	/**
	 * Implements the base MUC protocol schema from XEP-0045 for multi-user chat.
	 *
	 * This extension is typically used to test for the presence of MUC enabled conferencing
	 * service, or a MUC related error condition.
	 * @see http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUCExtension extends Extension implements IExtension, ISerializable
	{
		public static const ELEMENT_NAME:String = "x";

		public static const NS:String = "http://jabber.org/protocol/muc";

		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function MUCExtension( parent:XML = null )
		{
			super( parent );
		}

		public function deserialize( node:XML ):Boolean
		{
			node = node;

			return true;
		}

		public function serialize( parent:XML ):Boolean
		{
			if ( exists( node.parent() ) )
			{
				return false;
			}
			var node:XML = node.copy();
			for each ( var ext:IExtension in getAllExtensions() )
			{
				if ( ext is ISerializable )
				{
					ISerializable( ext ).serialize( node );
				}
			}
			parent.appendChild( node );
			return true;
		}

		public function getElementName():String
		{
			return MUCExtension.ELEMENT_NAME;
		}

		public function getNS():String
		{
			return MUCExtension.NS;
		}

		/**
		 * This is property allows a user to retrieve a server defined collection of previous messages.
		 * Set this property to "true" to retrieve a history of the dicussions.
		 */
		public function get history():Boolean
		{
			return exists( node.history );
		}
		public function set history( value:Boolean ):void
		{
			if ( value )
			{
				node.history = "";
			}
			else
			{
				delete node.history;
			}
		}

		/**
		 * Size based condition to evaluate by the server for the maximum
		 * characters to return during history retrieval.
		 */
		public function get maxchars():uint
		{
			return parseInt( node.history.@maxchars );
		}
		public function set maxchars( value:uint ):void
		{
			node.history.@maxchars = value.toString();
		}

		/**
		 * Protocol based condition for the number of stanzas to return during history retrieval
		 */
		public function get maxstanzas():uint
		{
			return parseInt( node.history.@maxstanzas );
		}
		public function set maxstanzas( value:uint ):void
		{
			node.history.@maxstanzas = value.toString();
		}

		/**
		 * If a room is password protected, add this extension and set the password
		 */
		public function get password():String
		{
			return node.password;
		}
		public function set password( value:String ):void
		{
			node.password = value;
		}

		/**
		 * Time based condition to retrive all messages for the last N seconds.
		 */
		public function get seconds():uint
		{
			return parseInt( node.history.@seconds );
		}
		public function set seconds( value:uint ):void
		{
			node.history.@seconds = value.toString();
		}

		/**
		 * Time base condition to retrieve all messages from a given time formatted
		 * in the format described in XEP-0082 (CCYY-MM-DDThh:mm:ss[.sss]TZD).
		 * @see http://xmpp.org/extensions/xep-0082.html
		 */
		public function get since():Date
		{
			var value:Date;
			if (node.history.@since != null)
			{
				value = DateTimeParser.string2dateTime( node.history.@since.toString() );
			}
			return value;
		}
		public function set since( value:Date ):void
		{
			delete node.history.@since;
			if (value != null)
			{
				node.history.@since = DateTimeParser.dateTime2string( value );
			}
		}
	}
}
