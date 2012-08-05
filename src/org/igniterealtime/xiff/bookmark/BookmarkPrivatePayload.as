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
package org.igniterealtime.xiff.bookmark
{
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.XMLStanza;
	import org.igniterealtime.xiff.privatedata.IPrivatePayload;

	/**
	 * XEP-0048: Bookmarks
	 *
	 * @see http://xmpp.org/extensions/xep-0048.html
	 */
	public class BookmarkPrivatePayload extends XMLStanza implements IPrivatePayload
	{
		public static const NS:String = "storage:bookmarks";
		public static const ELEMENT_NAME:String = "storage";

		private var _groupChatBookmarks:Array = [];

		private var _others:Array = [];

		private var _urlBookmarks:Array = [];

		/**
		 *
		 * @param	groupChatBookmarks
		 * @param	urlBookmarks
		 */
		public function BookmarkPrivatePayload( groupChatBookmarks:Array = null,
												urlBookmarks:Array = null )
		{

			xml.setLocalName( ELEMENT_NAME );
			xml.setNamespace( NS );

			if ( groupChatBookmarks )
			{
				for each ( var bookmark:GroupChatBookmark in groupChatBookmarks )
				{
					if ( _groupChatBookmarks.every( function( testGroupChatBookmark:GroupChatBookmark,
															  index:int, array:Array ):Boolean
						{
							return testGroupChatBookmark.jid != bookmark.jid;
						}))
						_groupChatBookmarks.push( bookmark );
				}
			}
			if ( urlBookmarks )
			{
				for each ( var urlBookmark:UrlBookmark in urlBookmarks )
				{
					if ( _urlBookmarks.every( function( testURLBookmark:UrlBookmark,
														index:int, array:Array ):Boolean
						{
							return testURLBookmark.url != urlBookmark.url;
						}))
						_urlBookmarks.push( urlBookmark );
				}
			}
		}



		override public function set xml( bookmarks:XML ):void
		{
			super.xml = bookmarks;

			for each ( var child:XML in bookmarks.children() )
			{
				if ( child.localName() == "conference" )
				{
					var groupChatBookmark:GroupChatBookmark = new GroupChatBookmark(new EscapedJID("temp@temp.tmp"));
					groupChatBookmark.xml = child;

					//don't add it if it's a duplicate
					if ( _groupChatBookmarks.every( function( testGroupChatBookmark:GroupChatBookmark,
															  index:int, array:Array ):Boolean
						{
							return testGroupChatBookmark.jid != groupChatBookmark.jid;
						}))
						_groupChatBookmarks.push( groupChatBookmark );
				}
				else if ( child.localName() == "url" )
				{
					var urlBookmark:UrlBookmark = new UrlBookmark("temp");
					urlBookmark.xml =  child;

					//don't add it if it's a duplicate
					if ( _urlBookmarks.every( function( testURLBookmark:UrlBookmark,
														index:int, array:Array ):Boolean
						{
							return testURLBookmark.url != urlBookmark.url;
						}))
						_urlBookmarks.push( urlBookmark );
				}
				else
				{
					_others.push( child );
				}
			}
		}


		public function getElementName():String
		{
			return BookmarkPrivatePayload.ELEMENT_NAME;
		}

		public function getNS():String
		{
			return BookmarkPrivatePayload.NS;
		}

		public function get groupChatBookmarks():Array
		{
			return _groupChatBookmarks.slice();
		}

		/**
		 * Removes the bookmark from the list, and returns it
		 * @param	jid
		 * @return
		 */
		public function removeGroupChatBookmark( jid:UnescapedJID ):GroupChatBookmark
		{
			var removedItem:GroupChatBookmark = null;
			var newBookmarks:Array = [];
			for each ( var bookmark:GroupChatBookmark in _groupChatBookmarks )
			{
				if ( !bookmark.jid.unescaped.equals( jid, false ))
				{
					newBookmarks.push( bookmark );
				}
				else
				{
					removedItem = bookmark;
				}
			}
			_groupChatBookmarks = newBookmarks;
			return removedItem;
		}

		/**
		 * List of UrlBookmarks.
		 *
		 * @see org.igniterealtime.xiff.bookmark.UrlBookmark
		 */
		public function get urlBookmarks():Array
		{
			return _urlBookmarks.slice();
		}
	}
}
