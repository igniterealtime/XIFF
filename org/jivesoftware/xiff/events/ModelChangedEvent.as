package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class ModelChangedEvent extends Event
	{
		public static var MODEL_CHANGED:String = "modelChanged";
		private var _firstItem:String;
		private var _lastItem:String;
		private var _removedIDs:String;
		private var _fieldName:String;
		public function ModelChangedEvent()
		{
			super(ModelChangedEvent.MODEL_CHANGED, false, false);
		}
		public function set firstItem(s:String):void
		{
			_firstItem = s;
		}
		public function get firstItem():String
		{
			return _firstItem;
		}
		public function set lastItem(s:String):void
		{
			_lastItem = s;
		}
		public function get lastItem():String
		{
			return _lastItem;
		}
		public function set removedIDs(s:String):void
		{
			_removedIDs = s;
		}
		public function get removedIDs():String
		{
			return _removedIDs;
		}
		public function set fieldName(s:String):void
		{
			_fieldName = s;
		}
		public function get fieldName():String
		{
			return _fieldName;
		}
	}
}
					