/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	import org.igniterealtime.xiff.bookmark.GroupChatBookmark;
	import org.igniterealtime.xiff.bookmark.UrlBookmark;

	/**
	 *
	 */
	public class BookmarkChangedEvent extends Event
	{
		/**
		 *
		 * @default
		 */
		public static const GROUPCHAT_BOOKMARK_ADDED:String = "groupchatBookmarkAdded";

		/**
		 *
		 * @default
		 */
		public static const GROUPCHAT_BOOKMARK_REMOVED:String = "groupchatBookmarkRemoved";

		//add url types here when needed

		/**
		 *
		 * @default
		 */
		public var groupchatBookmark:GroupChatBookmark = null;

		/**
		 *
		 * @default
		 */
		public var urlBookmark:UrlBookmark = null;

		/**
		 *
		 * @param type
		 * @param bookmark
		 */
		public function BookmarkChangedEvent( type:String, bookmark:* )
		{
			super( type );
			if ( bookmark is GroupChatBookmark )
			{
				groupchatBookmark = bookmark as GroupChatBookmark;
			}
			else
			{
				urlBookmark = bookmark as UrlBookmark;
			}
		}

		override public function clone():Event
		{
			var bookmark:* = urlBookmark;
			if ( groupchatBookmark != null )
			{
				bookmark = groupchatBookmark;
			}
			return new BookmarkChangedEvent( type, bookmark );
		}

		override public function toString():String
		{
			return '[BookmarkChangedEvent type="' + type + '" bubbles=' + bubbles +
				' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
