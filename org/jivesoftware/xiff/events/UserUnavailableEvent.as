package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class UserUnavailableEvent extends Event
	{
		public static var USER_UNAVAILABLE:String = "userUnavailable";
		private var _jid:String;
		public function UserUnavailableEvent()
		{
			super(UserUnavailableEvent.USER_UNAVAILABLE, false, false);
		}
		public function get jid():String
		{
			return _jid;
		}
		public function set jid(s:String):void
		{
			_jid = s;
		}
	}
}