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
		 * @default
		 */
		public static const SOCKET_DATA_RECEIVED:String = "socketDataReceived";

		/**
		 *
		 * @default
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
		 *
		 * @return
		 */
		public function get data():String
		{
			return _data;
		}

		/**
		 *
		 * @param s
		 */
		public function set data( s:String ):void
		{
			_data = s;
		}
	}
}