package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class UserAvailableEvent extends Event
	{
		public static var USER_AVAILABLE:String = "userAvailable";
		private var _jid:String;
		private var _data:*;
		public function UserAvailableEvent()
		{
			super(UserAvailableEvent.USER_AVAILABLE, false, false);
		}
		public function get jid():String
		{
			return _jid;
		}
		public function set jid(s:String):void
		{
			_jid = s;
		}
		public function get data():*
		{
			return _data;
		}
		public function set data(d:*):void
		{
			_data = d;
		}
	}
}