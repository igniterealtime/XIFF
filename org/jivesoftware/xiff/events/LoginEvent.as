package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class LoginEvent extends Event
	{
		public static var LOGIN:String = "login";
		
		public function LoginEvent()
		{
			super(LoginEvent.LOGIN, false, false);
		}
		
	}
}