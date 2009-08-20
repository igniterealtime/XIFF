/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.IQ;

	public class IQEvent extends Event
	{
		private var _data:IExtension;

		private var _iq:IQ;

		public function IQEvent( type:String )
		{
			super( type, false, false );
		}

		override public function clone():Event
		{
			var event:IQEvent = new IQEvent( type );
			event.data = _data;
			event.iq = _iq;
			return event;
		}

		public function get data():IExtension
		{
			return _data;
		}

		public function set data( value:IExtension ):void
		{
			_data = value;
		}

		public function get iq():IQ
		{
			return _iq;
		}

		public function set iq( value:IQ ):void
		{
			_iq = value;
		}

		override public function toString():String
		{
			return '[IQEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
