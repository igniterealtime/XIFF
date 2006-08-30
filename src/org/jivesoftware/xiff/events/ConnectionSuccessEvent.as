package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class ConnectionSuccessEvent extends Event
	{
		
		public static var CONNECT_SUCCESS:String = "connection";
		
		public function ConnectionSuccessEvent()
		{
			super(ConnectionSuccessEvent.CONNECT_SUCCESS, false, false);
		}
		
	}
}