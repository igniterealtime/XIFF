/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	import org.igniterealtime.xiff.data.Extension;

	/**
	 *
	 */
	public class XIFFErrorEvent extends Event
	{
		/**
		 *
		 * @default
		 */
		public static const XIFF_ERROR:String = "error";

		/**
		 *
		 * @default
		 */
		private var _errorCode:Number;

		/**
		 *
		 * @default
		 */
		private var _errorCondition:String;

		/**
		 *
		 * @default
		 */
		private var _errorExt:Extension;

		/**
		 *
		 * @default
		 */
		private var _errorMessage:String;

		/**
		 *
		 * @default
		 */
		private var _errorType:String;

		/**
		 *
		 */
		public function XIFFErrorEvent()
		{
			super( XIFFErrorEvent.XIFF_ERROR, false, false );
		}

		override public function clone():Event
		{
			var event:XIFFErrorEvent = new XIFFErrorEvent();
			event.errorCondition = _errorCondition;
			event.errorMessage = _errorMessage;
			event.errorType = _errorType;
			event.errorCode = _errorCode;
			event.errorExt = _errorExt;
			return event;
		}

		/**
		 *
		 */
		public function get errorCode():Number
		{
			return _errorCode;
		}
		public function set errorCode( n:Number ):void
		{
			_errorCode = n;
		}

		/**
		 *
		 */
		public function get errorCondition():String
		{
			return _errorCondition;
		}
		public function set errorCondition( s:String ):void
		{
			_errorCondition = s;
		}

		/**
		 *
		 */
		public function get errorExt():Extension
		{
			return _errorExt;
		}
		public function set errorExt( ext:Extension ):void
		{
			_errorExt = ext;
		}

		/**
		 *
		 */
		public function get errorMessage():String
		{
			return _errorMessage;
		}
		public function set errorMessage( s:String ):void
		{
			_errorMessage = s;
		}

		/**
		 *
		 */
		public function get errorType():String
		{
			return _errorType;
		}
		public function set errorType( s:String ):void
		{
			_errorType = s;
		}

		override public function toString():String
		{
			return '[XIFFErrorEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
