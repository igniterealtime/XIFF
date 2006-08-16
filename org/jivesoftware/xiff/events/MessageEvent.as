package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	import org.jivesoftware.xiff.data.Message;
	
	public class MessageEvent extends Event
	{
		public static var MESSAGE:String = "message";
		private var _data:Message;
		
		public function MessageEvent()
		{
			super(MessageEvent.MESSAGE, false, false);
		}
		public function get data():Message
		{
			return _data;
		}
		public function set data(m:Message):void
		{
			_data = m;
		}
	}
}