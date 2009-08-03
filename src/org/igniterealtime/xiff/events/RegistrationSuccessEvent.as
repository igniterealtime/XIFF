/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	public class RegistrationSuccessEvent extends Event
	{
		public static const REGISTRATION_SUCCESS:String = "registrationSuccess";

		public function RegistrationSuccessEvent()
		{
			super( RegistrationSuccessEvent.REGISTRATION_SUCCESS, false, false );
		}

		override public function clone():Event
		{
			return new RegistrationSuccessEvent();
		}

		override public function toString():String
		{
			return '[RegistrationSuccessEvent type="' + type + '" bubbles=' + bubbles +
				' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
