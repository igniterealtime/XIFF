/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;
	import flash.xml.XMLDocument;

	public class IncomingDataEvent extends Event
	{
		public static const INCOMING_DATA:String = "incomingData";
		private var _data:XMLDocument;
		
		public function IncomingDataEvent()
		{
			super(IncomingDataEvent.INCOMING_DATA, false, false);
		}
		override public function clone():Event
		{
			var event:IncomingDataEvent = new IncomingDataEvent();
			event.data = _data;
			return event;
		}
		override public function toString():String
		{
			return '[IncomingDataEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
		public function get data():XMLDocument
		{
			return _data;
		}
		public function set data(x:XMLDocument):void
		{
			_data = x;
		}
	}
}
