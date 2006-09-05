package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	import org.jivesoftware.xiff.data.Presence;

	public class PresenceEvent extends Event
	{
		
		public static var PRESENCE:String = "presence";
		private var _data:Presence;
		
		public function PresenceEvent()
		{
			super(PresenceEvent.PRESENCE, bubbles, cancelable);
		}
		public function get data():Presence
		{
			return _data;
		}
		public function set data(p:Presence):void
		{
			_data = p;
		}
	}
}