package com.yourpalmark.chat
{
	import com.hurlant.crypto.tls.TLSConfig;
	import com.hurlant.crypto.tls.TLSEngine;
	import com.yourpalmark.chat.data.ChatUser;
	import com.yourpalmark.chat.data.LoginCredentials;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import org.igniterealtime.xiff.auth.*;
	import org.igniterealtime.xiff.collections.ArrayCollection;
	import org.igniterealtime.xiff.collections.events.CollectionEvent;
	import org.igniterealtime.xiff.conference.InviteListener;
	import org.igniterealtime.xiff.core.*;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.Presence;
	import org.igniterealtime.xiff.data.im.RosterItemVO;
	import org.igniterealtime.xiff.data.muc.MUC;
	import org.igniterealtime.xiff.events.*;
	import org.igniterealtime.xiff.im.Roster;
	import org.igniterealtime.xiff.util.Zlib;

	public class ChatManager extends EventDispatcher
	{
		[Bindable]
		public static var serverName:String = "talk.google.com";

		[Bindable]
		public static var serverPort:int = 5222;
		
		[Bindable]
		public static var compress:Boolean = false;
		
		[Bindable]
		public static var useTls:Boolean = false;
		
		[Bindable]
		public static var facebookAppId:String = "FACEBOOK_APP_ID";
		
		
		private const KEEP_ALIVE_TIME:int = 30000;

		protected var registerUser:Boolean;
		protected var registrationData:Object;
		protected var keepAliveTimer:Timer;

		protected var _connection:XMPPTLSConnection;
		protected var _inviteListener:InviteListener;
		protected var _inbandRegister:InBandRegistrator;
		protected var _roster:Roster;
		protected var _chatUserRoster:ArrayCollection;
		protected var _currentUser:ChatUser;

		public function ChatManager()
		{
			setupConnection();
			setupInviteListener();
			setupInBandRegistrator();
			setupRoster();
			setupChat();
			setupCurrentUser();
			registerSASLMechanisms();
			setupTimer();
		}

		public static function isValidJID( jid:UnescapedJID ):Boolean
		{
			var value:Boolean = false;
			var pattern:RegExp = /(\w|[_.\-])+@(localhost$|((\w|-)+\.)+\w{2,4}$){1}/;
			var result:Object = pattern.exec( jid.toString() );

			if( result )
			{
				value = true;
			}
			return value;
		}

		public function get connection():XMPPTLSConnection
		{
			return _connection;
		}

		public function get inviteListener():InviteListener
		{
			return _inviteListener;
		}

		public function get inbandRegister():InBandRegistrator
		{
			return _inbandRegister;
		}

		public function get roster():Roster
		{
			return _roster;
		}

		public function get chatUserRoster():ArrayCollection
		{
			return _chatUserRoster;
		}

		public function get currentUser():ChatUser
		{
			return _currentUser;
		}

		public function get conferenceServer():String
		{
			return "conference." + _connection.server;
		}

		public function setFBAuthProperties( appID:String, accessToken:String ):void
		{
			XFacebookPlatform.fb_app_id = appID;
			XFacebookPlatform.fb_access_token = accessToken;
		}

		public function connect( credentials:LoginCredentials ):void
		{
			var domainIndex:int = credentials.username.lastIndexOf( "@" );
			var username:String = domainIndex > -1 ? credentials.username.substring( 0, domainIndex ) : credentials.username;
			var domain:String = domainIndex > -1 ? credentials.username.substring( domainIndex + 1 ) : null;

			Security.loadPolicyFile( "xmlsocket://" + ChatManager.serverName + ":" + ChatManager.serverPort );
			registerUser = false;
			connection.tls = ChatManager.useTls;
			connection.username = XFacebookPlatform.fb_app_id != null ? "u" + username : username;
			connection.password = credentials.password;
			connection.domain = domain;
			connection.server = ChatManager.serverName;
			connection.port = ChatManager.serverPort;
			connection.connect();
		}

		public function disconnect():void
		{
			connection.disconnect();
			_roster.removeAll();
			setupCurrentUser();
		}

		public function updatePresence( show:String, status:String ):void
		{
			roster.setPresence( show, status, 0 );
		}

		public function register( credentials:LoginCredentials ):void
		{
			registerUser = true;

			connection.username = null;
			connection.password = null;

			connection.server = serverName;
			connection.connect();

			registrationData = {};
			registrationData.username = credentials.username;
			registrationData.password = credentials.password;
		}

		public function addBuddy( jid:UnescapedJID ):void
		{
			roster.addContact( jid, jid.toString(), "Buddies", true );
		}

		public function removeBuddy( rosterItem:RosterItemVO ):void
		{
			roster.removeContact( rosterItem );
		}

		public function updateGroup( rosterItem:RosterItemVO, groupName:String ):void
		{
			roster.updateContactGroups( rosterItem, [ groupName ] );
		}

		protected function setupConnection():void
		{
			_connection = new XMPPTLSConnection();
			_connection.compressor = new Zlib();
			var config:TLSConfig = new TLSConfig( TLSEngine.CLIENT );
			config.ignoreCommonNameMismatch = true;
			_connection.config = config;
			addConnectionListeners();
		}

		protected function addConnectionListeners():void
		{
			_connection.addEventListener( ConnectionSuccessEvent.CONNECT_SUCCESS, onConnectSuccess );
			_connection.addEventListener( DisconnectionEvent.DISCONNECT, onDisconnect );
			_connection.addEventListener( LoginEvent.LOGIN, onLogin );
			_connection.addEventListener( XIFFErrorEvent.XIFF_ERROR, onXIFFError );
			_connection.addEventListener( OutgoingDataEvent.OUTGOING_DATA, onOutgoingData );
			_connection.addEventListener( IncomingDataEvent.INCOMING_DATA, onIncomingData );
			_connection.addEventListener( PresenceEvent.PRESENCE, onPresence );
			_connection.addEventListener( MessageEvent.MESSAGE, onMessage );
		}

		protected function removeConnectionListeners():void
		{
			_connection.removeEventListener( ConnectionSuccessEvent.CONNECT_SUCCESS, onConnectSuccess );
			_connection.removeEventListener( DisconnectionEvent.DISCONNECT, onDisconnect );
			_connection.removeEventListener( LoginEvent.LOGIN, onLogin );
			_connection.removeEventListener( XIFFErrorEvent.XIFF_ERROR, onXIFFError );
			_connection.removeEventListener( OutgoingDataEvent.OUTGOING_DATA, onOutgoingData );
			_connection.removeEventListener( IncomingDataEvent.INCOMING_DATA, onIncomingData );
			_connection.removeEventListener( PresenceEvent.PRESENCE, onPresence );
			_connection.removeEventListener( MessageEvent.MESSAGE, onMessage );
		}

		protected function setupInviteListener():void
		{
			_inviteListener = new InviteListener();
			_inviteListener.addEventListener( InviteEvent.INVITED, onInvited );
			_inviteListener.connection = _connection;
		}

		protected function setupInBandRegistrator():void
		{
			_inbandRegister = new InBandRegistrator();
			_inbandRegister.addEventListener( RegistrationFieldsEvent.REG_FIELDS, onRegistrationFields );
			_inbandRegister.addEventListener( RegistrationSuccessEvent.REGISTRATION_SUCCESS, onRegistrationSuccess );
			_inbandRegister.connection = _connection;
		}

		protected function setupRoster():void
		{
			_roster = new Roster();
			_roster.addEventListener( RosterEvent.ROSTER_LOADED, onRosterLoaded );
			_roster.addEventListener( RosterEvent.SUBSCRIPTION_DENIAL, onSubscriptionDenial );
			_roster.addEventListener( RosterEvent.SUBSCRIPTION_REQUEST, onSubscriptionRequest );
			_roster.addEventListener( RosterEvent.SUBSCRIPTION_REVOCATION, onSubscriptionRevocation );
			_roster.addEventListener( RosterEvent.USER_ADDED, onUserAdded );
			_roster.addEventListener( RosterEvent.USER_AVAILABLE, onUserAvailable );
			_roster.addEventListener( RosterEvent.USER_PRESENCE_UPDATED, onUserPresenceUpdated );
			_roster.addEventListener( RosterEvent.USER_REMOVED, onUserRemoved );
			_roster.addEventListener( RosterEvent.USER_SUBSCRIPTION_UPDATED, onUserSubscriptionUpdated );
			_roster.addEventListener( RosterEvent.USER_UNAVAILABLE, onUserUnavailable );
			_roster.addEventListener( CollectionEvent.COLLECTION_CHANGE, onRosterChange );
			_roster.connection = _connection;

			_chatUserRoster = new ArrayCollection();
		}

		protected function setupChat():void
		{
		}

		protected function setupCurrentUser():void
		{
			_currentUser = new ChatUser( _connection.jid );
		}

		protected function registerSASLMechanisms():void
		{
			// By default only ANONYMOUS and DIGEST-MD5 enabled.
			_connection.enableSASLMechanism( External.MECHANISM, External );
			_connection.enableSASLMechanism( Plain.MECHANISM, Plain );
			_connection.enableSASLMechanism( XFacebookPlatform.MECHANISM, XFacebookPlatform );
			//_connection.enableSASLMechanism( XGoogleToken.MECHANISM, XGoogleToken );
		}

		protected function setupTimer():void
		{
			keepAliveTimer = new Timer( KEEP_ALIVE_TIME );
			keepAliveTimer.addEventListener( TimerEvent.TIMER, onKeepAliveTimer );
		}

		protected function cleanup():void
		{
			removeConnectionListeners();
			setupCurrentUser();
			_chatUserRoster.removeAll();
			keepAliveTimer.stop();
		}

		protected function updateChatUserRoster():void
		{
			var users:Array = [];
			for each( var rosterItem:RosterItemVO in _roster.source )
			{
				var chatUser:ChatUser = new ChatUser( rosterItem.jid );
				chatUser.rosterItem = rosterItem;
				chatUser.loadVCard( _connection );
				users.push( chatUser );
			}
			_chatUserRoster.source = users;
		}


		protected function onConnectSuccess( event:ConnectionSuccessEvent ):void
		{
			if( registerUser )
			{
				_inbandRegister.sendRegistrationFields( registrationData, null );
			}

			dispatchEvent( event );
		}

		protected function onDisconnect( event:DisconnectionEvent ):void
		{
			cleanup();
			setupConnection();
			_roster.connection = _connection;

			dispatchEvent( event );
		}

		protected function onLogin( event:LoginEvent ):void
		{
			setupCurrentUser();
			_currentUser.loadVCard( _connection );
			keepAliveTimer.start();
			dispatchEvent( event );
		}

		protected function onXIFFError( event:XIFFErrorEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onOutgoingData( event:OutgoingDataEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onIncomingData( event:IncomingDataEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onRegistrationFields( event:RegistrationFieldsEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onRegistrationSuccess( event:RegistrationSuccessEvent ):void
		{
			_connection.disconnect();
			dispatchEvent( event );
		}

		protected function onPresence( event:PresenceEvent ):void
		{
			var presence:Presence = event.data[ 0 ] as Presence;

			if( presence.type == Presence.TYPE_ERROR )
			{
				var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
				xiffErrorEvent.errorCode = presence.errorCode;
				xiffErrorEvent.errorCondition = presence.errorCondition;
				xiffErrorEvent.errorMessage = presence.errorMessage;
				xiffErrorEvent.errorType = presence.errorType;
				onXIFFError( xiffErrorEvent );
			}
			else
			{
				dispatchEvent( event );
			}
		}

		protected function onMessage( event:MessageEvent ):void
		{
			var message:Message = event.data as Message;

			if( message.type == Message.TYPE_ERROR )
			{
				var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
				xiffErrorEvent.errorCode = message.errorCode;
				xiffErrorEvent.errorCondition = message.errorCondition;
				xiffErrorEvent.errorMessage = message.errorMessage;
				xiffErrorEvent.errorType = message.errorType;
				onXIFFError( xiffErrorEvent );
			}
			else
			{
				dispatchEvent( event );
			}
		}

		protected function onInvited( event:InviteEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onRosterLoaded( event:RosterEvent ):void
		{
			updateChatUserRoster();

			dispatchEvent( event );
		}

		protected function onSubscriptionDenial( event:RosterEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onSubscriptionRequest( event:RosterEvent ):void
		{
			if( _roster.contains( RosterItemVO.get( event.jid, false ) ) )
			{
				_roster.grantSubscription( event.jid, true );
			}

			dispatchEvent( event );
		}

		protected function onSubscriptionRevocation( event:RosterEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onUserAdded( event:RosterEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onUserAvailable( event:RosterEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onUserPresenceUpdated( event:RosterEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onUserRemoved( event:RosterEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onUserSubscriptionUpdated( event:RosterEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onUserUnavailable( event:RosterEvent ):void
		{
			dispatchEvent( event );
		}

		protected function onRosterChange( event:CollectionEvent ):void
		{
			updateChatUserRoster();
		}

		protected function onKeepAliveTimer( event:TimerEvent ):void
		{
			if( connection.loggedIn )
			{
				connection.sendKeepAlive();
			}
		}

	}
}