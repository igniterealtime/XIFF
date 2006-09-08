package org.jivesoftware.xiff.util
{
	import flash.net.Socket;
	import flash.events.ProgressEvent;

	public class SocketConn extends Socket
	{
		
		private var input: String;
		
		public function SocketConn(host:String=null, port:int=0.0)
		{
			super(host, port);
			addEventListener(ProgressEvent.SOCKET_DATA, onRead);		
			input = '';
		}
		
		private function onRead( event: ProgressEvent ): void
		{
			var s:String = readUTFBytes(bytesAvailable);
			onSockRead( s );
		}
		
		public function sendString( output: String ): void
		{
			writeUTFBytes( output );
			flush();
		}
		
		private function onSockRead( s:String ) : void
		{
			var e:SocketDataEvent = new SocketDataEvent();
			e.data = s;
			dispatchEvent(e);
		}
	}
}