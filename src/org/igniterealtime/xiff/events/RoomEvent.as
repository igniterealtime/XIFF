/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	public class RoomEvent extends Event
	{
		public static const ADMIN_ERROR:String = "adminError";

		public static const AFFILIATIONS:String = "affiliations";

		public static const BANNED_ERROR:String = "bannedError";

		public static const CONFIGURE_ROOM:String = "configureForm";

		public static const DECLINED:String = "declined";

		public static const GROUP_MESSAGE:String = "groupMessage";

		public static const LOCKED_ERROR:String = "lockedError";

		public static const MAX_USERS_ERROR:String = "maxUsersError";

		public static const NICK_CONFLICT:String = "nickConflict";

		public static const PASSWORD_ERROR:String = "passwordError";

		public static const PRIVATE_MESSAGE:String = "privateMessage";

		public static const REGISTRATION_REQ_ERROR:String = "registrationReqError";

		public static const ROOM_DESTROYED:String = "roomDestroyed";

		public static const ROOM_JOIN:String = "roomJoin";

		public static const ROOM_LEAVE:String = "roomLeave";

		public static const SUBJECT_CHANGE:String = "subjectChange";

		public static const USER_BANNED:String = "userBanned";

		public static const USER_DEPARTURE:String = "userDeparture";

		public static const USER_JOIN:String = "userJoin";

		public static const USER_KICKED:String = "userKicked";

		private var _data:*;

		private var _errorCode:Number;

		private var _errorCondition:String;

		private var _errorMessage:String;

		private var _errorType:String;

		private var _from:String;

		private var _nickname:String;

		private var _reason:String;

		private var _subject:String;

		public function RoomEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

		override public function clone():Event
		{
			var event:RoomEvent = new RoomEvent( type, bubbles, cancelable );
			event.subject = _subject;
			event.data = _data;
			event.errorCondition = _errorCondition;
			event.errorMessage = _errorMessage;
			event.errorType = _errorType;
			event.errorCode = _errorCode;
			event.nickname = _nickname;
			event.from = _from;
			event.reason = _reason;
			return event;
		}

		public function get data():*
		{
			return _data;
		}

		/**
		 * Data type can be <code>Message</code>, <code>Array</code>, or <code>Presence</code>
		 * depending of the context.
		 * @see org.igniterealtime.xiff.data.Message
		 * @see org.igniterealtime.xiff.data.Presence
		 */
		public function set data( value:* ):void
		{
			_data = value;
		}

		public function get errorCode():Number
		{
			return _errorCode;
		}

		public function set errorCode( value:Number ):void
		{
			_errorCode = value;
		}

		public function get errorCondition():String
		{
			return _errorCondition;
		}

		public function set errorCondition( value:String ):void
		{
			_errorCondition = value;
		}

		public function get errorMessage():String
		{
			return _errorMessage;
		}

		public function set errorMessage( value:String ):void
		{
			_errorMessage = value;
		}

		public function get errorType():String
		{
			return _errorType;
		}

		public function set errorType( value:String ):void
		{
			_errorType = value;
		}

		public function get from():String
		{
			return _from;
		}

		public function set from( value:String ):void
		{
			_from = value;
		}

		public function get nickname():String
		{
			return _nickname;
		}

		public function set nickname( value:String ):void
		{
			_nickname = value;
		}

		public function get reason():String
		{
			return _reason;
		}

		public function set reason( value:String ):void
		{
			_reason = value;
		}

		public function get subject():String
		{
			return _subject;
		}

		public function set subject( value:String ):void
		{
			_subject = value;
		}

		override public function toString():String
		{
			return '[RoomEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
