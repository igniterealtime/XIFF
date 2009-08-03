/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	public class ConnectionSuccessEvent extends Event
	{
		public static const CONNECT_SUCCESS:String = "connection";

		public function ConnectionSuccessEvent()
		{
			super( ConnectionSuccessEvent.CONNECT_SUCCESS, false, false );
		}

		override public function clone():Event
		{
			return new ConnectionSuccessEvent();
		}

		override public function toString():String
		{
			return '[ConnectionSuccessEvent type="' + type + '" bubbles=' + bubbles +
				' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
