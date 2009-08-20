/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;

	public class OutgoingDataEvent extends Event
	{

		public static const OUTGOING_DATA:String = "outgoingData";

		private var _data:ByteArray;

		public function OutgoingDataEvent()
		{
			super( OutgoingDataEvent.OUTGOING_DATA, false, false );
		}

		override public function clone():Event
		{
			var event:OutgoingDataEvent = new OutgoingDataEvent();
			event.data = _data;
			return event;
		}

		public function get data():ByteArray
		{
			return _data;
		}

		public function set data( value:ByteArray ):void
		{
			_data = value;
		}

		override public function toString():String
		{
			return '[OutgoingDataEvent type="' + type + '" bubbles=' + bubbles +
				' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
