package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	import org.jivesoftware.xiff.data.register.RegisterExtension;

	public class RegistrationFieldsEvent extends Event
	{
		public static var REG_FIELDS:String = "registrationFields";
		private var _fields:Array;
		private var _data:RegisterExtension;
		
		public function RegistrationFieldsEvent()
		{
			super(RegistrationFieldsEvent.REG_FIELDS, false, false);
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