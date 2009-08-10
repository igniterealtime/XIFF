/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	public class BookmarkRetrievedEvent extends Event
	{
		public static const BOOKMARK_RETRIEVED:String = "bookmarkRetrieved";

		public function BookmarkRetrievedEvent()
		{
			super( BOOKMARK_RETRIEVED );
		}

		override public function clone():Event
		{
			return new BookmarkRetrievedEvent();
		}

		override public function toString():String
		{
			return '[BookmarkRetrievedEvent type="' + type + '" bubbles=' + bubbles +
				' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
