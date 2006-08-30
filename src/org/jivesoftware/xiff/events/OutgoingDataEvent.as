package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	import flash.xml.XMLDocument;

	public class OutgoingDataEvent extends Event
	{
		
		public static var OUTGOING_DATA:String = "outgoingData";
		private var _data:*;
		
		public function OutgoingDataEvent()
		{
			super(OutgoingDataEvent.OUTGOING_DATA, false, false);
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