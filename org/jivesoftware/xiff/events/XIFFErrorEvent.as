package org.jivesoftware.xiff.events
{
	import flash.events.Event;

	public class XIFFErrorEvent extends Event
	{
		
		public static var XIFF_ERROR:String = "error";
		private var _errorCondition:String;
		private var _errorMessage:String;
		private var _errorType:String;
		private var _errorCode:Number;
		
		public function XIFFErrorEvent()
		{
			super(XIFFErrorEvent.XIFF_ERROR, false, false);
		}
		public function set errorCondition(s:String):void
		{
			_errorCondition = s;
		}
		public function get errorCondition():String
		{
			return _errorCondition;
		}
		public function set errorMessage(s:String):void
		{
			_errorMessage = s;
		}
		public function get errorMessage():String
		{
			return _errorMessage;
		}
		public function set errorType(s:String):void
		{
			_errorType = s;
		}
		public function get errorType():String
		{
			return _errorType;
		}
		public function set errorCode(n:Number):void
		{
			_errorCode = n;
		}
		public function get errorCode():Number
		{
			return _errorCode;
		}
	}
}