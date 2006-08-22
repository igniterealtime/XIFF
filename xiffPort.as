package {
	import flash.display.Sprite;
	
	import org.jivesoftware.xiff.core.XMPPConnection;
	import org.jivesoftware.xiff.events.*;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import org.jivesoftware.xiff.im.Roster;
	import org.jivesoftware.xiff.data.muc.*;
	import org.jivesoftware.xiff.data.im.RosterExtension;
	
	public class xiffPort extends Sprite
	{
		internal var _conn:XMPPConnection;
		internal var _roster:Roster;
		
		public function xiffPort()
		{
			Security.loadPolicyFile("http://69.45.147.228/crossdomain.xml");
			
			setupXMPPConnection();
			setupConnectionListeners();
			setupRosterListeners();
			setupPresenceListeners();
			setupMessageListeners();
			
			var myTimer:Timer = new Timer(200,1);
			myTimer.addEventListener(TimerEvent.TIMER, connect);
			myTimer.start();
			
			var myTimer2:Timer = new Timer(3000,1);
			myTimer2.addEventListener(TimerEvent.TIMER, updateRoster);
			myTimer2.start();
		}
		// test stuff \\
		public function updateRoster(event:TimerEvent):void {
            trace("_roster.length: " + _roster.length);
        }
		
		public function connect(event:TimerEvent):void {
            _conn.connect("flash");
        }
		internal function setupXMPPConnection() : void
		{
			_conn = new XMPPConnection();
			_conn.username = "nick";
			_conn.password = "1492nick";
			_conn.server = "69.45.147.228";
		}
		internal function setupConnectionListeners() : void
		{
			_conn.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,onConnectSuccess);
			_conn.addEventListener(ErrorEvent.XIFF_ERROR,onConnectError);
			_conn.addEventListener(OutgoingDataEvent.OUTGOING_DATA,onOutgoingData)
			_conn.addEventListener(IncomingDataEvent.INCOMING_DATA,onIncomingData);
			_conn.addEventListener(DisconnectionEvent.DISCONNECT,onDisconnect);
			_conn.addEventListener(LoginEvent.LOGIN,onLogin);
		}
		internal function setupRosterListeners() : void
		{
			_roster = new Roster();
			_roster.connection = _conn;
			_roster.addEventListener(RosterEvent.SUBSCRIPTION_DENIAL, rosterHandler);
			_roster.addEventListener(RosterEvent.SUBSCRIPTION_REQUEST, rosterHandler);
			_roster.addEventListener(RosterEvent.SUBSCRIPTION_REVOCATION, rosterHandler);
			_roster.addEventListener(RosterEvent.USER_AVAILABLE, rosterHandler);
			_roster.addEventListener(RosterEvent.USER_UNAVAILABLE, rosterHandler);
			
			_conn.addEventListener(RosterExtension.NS, rosterUpdate);
			
		}
		internal function setupPresenceListeners() : void
		{
			_conn.addEventListener(PresenceEvent.PRESENCE,presenceHandler);
		}
		internal function setupMessageListeners() : void
		{
			_conn.addEventListener(MessageEvent.MESSAGE,messageHandler);
		}
		
		// Event handlers
		internal function messageHandler(e:MessageEvent):void
		{
			trace("messageHandler: " + e.type); 
		}
		internal function presenceHandler(e:PresenceEvent):void
		{
			trace("presenceHandler: " + e.type); 
		}
		internal function rosterUpdate(e:Event):void
		{
			trace("rosterUpdate: " + e.type); 
		}
		internal function rosterHandler(e:RosterEvent):void
		{
			trace("rosterHandler: " + e.type); 
		}
		internal function onLogin(e:LoginEvent):void
		{
			trace("onLogin"); 
		}
		internal function onConnectSuccess(e:ConnectionSuccessEvent):void
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
	}
}
/*
	private function registerEvents() : Void{
		_conn.addEventListener("outgoingData", Delegate.create(this,outgoingData) );
		_conn.addEventListener("incomingData", Delegate.create(this,incomingData) );
		_conn.addEventListener("message", Delegate.create(this,messageReceived) );
		_conn.addEventListener("presence", Delegate.create(this,presenceReceived) );
		_conn.addEventListener("login", Delegate.create(this,loginSuccess) );
		_conn.addEventListener("disconnection", Delegate.create(this,disconnection) );
		_conn.addEventListener("connection", Delegate.create(this,connection) );
		_conn.addEventListener("rosterUpdate",Delegate.create(this,rosterUpdate));
		_conn.addEventListener("error",Delegate.create(this,connectionErrorHandler));
		_conn.addEventListener("changePasswordSuccess",Delegate.create(this,changePasswordSuccess));
		_conn.addEventListener("registrationFields",Delegate.create(this,registrationFields));
		_conn.addEventListener("registrationSuccess",Delegate.create(this,registrationSuccess));
	}
*/

