package {
	import flash.display.Sprite;
	
	import org.jivesoftware.xiff.core.XMPPConnection;
	import org.jivesoftware.xiff.events.*;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import org.jivesoftware.xiff.im.Roster;
	
	public class xiffPort extends Sprite
	{
		internal var _conn:XMPPConnection;
		
		public function xiffPort()
		{
			Security.loadPolicyFile("http://69.45.147.228/crossdomain.xml");
			_conn = new XMPPConnection();
			_conn.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,onConnectSuccess);
			_conn.addEventListener(ErrorEvent.XIFF_ERROR,onConnectError);
			_conn.addEventListener(OutgoingDataEvent.OUTGOING_DATA,onOutgoingData)
			_conn.addEventListener(IncomingDataEvent.INCOMING_DATA,onIncomingData);
			_conn.addEventListener(DisconnectionEvent.DISCONNECT,onDisconnect);
			_conn.username = "nick";
			_conn.password = "1492nick";
			_conn.server = "69.45.147.228";
			
			
			var myTimer:Timer = new Timer(200,1);
			myTimer.addEventListener("timer", timerHandler);
			myTimer.start();
		}
		public function timerHandler(event:TimerEvent):void {
            _conn.connect("flash");
        }
		
		internal function onConnectSuccess(e:Event):void
		{
			trace("onConnectSuccess"); 
		}
		internal function onDisconnect(d:DisconnectionEvent):void
		{
			trace("onDisconnect"); 
		}
		internal function onConnectError(e:ErrorEvent):void
		{
			trace("onConnectError: " + "type:" + e.errorType + "  message:" + e.errorMessage); 
		}
		internal function onOutgoingData(e:OutgoingDataEvent):void
		{
			trace("onOutgoingData: " + e.data); 
		}
		internal function onIncomingData(e:IncomingDataEvent):void
		{
			trace("onIncomingData: " + e.data); 
		}
		
		internal function setupRoster() : void{
			//_roster = new Roster();
			//_roster.connection = _conn;
			//_roster.addEventListener("subscriptionRevocation",Delegate.create(this,subscriptionRevocation));
			//_roster.addEventListener("subscriptionRequest",Delegate.create(this,subscriptionRequest));
			//_roster.addEventListener("subscriptionDenial",Delegate.create(this,subscriptionDenial));
			//_roster.addEventListener("userUnavailable",Delegate.create(this,userUnavailable)); // possibly remove and use presence
			//_roster.addEventListener("userAvailable",Delegate.create(this,userAvailable)); // possibly remove and use presence
		}
		
	}
}

        

