/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;
	public class ChangePasswordSuccessEvent extends Event
	{
		public static const PASSWORD_SUCCESS:String = "changePasswordSuccess";
		
		public function ChangePasswordSuccessEvent()
		{
			super(ChangePasswordSuccessEvent.PASSWORD_SUCCESS, false, false);
		}
		override public function clone():Event
		{
			return new ChangePasswordSuccessEvent();
		}
		override public function toString():String
		{
			return '[ChangePasswordSuccessEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
