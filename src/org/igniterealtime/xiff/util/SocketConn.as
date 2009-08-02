/*
 * License
 */
package org.igniterealtime.xiff.util
{
	import flash.events.ProgressEvent;
	import flash.net.Socket;

	/**
	 * Utility to make the use of Socket easier.
	 */
	public class SocketConn extends Socket
	{

		/**
		 * Seems to be unused, but why is it here?
		 */
		private var input:String = "";

		/**
		 *
		 * @param host
		 * @param port
		 */
		public function SocketConn( host:String = null, port:int = 0 )
		{
			super( host, port );
			addEventListener( ProgressEvent.SOCKET_DATA, onRead );
		}

		/**
		 *
		 * @param output
		 */
		public function sendString( output:String ):void
		{
			writeUTFBytes( output );
			flush();
		}

		/**
		 *
		 * @param event
		 */
		private function onRead( event:ProgressEvent ):void
		{
			var s:String = readUTFBytes( bytesAvailable );
			onSockRead( s );
		}

		/**
		 *
		 * @param s
		 */
		private function onSockRead( s:String ):void
		{
			var event:SocketDataEvent = new SocketDataEvent();
			event.data = s;
			dispatchEvent( event );
		}
	}
}