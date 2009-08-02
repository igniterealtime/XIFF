/*
 * License
 */
package org.igniterealtime.xiff.util
{
	import flash.events.Event;

	/**
	 *
	 */
	public class SocketDataEvent extends Event
	{
		/**
		 * 
		 */
		public static const SOCKET_DATA_RECEIVED:String = "socketDataReceived";

		/**
		 * Data of this event, if any
		 */
		private var _data:String;

		/**
		 *
		 */
		public function SocketDataEvent()
		{
			super( SOCKET_DATA_RECEIVED, false, false );
		}

		/**
		 * Data of this event, if any
		 */
		public function get data():String
		{
			return _data;
		}
		public function set data( s:String ):void
		{
			_data = s;
		}
	}
}