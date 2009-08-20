/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	import org.igniterealtime.xiff.core.UnescapedJID;

	public class RosterEvent extends Event
	{
		public static const ROSTER_LOADED:String = "rosterLoaded";

		public static const SUBSCRIPTION_DENIAL:String = "subscriptionDenial";

		public static const SUBSCRIPTION_REQUEST:String = "subscriptionRequest";

		public static const SUBSCRIPTION_REVOCATION:String = "subscriptionRevocation";

		public static const USER_ADDED:String = 'userAdded';

		public static const USER_AVAILABLE:String = "userAvailable";

		public static const USER_PRESENCE_UPDATED:String = 'userPresenceUpdated';

		public static const USER_REMOVED:String = 'userRemoved';

		public static const USER_SUBSCRIPTION_UPDATED:String = 'userSubscriptionUpdated';

		public static const USER_UNAVAILABLE:String = "userUnavailable";

		private var _data:*;

		private var _jid:UnescapedJID;

		public function RosterEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

		override public function clone():Event
		{
			var event:RosterEvent = new RosterEvent( type, bubbles, cancelable );
			event.data = _data;
			event.jid = _jid;
			return event;
		}

		/**
		 * Data can be of type:
		 * <ul>
		 * <li><code>Presence</code></li>
		 * <li><code>RosterItemVO</code></li>
		 * <li>...</li>
		 * </ul>
		 * @see org.igniterealtime.xiff.data.Presence
		 * @see org.igniterealtime.xiff.data.im.RosterItemVO
		 */
		public function get data():*
		{
			return _data;
		}

		public function set data( value:* ):void
		{
			_data = value;
		}

		public function get jid():UnescapedJID
		{
			return _jid;
		}

		public function set jid( value:UnescapedJID ):void
		{
			_jid = value;
		}

		override public function toString():String
		{
			return '[RosterEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
