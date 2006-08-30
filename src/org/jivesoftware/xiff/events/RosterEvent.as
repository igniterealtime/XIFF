package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class RosterEvent extends Event
	{
		public static var SUBSCRIPTION_REVOCATION:String = "subscriptionRevocation";
		public static var SUBSCRIPTION_REQUEST:String = "subscriptionRequest";
		public static var SUBSCRIPTION_DENIAL:String = "subscriptionDenial";
		public static var USER_AVAILABLE:String = "userAvailable";
		public static var USER_UNAVAILABLE:String = "userUnavailable";
		private var _data:*;
		private var _jid:String;
		
		public function RosterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
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