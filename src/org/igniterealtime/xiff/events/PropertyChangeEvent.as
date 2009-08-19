/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	/**
	 * When a property is changed somewhere, someone might be interested to listen its
	 * current and previous values. Currently this is only used in RosterItemVO
	 * in order to replace the Flex counterpart.
	 */
	public class PropertyChangeEvent extends Event
	{
		public static const CHANGE:String = "change";
		
		private var _name:String;
		
		private var _oldValue:*;

		private var _newValue:*;

		public function PropertyChangeEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

		override public function clone():Event
		{
			var event:PropertyChangeEvent = new PropertyChangeEvent( type, bubbles, cancelable );
			event.name = _name;
			event.newValue = _newValue;
			event.oldValue = _oldValue;
			return event;
		}

		public function get name():*
		{
			return _name;
		}

		public function set name( value:* ):void
		{
			_name = value;
		}

		public function get newValue():*
		{
			return _newValue;
		}

		public function set newValue( value:* ):void
		{
			_newValue = value;
		}

		public function get oldValue():*
		{
			return _oldValue;
		}

		public function set oldValue( value:* ):void
		{
			_oldValue = value;
		}

		override public function toString():String
		{
			return '[PropertyChangeEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
