package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class SubscriptionDenialEvent extends Event
	{
		public static var SUBSCRIPTION_DENIAL:String = "subscriptionDenial";
		private var _jid:String;
		public function SubscriptionDenialEvent()
		{
			super(SubscriptionDenialEvent.SUBSCRIPTION_DENIAL, false, false);
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