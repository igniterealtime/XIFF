package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class RegistrationSuccessEvent extends Event
	{
		
		public static var REGISTRATION_SUCCESS:String = "registrationSuccess";
		
		public function RegistrationSuccessEvent()
		{
			super(RegistrationSuccessEvent.REGISTRATION_SUCCESS, false, false);
		}
		
	}
}