package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	import flash.xml.XMLDocument;

	public class IncomingDataEvent extends Event
	{
		
		public static var INCOMING_DATA:String = "incomingData";
		private var _data:XMLDocument;
		
		public function IncomingDataEvent()
		{
			super(IncomingDataEvent.INCOMING_DATA, false, false);
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