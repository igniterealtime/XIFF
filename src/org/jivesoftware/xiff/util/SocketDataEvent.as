package org.jivesoftware.xiff.util
{
	import flash.events.Event;

	public class SocketDataEvent extends Event
	{
		public static var SOCKET_DATA_RECEIVED:String = "socketDataReceived";
		private var _data:String;
		
		public function SocketDataEvent()
		{
			super(SOCKET_DATA_RECEIVED, false, false);
		}
		public function get data() : String
		{
			return _data;
		}
		public function set data( s:String ) : void
		{
			_data = s;
		}
	}
}