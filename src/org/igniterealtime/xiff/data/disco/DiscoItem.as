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
	public class DiscoItem extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "item";

		/**
		 *
		 * @param	parent
		 */
		public function DiscoItem( parent:XML=null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if ( parent != null )
			{
				parent.appendChild( xml );
			}
		}

		/**
		 * Does all three properties match the in the given DiscoItem to this one?
		 *
		 * @param	other
		 * @return
		 */
		public function equals( other:DiscoItem ):Boolean
		{
			return jid == other.jid && name == other.name && node == other.node;
		}

		/**
		 * Attribute specifying the JID of the item.
		 *
		 * <p>required</p>
		 */
		public function get jid():String
		{
			return getAttribute("jid");
		}
		public function set jid( value:String ):void
		{
			setAttribute("jid", value);
		}

		/**
		 * A natural-language name for the item.
		 *
		 * <p>optional</p>
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
		 * The value of the node attribute may or may not have semantic meaning;
		 * from the perspective of Service Discovery, a node is merely
		 * something that is associated with an entity.
		 *
		 * <p>optional</p>
		 */
		public function get node():String
		{
			return getAttribute("node");
		}
		public function set node( value:String ):void
		{
			setAttribute("node", value);
		}

	}
}
