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
package org.igniterealtime.xiff.data.browse
{
	
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;
	
	/**
	 * Class that representes a child resource of a browsed resource.
	 *
	 * <p>XEP-0011: Jabber Browsing (obsolete)</p>
	 * @see http://xmpp.org/extensions/xep-0011.html
	 */
	public class BrowseItem extends XMLStanza implements ISerializable
	{
		/**
		 *
		 * @param	parent
		 */
		public function BrowseItem(parent:XML)
		{
			super();
			xml.setLocalName( "item" );
	
			if (parent != null)
			{
				parent.appendChild(xml);
			}
	
		}
	
		/**
		 * Add new features that are supported if you are responding to a
		 * browse request
		 */
		public function addNamespace(value:String):XML
		{
			var node:XML = <ns>{ value }</ns>;
			xml.appendChild(node);
			
			return node;
		}
	
		/**
		 * The full JabberID of the entity described
		 */
		public function get jid():String
		{
			return xml.@jid;
		}
		public function set jid(value:String):void
		{
			xml.@jid = value;
		}
	
		/**
		 * One of the categories from the list above, or a
		 * non-standard category prefixed with the string "x-".
		 *
		 * @see	http://xmpp.org/extensions/xep-0011.html#sect-id2594870
		 */
		public function get category():String
		{
			return xml.@category;
		}
		public function set category(value:String):void
		{
			xml.@category = value;
		}
	
		/**
		 * A friendly name that may be used in a user interface
		 */
		public function get name():String
		{
			return xml.@name;
		}
		public function set name(value:String):void
		{
			xml.@name = value;
		}
	
		/**
		 * One of the official types from the specified category,
		 * or a non-standard type prefixed with the string "x-".

		 * @see	http://xmpp.org/extensions/xep-0011.html#sect-id2594870
		 */
		public function get type():String
		{
			return xml.@type;
		}
		public function set type(value:String):void
		{
			xml.@type = value;
		}
	
		/**
		 * A string containing the version of the node, equivalent
		 * to the response provided to a query in the 'jabber:iq:version'
		 * namespace. This is useful for servers, especially for lists of
		 * services (see the 'service/serverlist' category/type above).
		 */
		public function get version():String
		{
			return xml.@version;
		}
		public function set version(value:String):void
		{
			xml.@version = value;
		}
	
	 	/**
		 * On top of the browsing framework, a simple form of "feature
		 * advertisement" can be built. This enables any entity to advertise
		 * whichfeatures it supports, based on the namespaces associated with
		 * those features. The <ns/> element is allowed as a subelement of the
		 * item. This element contains a single namespace that the entity
		 * supports, and multiple <ns/> elements can be included in any item.
		 * For a connectedclient this might be <ns>jabber:iq:oob</ns>, or for a
		 * service<ns>jabber:iq:search</ns>. This list of namespaces should be
		 * used to present available options for a user or to automatically
		 * locate functionality for an application.
		 *
		 * <p>The children of a browse result may proactively contain a few
		 * <ns/> elements (such as the result of the service request to the home
		 * server), which advertises the features that the particular service
		 * supports. Thislist may not be complete (it is only for first-pass
		 * filtering by simpler clients), and the JID should be browsed if a
		 * complete list is required.</p>
		 */
		public function get namespaces():Array
		{
			var res:Array = [];
	
			for each (var child:XML in xml.children())
			{
				if (child.localName() == "ns")
				{
					res.push(child.toString());
				}
			}
			return res;
		}
	}
}
