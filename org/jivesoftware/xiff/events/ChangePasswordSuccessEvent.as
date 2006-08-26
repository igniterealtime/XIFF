package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	public class ChangePasswordSuccessEvent extends Event
	{
		public static var PASSWORD_SUCCESS:String = "changePasswordSuccess";
		
		public function ChangePasswordSuccessEvent()
		{
			super(ChangePasswordSuccessEvent.PASSWORD_SUCCESS, false, false);
		}
	}
}