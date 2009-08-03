/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	public class ModelChangedEvent extends Event
	{
		public static const MODEL_CHANGED:String = "modelChanged";

		private var _fieldName:String;

		private var _firstItem:String;

		private var _lastItem:String;

		private var _removedIDs:String;

		public function ModelChangedEvent()
		{
			super( ModelChangedEvent.MODEL_CHANGED, false, false );
		}

		override public function clone():Event
		{
			var event:ModelChangedEvent = new ModelChangedEvent();
			event.firstItem = _firstItem;
			event.lastItem = _lastItem;
			event.removedIDs = _removedIDs;
			event.fieldName = _fieldName;
			return event;
		}

		public function get fieldName():String
		{
			return _fieldName;
		}

		public function set fieldName( s:String ):void
		{
			_fieldName = s;
		}

		public function get firstItem():String
		{
			return _firstItem;
		}

		public function set firstItem( s:String ):void
		{
			_firstItem = s;
		}

		public function get lastItem():String
		{
			return _lastItem;
		}

		public function set lastItem( s:String ):void
		{
			_lastItem = s;
		}

		public function get removedIDs():String
		{
			return _removedIDs;
		}

		public function set removedIDs( s:String ):void
		{
			_removedIDs = s;
		}

		override public function toString():String
		{
			return '[ModelChangedEvent type="' + type + '" bubbles=' + bubbles +
				' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}

