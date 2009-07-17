package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class BookmarkRetrievedEvent extends Event
	{
		public static var BOOKMARK_RETRIEVED:String = "bookmark retrieved";
		
		public function BookmarkRetrievedEvent() {
			super(BOOKMARK_RETRIEVED);
		}
		override public function clone():Event
		{
			return new BookmarkRetrievedEvent();
		}
		override public function toString():String
		{
			return '[BookmarkRetrievedEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
