package org.igniterealtime.xiff.events
{
	import flash.events.Event;
	
	public class SearchPrepEvent extends Event
	{
		public static const SEARCH_PREP_COMPLETE:String = "searchPrepComplete";
		
		private var _server:String;
		
		public function SearchPrepEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			var event:SearchPrepEvent = new SearchPrepEvent(type, bubbles, cancelable);
			event.server = _server;
			return event;
		}
		override public function toString():String
		{
			return '[SearchPrepEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
		public function get server():String
		{
			return _server;
		}
		public function set server(s:String):void
		{
			_server = s;
		}

	}
}
