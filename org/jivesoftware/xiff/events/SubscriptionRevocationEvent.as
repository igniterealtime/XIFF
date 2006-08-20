package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class SubscriptionRevocationEvent extends Event
	{
		public static var SUBSCRIPTION_REVOCATION:String = "subscriptionRevocation";
		private var _jid:String;
		public function SubscriptionRevocationEvent()
		{
			super(SubscriptionRevocationEvent.SUBSCRIPTION_REVOCATION, false, false);
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