package org.jivesoftware.xiff.utility
{
	import flash.events.Event;

	public class DataProviderEvent extends Event
	{
		public static var MODEL_CHANGED:String = "modelChanged";
		private var _eventName:String;
		private var _firstItem:uint;
		private var _lastItem:uint;
		private var _removedItems:Array;
		private var _fieldName:String;
		
		public function DataProviderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function get firstItem():uint
		{
			return _firstItem;
		}
		public function set firstItem(u:uint):void
		{
			_firstItem = u;
		}
		public function get lastItem():uint
		{
			return _lastItem;
		}
		public function set lastItem(u:uint):void
		{
			_lastItem = u;
		}
		public function get removedItems():Array
		{
			return _removedItems;
		}
		public function set removedItems(a:Array):void
		{
			_removedItems = a;
		}
		public function get eventName():String
		{
			return _eventName;
		}
		public function set eventName(s:String):void
		{
			_eventName = s;
		}
		public function get fieldName():String
		{
			return _fieldName;
		}
		public function set fieldName(s:String):void
		{
			_fieldName = s;
		}
	}
}