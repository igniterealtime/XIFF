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
	import org.jivesoftware.xiff.data.Message;
	
	import org.jivesoftware.xiff.conference.Room;
	import org.jivesoftware.xiff.conference.InviteListener;
	
	public class xiffPort extends Sprite
	{
		internal var _conn:XMPPConnection;
		internal var _roster:Roster;
		
		public function xiffPort()
		{
			Security.loadPolicyFile("http://69.45.147.228/crossdomain.xml");
			// temp stuff for debugging
			var r:Room = new Room();
			var l:InviteListener = new InviteListener(_conn);
			
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
			
			var myTimer3:Timer = new Timer(3000,1);
			myTimer3.addEventListener(TimerEvent.TIMER, sendTestMessage);
			myTimer3.start();
		}
		public function updateRoster(event:TimerEvent):void {
            trace("_roster.length: " + _roster.length);
        }
		public function sendTestMessage(event:TimerEvent):void {
			var recipient:String = "lindsey@vaio.lymabean.com";
			var msgID:String=null;
			var msgBody:String="sent from xiffPort";
			var msgHTMLBody:String=null;
			var msgType:String=null;
			var msgSubject:String=null;
            var m:Message = new Message(recipient,msgID,msgBody,msgHTMLBody,msgType,msgSubject);
            _conn.send(m);
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
			_conn.addEventListener(XIFFErrorEvent.XIFF_ERROR,onConnectError);
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
			var m:Message = e.data as Message;
			trace(m.body);
		}
		internal function presenceHandler(e:PresenceEvent):void
		{
			trace("presenceHandler: " + e.type); 
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
		internal function onConnectError(e:XIFFErrorEvent):void
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
