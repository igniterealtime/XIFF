/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	public class DisconnectionEvent extends Event
	{
		public static const DISCONNECT:String = "disconnection";

		public function DisconnectionEvent()
		{
			super( DisconnectionEvent.DISCONNECT, false, false );
		}

		override public function clone():Event
		{
			return new DisconnectionEvent();
		}

		override public function toString():String
		{
			return '[DisconnectionEvent type="' + type + '" bubbles=' + bubbles +
				' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
