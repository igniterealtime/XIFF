/*
 * License
 */
package org.igniterealtime.xiff.core
{
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.browse.BrowseExtension;
	import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
	import org.igniterealtime.xiff.data.disco.ItemDiscoExtension;

	/**
	 * This class provides a means of querying for available services on an XMPP
	 * server using the Disco protocol extension. For more information on Disco,
	 * take a look at
	 * <a href="http://xmpp.org/extensions/xep-0030.html">XEP-0030</a> and
	 * <a href="http://xmpp.org/extensions/xep-0011.html">XEP-0011</a> for the
	 * protocol enhancement specifications.
	 */
	public class Browser
	{
		private var _connection:XMPPConnection;

		private var _pending:Object = {};

		private static var _staticDepends:Array = [ ItemDiscoExtension, InfoDiscoExtension,
													BrowseExtension, ExtensionClassRegistry ];

		private static var _isEventEnabled:Boolean = BrowserStaticConstructor();

		/**
		 * Creates a new Browser object.
		 *
		 * @param	aConnection A reference to the <code>XMPPConnection</code> instance
		 * to use.
		 */
		public function Browser( aConnection:XMPPConnection )
		{
			connection = aConnection;
		}

		/**
		 * @private
		 *
		 * Actionscript does not provide static constructors, but this is a
		 * way to get aroudn that.
		 */
		private static function BrowserStaticConstructor():Boolean
		{
			ItemDiscoExtension.enable();
			InfoDiscoExtension.enable();
			BrowseExtension.enable();
			return true;
		}

		public function getNodeInfo( service:EscapedJID, node:String, callback:String, scope:Object ):void
		{
			var iq:IQ = new IQ( service, IQ.GET_TYPE );
			var ext:InfoDiscoExtension = new InfoDiscoExtension( iq.getNode());
			ext.service = service;
			ext.serviceNode = node;
			iq.callbackName = callback;
			iq.callbackScope = scope;
			iq.addExtension( ext );
			_connection.send( iq );
		}

		public function getNodeItems( service:EscapedJID, node:String, callback:String, scope:Object ):void
		{
			var iq:IQ = new IQ( service, IQ.GET_TYPE );
			var ext:ItemDiscoExtension = new ItemDiscoExtension( iq.getNode());
			ext.service = service;
			ext.serviceNode = node;
			iq.callbackName = callback;
			iq.callbackScope = scope;
			iq.addExtension( ext );
			_connection.send( iq );
		}

		/**
		 * Retrieves a list of available service information from the server specified. On successful query,
		 * the callback specified will be called and passed a single parameter containing
		 * a reference to an <code>IQ</code> containing the query results.
		 *
		 * @param	server The server to query for available service information
		 * @param	callback The name of a callback function to call when results are retrieved
		 * @param	scope The scope of the callback function
		 */
		public function getServiceInfo( server:EscapedJID, callback:String, scope:Object ):void
		{
			var iq:IQ = new IQ( server, IQ.GET_TYPE );
			iq.callbackName = callback;
			iq.callbackScope = scope;
			iq.addExtension( new InfoDiscoExtension( iq.getNode()));
			_connection.send( iq );
		}

		/**
		 * Retrieves a list of available services items from the server specified. Items include things such
		 * as available transports and user directories. On successful query, the callback specified in the will be
		 * called and passed a single parameter containing the query results.
		 *
		 * @param	server The server to query for service items
		 * @param	callback The name of a callback function to call when results are retrieved
		 * @param	scope The scope of the callback function
		 */
		public function getServiceItems( server:EscapedJID, callback:String, scope:Object ):void
		{
			var iq:IQ = new IQ( server, IQ.GET_TYPE );
			iq.callbackName = callback;
			iq.callbackScope = scope;
			iq.addExtension( new ItemDiscoExtension( iq.getNode()));
			_connection.send( iq );
		}

		/**
		 * Use the <code>BrowseExtension</code> (jabber:iq:browse namespace) to query a
		 * resource for supported features and children.
		 *
		 * @param	id The full JabberID to query for service items
		 * @param	callback The name of a callback function to call when results are retrieved
		 * @param	scope The scope of the callback function
		 */
		public function browseItem( id:EscapedJID, callback:String, scope:Object ):void
		{
			var iq:IQ = new IQ( id, IQ.GET_TYPE );
			iq.callbackName = callback;
			iq.callbackScope = scope;
			iq.addExtension( new BrowseExtension( iq.getNode()));
			_connection.send( iq );
		}

		/**
		 * The instance of the XMPPConnection class to use for sending and
		 * receiving data.
		 */
		public function get connection():XMPPConnection
		{
			return _connection;
		}
		public function set connection( value:XMPPConnection ):void
		{
			_connection = value;
		}
	}

}
