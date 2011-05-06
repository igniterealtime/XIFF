package com.yourpalmark.chat.data
{
	import com.yourpalmark.chat.ChatManager;
	
	import flash.events.EventDispatcher;
	
	import org.igniterealtime.xiff.collections.ArrayCollection;
	import org.igniterealtime.xiff.conference.IRoomOccupant;
	import org.igniterealtime.xiff.conference.Room;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.muc.MUCItem;
	import org.igniterealtime.xiff.events.PresenceEvent;
	import org.igniterealtime.xiff.events.RoomEvent;
	import org.igniterealtime.xiff.events.XIFFErrorEvent;
	
	public class ChatRoom extends EventDispatcher
	{
		private var _chatManager:ChatManager;
		private var _room:Room;
		private var _users:ArrayCollection;
		private var _owners:ArrayCollection;
		private var _admins:ArrayCollection;
		private var _moderators:ArrayCollection;
		private var _outcasts:ArrayCollection;
		
		public function ChatRoom()
		{
			_room = new Room();
			addRoomListeners();
			
			_users = new ArrayCollection();
			_owners = new ArrayCollection();
			_admins = new ArrayCollection();
			_moderators = new ArrayCollection();
			_outcasts = new ArrayCollection();
		}
		
		public function get chatManager():ChatManager { return _chatManager; }
		public function set chatManager( value:ChatManager ):void
		{
			if( _chatManager ) _chatManager.removeEventListener( PresenceEvent.PRESENCE, onPresence );
			_chatManager = value;
			if( _chatManager ) _chatManager.addEventListener( PresenceEvent.PRESENCE, onPresence );
		}
		
		public function get room():Room { return _room; }
		
		public function get users():ArrayCollection { return _users; }
		
		public function get owners():ArrayCollection { return _owners; }
		
		public function get admins():ArrayCollection { return _admins; }
		
		public function get moderators():ArrayCollection { return _moderators; }
		
		public function get outcasts():ArrayCollection { return _outcasts; }
		
		public function create( roomName:String ):void
		{
			if( !_chatManager ) return;
			
			_room.nickname = _chatManager.currentUser.displayName;
			_room.roomJID = new UnescapedJID( roomName + "@" + _chatManager.conferenceServer );
			_room.roomName = roomName;
			_room.connection = _chatManager.connection;
			
			_room.join( true );
		}
		
		public function join( roomJID:UnescapedJID ):void
		{
			if( !_chatManager ) return;
			
			_room.nickname = _chatManager.currentUser.displayName;
			_room.roomJID = roomJID;
			_room.connection = _chatManager.connection;
			
			_room.join();
		}
		
		public function leave( disconnect:Boolean=false ):void
		{
			_users.removeAll();
			_owners.removeAll();
			_admins.removeAll();
			_moderators.removeAll();
			_outcasts.removeAll();
			_room.leave();
			_room = new Room();
			if( disconnect && _chatManager ) _chatManager.disconnect();
		}
		
		public function destroy( reason:String, alternateJID:UnescapedJID=null, callback:Function=null, disconnect:Boolean=false ):void
		{
			_users.removeAll();
			_owners.removeAll();
			_admins.removeAll();
			_moderators.removeAll();
			_outcasts.removeAll();
			_room.destroy( reason, alternateJID, callback );
			_room = new Room();
			if( disconnect && _chatManager ) _chatManager.disconnect();
		}
		
		public function sendMessage( body:String ):void
		{
			_room.sendMessage( body );
		}
		
		private function removeUserByNickname( nickname:String ):ChatUser
		{
			var chatUser:ChatUser;
			var removed:Boolean;
			for each( var user:ChatUser in _users.source )
			{
				if( user.displayName == nickname )
				{
					chatUser = user;
					break;
				}
			}
			
			if( chatUser )
			{
				removed = _users.removeItem( chatUser );
				if( removed ) return chatUser;
			}
			
			return null;
		}
		
		private function requestAffiliations( affiliation:String ):void
		{
			if( _room.role ==  Room.ROLE_MODERATOR )
			{
				if( affiliation == Room.AFFILIATION_OWNER ) _owners.removeAll();
				if( affiliation == Room.AFFILIATION_ADMIN ) _admins.removeAll();
				if( affiliation == Room.AFFILIATION_OUTCAST ) _outcasts.removeAll();
				_room.requestAffiliations( affiliation );
			}
		}
		
		private function addRoomListeners():void
		{
			_room.addEventListener( RoomEvent.GROUP_MESSAGE, onGroupMessage, false, 0, true );
			_room.addEventListener( RoomEvent.ADMIN_ERROR, onAdminError, false, 0, true );
			_room.addEventListener( RoomEvent.AFFILIATION_CHANGE_COMPLETE, onAffiliationChangeComplete, false, 0, true );
			_room.addEventListener( RoomEvent.AFFILIATIONS, onAffiliations, false, 0, true );
			_room.addEventListener( RoomEvent.CONFIGURE_ROOM, onConfigureRoom, false, 0, true );
			_room.addEventListener( RoomEvent.CONFIGURE_ROOM_COMPLETE, onConfigureRoomComplete, false, 0, true );
			_room.addEventListener( RoomEvent.DECLINED, onDeclined, false, 0, true );
			_room.addEventListener( RoomEvent.NICK_CONFLICT, onNickConflict, false, 0, true );
			_room.addEventListener( RoomEvent.PRIVATE_MESSAGE, onPrivateMessage, false, 0, true );
			_room.addEventListener( RoomEvent.ROOM_DESTROYED, onRoomDestroyed, false, 0, true );
			_room.addEventListener( RoomEvent.ROOM_JOIN, onRoomJoin, false, 0, true );
			_room.addEventListener( RoomEvent.ROOM_LEAVE, onRoomLeave, false, 0, true );
			_room.addEventListener( RoomEvent.SUBJECT_CHANGE, onSubjectChange, false, 0, true );
			_room.addEventListener( RoomEvent.USER_DEPARTURE, onUserDeparture, false, 0, true );
			_room.addEventListener( RoomEvent.USER_JOIN, onUserJoin, false, 0, true );
			_room.addEventListener( RoomEvent.USER_KICKED, onUserKicked, false, 0, true );
			_room.addEventListener( RoomEvent.USER_BANNED, onUserBanned, false, 0, true );
		}
		
		private function removeRoomListeners():void
		{
			_room.removeEventListener( RoomEvent.GROUP_MESSAGE, onGroupMessage );
			_room.removeEventListener( RoomEvent.ADMIN_ERROR, onAdminError );
			_room.removeEventListener( RoomEvent.AFFILIATION_CHANGE_COMPLETE, onAffiliationChangeComplete );
			_room.removeEventListener( RoomEvent.AFFILIATIONS, onAffiliations );
			_room.removeEventListener( RoomEvent.CONFIGURE_ROOM, onConfigureRoom );
			_room.removeEventListener( RoomEvent.CONFIGURE_ROOM_COMPLETE, onConfigureRoomComplete );
			_room.removeEventListener( RoomEvent.DECLINED, onDeclined );
			_room.removeEventListener( RoomEvent.NICK_CONFLICT, onNickConflict );
			_room.removeEventListener( RoomEvent.PRIVATE_MESSAGE, onPrivateMessage );
			_room.removeEventListener( RoomEvent.ROOM_DESTROYED, onRoomDestroyed );
			_room.removeEventListener( RoomEvent.ROOM_JOIN, onRoomJoin );
			_room.removeEventListener( RoomEvent.ROOM_LEAVE, onRoomLeave );
			_room.removeEventListener( RoomEvent.SUBJECT_CHANGE, onSubjectChange );
			_room.removeEventListener( RoomEvent.USER_DEPARTURE, onUserDeparture );
			_room.removeEventListener( RoomEvent.USER_JOIN, onUserJoin );
			_room.removeEventListener( RoomEvent.USER_KICKED, onUserKicked );
			_room.removeEventListener( RoomEvent.USER_BANNED, onUserBanned );
		}
		
		
		private function onGroupMessage( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onAdminError( event:RoomEvent ):void
		{
			var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
			xiffErrorEvent.errorCode = event.errorCode;
			xiffErrorEvent.errorCondition = event.errorCondition;
			xiffErrorEvent.errorMessage = event.errorMessage;
			xiffErrorEvent.errorType = event.errorType;
			dispatchEvent( xiffErrorEvent );
		}
		
		private function onAffiliationChangeComplete( event:RoomEvent ):void
		{
			requestAffiliations( Room.AFFILIATION_ADMIN );
			requestAffiliations( Room.AFFILIATION_OUTCAST );
		}
		
		private function onAffiliations( event:RoomEvent ):void
		{
			var mucItems:Array = event.data as Array;
			
			for each( var muc:MUCItem in mucItems )
			{
				var chatUser:ChatUser = new ChatUser( muc.jid.unescaped );
				chatUser.displayName = muc.nick;
				chatUser.loadVCard( _chatManager.connection );
				
				if( muc.affiliation == Room.AFFILIATION_OWNER )
				{
					_owners.addItem( chatUser );
				}
				if( muc.affiliation == Room.AFFILIATION_ADMIN )
				{
					_admins.addItem( chatUser );
				}
				else if(  muc.affiliation == Room.AFFILIATION_OUTCAST )
				{
					_outcasts.addItem( chatUser );
				}
			}
			
			dispatchEvent( event );
		}
		
		private function onConfigureRoom( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onConfigureRoomComplete( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onDeclined( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onNickConflict( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onPrivateMessage( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onRoomDestroyed( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onRoomJoin( event:RoomEvent ):void
		{
			requestAffiliations( Room.AFFILIATION_ADMIN );
			requestAffiliations( Room.AFFILIATION_OUTCAST );
			
			dispatchEvent( event );
		}
		
		private function onRoomLeave( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onSubjectChange( event:RoomEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function onUserDeparture( event:RoomEvent ):void
		{
			removeUserByNickname( event.nickname );
			
			dispatchEvent( event );
		}
		
		private function onUserJoin( event:RoomEvent ):void
		{
			var occupant:IRoomOccupant = room.getOccupantNamed( event.nickname );
			if( !occupant ) return;
			
			var chatUser:ChatUser = new ChatUser( occupant.jid );
			chatUser.displayName = event.nickname;
			
			for each( var user:ChatUser in _users.source )
			{
				if( user.displayName == event.nickname )
				{
					return;
				}
			}
			
			chatUser.loadVCard( _chatManager.connection );
			_users.addItem( chatUser );
			
			dispatchEvent( event );
		}
		
		private function onUserKicked( event:RoomEvent ):void
		{
			removeUserByNickname( event.nickname );
			
			dispatchEvent( event );
		}
		
		private function onUserBanned( event:RoomEvent ):void
		{
			removeUserByNickname( event.nickname );
			
			requestAffiliations( Room.AFFILIATION_OUTCAST );
			
			dispatchEvent( event );
		}
		
		private function onPresence( event:PresenceEvent ):void
		{
			dispatchEvent( event );
		}
		
	}
}