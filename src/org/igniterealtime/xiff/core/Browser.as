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
package org.igniterealtime.xiff.core
{
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.data.browse.BrowseExtension;
	import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
	import org.igniterealtime.xiff.data.disco.ItemDiscoExtension;

	/**
	 * XEP-0030: Service Discovery
	 *
	 * <p>This class provides a means of querying for available services on an XMPP
	 * server using the Disco protocol extension. For more information on Disco,
	 * take a look at
	 * <a href="http://xmpp.org/extensions/xep-0030.html">XEP-0030</a> and
	 * <a href="http://xmpp.org/extensions/xep-0011.html">XEP-0011 (obsolete)</a> for the
	 * protocol enhancement specifications.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0030.html
	 * @see http://xmpp.org/extensions/xep-0011.html
	 */
	public class Browser implements IBrowser
	{
		private var _connection:IXMPPConnection;

		private var _pending:Object = {};


		/**
		 * Creates a new Browser object.
		 *
		 * @param	aConnection A reference to the <code>XMPPConnection</code> instance to use.
		 */
		public function Browser( aConnection:IXMPPConnection )
		{
			connection = aConnection;
        }

		/**
		 *
		 * @param	service
		 * @param	node
		 * @param	callback
		 * @param	errorCallback
		 * @return org.igniterealtime.xiff.data.IQ
		 * @see http://xmpp.org/extensions/xep-0030.html#info-nodes
		 */
		public function getNodeInfo( service:EscapedJID, node:String, callback:Function, errorCallback:Function = null ):IIQ
		{
			var iq:IQ = new IQ( service, IQ.TYPE_GET );
			var ext:InfoDiscoExtension = new InfoDiscoExtension( iq.xml );
			ext.node = node;
			iq.callback = callback;
			iq.errorCallback = errorCallback;
			iq.addExtension( ext );
			_connection.send( iq );
			return iq;
		}

		/**
		 *
		 * @param	service
		 * @param	node
		 * @param	callback
		 * @param	errorCallback
		 * @return org.igniterealtime.xiff.data.IQ
		 * @see http://xmpp.org/extensions/xep-0030.html#items-nodes
		 */
		public function getNodeItems( service:EscapedJID, node:String, callback:Function, errorCallback:Function = null ):IIQ
		{
			var iq:IQ = new IQ( service, IQ.TYPE_GET );
			var ext:ItemDiscoExtension = new ItemDiscoExtension( iq.xml );
			ext.node = node;
			iq.callback = callback;
			iq.errorCallback = errorCallback;
			iq.addExtension( ext );
			_connection.send( iq );
			return iq;
		}

		/**
		 * Retrieves a list of available service information from the server specified. On successful query,
		 * the callback specified will be called and passed a single parameter containing
		 * a reference to an <code>IQ</code> containing the query results.
		 *
		 * <pre>
		 * <iq to="192.168.1.37" type="get" id="iq_4">
		 *  <query xmlns="http://jabber.org/protocol/disco#info"/>
		 * </iq>
		 * </pre>
		 *
		 * @param	server The server to query for available service information
		 * @param	callback The callback function to call when results are retrieved
		 * @param	errorCallback The callback function to call when errors are received
		 * @return org.igniterealtime.xiff.data.IQ
		 * @see http://xmpp.org/extensions/xep-0030.html#info
		 */
		public function getServiceInfo( server:EscapedJID, callback:Function, errorCallback:Function = null ):IIQ
		{
			var iq:IQ = new IQ( server, IQ.TYPE_GET );
			iq.callback = callback;
			iq.errorCallback = errorCallback;
			iq.addExtension( new InfoDiscoExtension( iq.xml ) );
			_connection.send( iq );
			return iq;
		}

		/**
		 * Retrieves a list of available services items from the server specified. Items include things such
		 * as available transports and user directories. On successful query, the callback specified in the will be
		 * called and passed a single parameter containing the query results.
		 *
		 * <pre>
		 * <iq to="192.168.1.37" type="get" id="iq_3">
		 *	<query xmlns="http://jabber.org/protocol/disco#items"/>
		 * </iq>
		 * </pre>
		 *
		 * @param	server The server to query for service items
		 * @param	callback The callback function to call when results are retrieved
		 * @param	errorCallback The callback function to call when errors are received
		 * @return org.igniterealtime.xiff.data.IQ
		 * @see http://xmpp.org/extensions/xep-0030.html#items
		 */
		public function getServiceItems( server:EscapedJID, callback:Function, errorCallback:Function = null ):IIQ
		{
			var iq:IQ = new IQ( server, IQ.TYPE_GET );
			iq.callback = callback;
			iq.errorCallback = errorCallback;
			iq.addExtension( new ItemDiscoExtension( iq.xml ) );
			_connection.send( iq );
			return iq;
		}

		/**
		 * Use the <strong>OBSOLETE</strong> <code>BrowseExtension</code> (jabber:iq:browse namespace)
		 * to query a resource for supported features and children.
		 *
		 * @param	id The full JabberID to query for service items
		 * @param	callback The callback function to call when results are retrieved
		 * @param	errorCallback The callback function to call when errors are received
		 * @return org.igniterealtime.xiff.data.IQ
		 * @see http://xmpp.org/extensions/xep-0011.html
		 */
		public function browseItem( id:EscapedJID, callback:Function, errorCallback:Function = null ):IIQ
		{
			var iq:IQ = new IQ( id, IQ.TYPE_GET );
			iq.callback = callback;
			iq.errorCallback = errorCallback;
			iq.addExtension( new BrowseExtension( iq.xml ) );
			_connection.send( iq );
			return iq;
		}

		/**
		 * The instance of the XMPPConnection class to use for sending and
		 * receiving data.
		 */
		public function get connection():IXMPPConnection
		{
			return _connection;
		}
		public function set connection( value:IXMPPConnection ):void
		{
			_connection = value;
			_connection.enableExtensions(
				ItemDiscoExtension,
				InfoDiscoExtension,
				BrowseExtension
			);
		}
	}

}
