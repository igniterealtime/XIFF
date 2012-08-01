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
package org.igniterealtime.xiff.message
{
	import flash.events.*;
	
	import org.igniterealtime.xiff.events.*;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.data.message.*;
	import org.igniterealtime.xiff.util.DateTimeParser;
	import org.igniterealtime.xiff.core.*;
	
	/**
	 * Dispatched when pref element is received
	 *
	 * @eventType org.igniterealtime.xiff.events.MessageArchiveEvent.PREF_RECEIVED
	 */
	[Event( name="prefReceived", type="org.igniterealtime.xiff.events.MessageArchiveEvent" )]
	/**
	 * Dispatched when an error related to pref has arrived
	 *
	 * @eventType org.igniterealtime.xiff.events.MessageArchiveEvent.PREF_ERROR
	 */
	[Event( name="prefError", type="org.igniterealtime.xiff.events.MessageArchiveEvent" )]
	/**
	 * Dispatched when server returns successful response once item is removed
	 *
	 * @eventType org.igniterealtime.xiff.events.MessageArchiveEvent.ITEM_REMOVED
	 */
	[Event( name="itemRemoved", type="org.igniterealtime.xiff.events.MessageArchiveEvent" )]
	/**
	 * Dispatched when a collection list is received
	 *
	 * @eventType org.igniterealtime.xiff.events.MessageArchiveEvent.COLLECTION_RECEIVED
	 */
	[Event( name="collectionReceived", type="org.igniterealtime.xiff.events.MessageArchiveEvent" )]
	
	/**
	 * Manager for XEP-0136: Message Archiving
	 *
	 * @see http://xmpp.org/extensions/xep-0136.html
	 */
	public class MessageArchiveManager extends EventDispatcher
	{
		private var _connection:IXMPPConnection;

		/**
		 * Manage client registration and password changing.
		 *
		 * @param	aConnection A reference to the <code>XMPPConnection</code> instance to use.
		 */
		public function MessageArchiveManager( aConnection:IXMPPConnection )
		{
			connection = aConnection;
        }

		/**
		 * Retrieving a List of Collections.
		 *
		 * <p>To request a list of collections, the client sends a <strong>list</strong> element.
		 * The 'start' and 'end' attributes MAY be specified to indicate a date range (the values
		 * of these attributes MUST be UTC and adhere to the DateTime format specified in XEP-0082).
		 * The 'with' attribute MAY specify the JIDs of XMPP entities (see the JID Matching
		 * section of this document).</p>
		 *
		 * <p>If the 'with' attribute is omitted then collections with any JID are returned.
		 * If only 'start' is specified then all collections on or after that date should be
		 * returned. If only 'end' is specified then all collections prior to that date should
		 * be returned.</p>
		 *
		 * <p>The client SHOULD use Result Set Management to limit the number of collections
		 * returned by the server in a single stanza, taking care not to request a page of
		 * collections that is so big it might exceed rate limiting restrictions.</p>
		 */
		public function getCollectionList(withJid:UnescapedJID, start:Date = null, end:Date = null):void
		{
			var iq:IQ = new IQ(null, IQ.TYPE_GET, null, collectionList_callback);
			var ext:ArchiveListExtension = new ArchiveListExtension();
			ext.withJid = withJid;
			ext.start = start;
			ext.end = end;
			iq.addExtension(ext);
			_connection.send(iq);
		}

		/**
		 *
		 * @param	iq
		 */
		protected function collectionList_callback( iq:IQ ):void
		{
			if ( iq.type == IQ.TYPE_RESULT )
			{
				var event:MessageArchiveEvent = new MessageArchiveEvent(MessageArchiveEvent.COLLECTION_RECEIVED);
				dispatchEvent( event );
			}
			else
			{
				// ?
			}
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
				ArchiveAutomaticExtension,
				ArchiveListExtension,
				ArchiveManualExtension,
				ArchivePreferenceExtension
			);
		}
	}

}
