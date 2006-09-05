package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	
	public class DisconnectionEvent extends Event
	{
		
		public static var DISCONNECT:String = "disconnection";
		
		public function DisconnectionEvent()
		{
			super(DisconnectionEvent.DISCONNECT, false, false);
		}
		
	}
}