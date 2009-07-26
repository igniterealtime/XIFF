/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;
	import org.igniterealtime.xiff.data.*;

	public class PresenceEvent extends Event
	{
		
		public static const PRESENCE:String = "presence";
		private var _data:Array;
		
		public function PresenceEvent()
		{
			super(PresenceEvent.PRESENCE, bubbles, cancelable);
		}
		override public function clone():Event
		{
			var event:PresenceEvent = new PresenceEvent();
			event.data = _data;
			return event;
		}
		override public function toString():String
		{
			return '[PresenceEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
		public function get data():Array
		{
			return _data;
		}
		public function set data(p:Array):void
		{
			_data = p;
		}
	}
}
