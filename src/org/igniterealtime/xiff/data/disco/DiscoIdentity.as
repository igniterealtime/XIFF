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
package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;

	
	/**
	 *
	 * @see http://xmpp.org/extensions/xep-0030.html
	 */
	public class DiscoIdentity extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "identity";

		/**
		 *
		 * @param	parent
		 */
		public function DiscoIdentity( parent:XML=null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if( parent != null )
			{
				parent.appendChild( xml );
			}
		}

		/**
		 *
		 * @param	other
		 * @return
		 */
		public function equals( other:DiscoIdentity ):Boolean
		{
			return category == other.category && type == other.type && name == other.name && lang == other.lang;
		}

		/**
		 *
		 */
		public function get category():String
		{
			return getAttribute("category");
		}
		public function set category( value:String ):void
		{
			setAttribute("category", value);
		}

		/**
		 *
		 */
		public function get type():String
		{
			return getAttribute("type");
		}
		public function set type( value:String ):void
		{
			setAttribute("type", value);
		}

		/**
		 *
		 */
		public function get name():String
		{
			return getAttribute("name");
		}
		public function set name( value:String ):void
		{
			setAttribute("name", value);
		}

		/**
		 *
		 */
		public function get lang():String
		{
			return getAttribute("xml:lang");
		}
		public function set lang( value:String ):void
		{
			setAttribute("xml:lang", value);
		}

	}
}
