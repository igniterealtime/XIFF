/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;
	import org.igniterealtime.xiff.data.register.RegisterExtension;

	public class RegistrationFieldsEvent extends Event
	{
		public static const REG_FIELDS:String = "registrationFields";
		private var _fields:Array;
		private var _data:RegisterExtension;
		
		public function RegistrationFieldsEvent()
		{
			super(RegistrationFieldsEvent.REG_FIELDS, false, false);
		}
		override public function clone():Event
		{
			var event:RegistrationFieldsEvent = new RegistrationFieldsEvent();
			event.data = _data;
			event.fields = _fields;
			return event;
		}
		override public function toString():String
		{
			return '[RegistrationFieldsEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
		public function get fields():Array
		{
			return _fields;
		}
		public function set fields(a:Array):void
		{
			_fields = a;
		}
		public function get data():RegisterExtension
		{
			return _data;
		}
		public function set data(r:RegisterExtension):void
		{
			_data = r;
		}
	}
}
