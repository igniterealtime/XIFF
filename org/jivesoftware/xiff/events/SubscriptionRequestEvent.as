package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class SubscriptionRequestEvent extends Event
	{
		public static var SUBSCRIPTION_REQUEST:String = "subscriptionRequest";
		private var _jid:String;
		public function SubscriptionRequestEvent()
		{
			super(SubscriptionRequestEvent.SUBSCRIPTION_REQUEST, false, false);
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