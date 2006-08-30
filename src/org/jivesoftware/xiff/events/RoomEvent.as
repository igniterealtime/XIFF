package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	import org.jivesoftware.xiff.data.Message;

	public class RoomEvent extends Event
	{
		public static var SUBJECT_CHANGE:String = "subjectChange";
		public static var GROUP_MESSAGE:String = "groupMessage";
		public static var PRIVATE_MESSAGE:String = "privateMessage";
		public static var ROOM_JOIN:String = "roomJoin";
		public static var ROOM_LEAVE:String = "roomLeave";
		public static var AFFILIATIONS:String = "affiliations";
		public static var ADMIN_ERROR:String = "adminError";
		public static var USER_JOIN:String = "userJoin";
		public static var USER_DEPARTURE:String = "userDeparture";
		public static var NICK_CONFLICT:String = "nickConflict";
		public static var CONFIGURE_ROOM:String = "configureForm";
		public static var DECLINED:String = "declined";
		
		private var _subject:String;
		private var _message:Message;
		private var _data:*;
		private var _errorCondition:String;
		private var _errorMessage:String;
		private var _errorType:String;
		private var _errorCode:Number;
		private var _nickname:String;
		private var _from:String;
		private var _reason:String;
		
		public function RoomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function set subject(s:String) : void
		{
			_subject = s;
		}
		public function get subject() : String
		{
			return _subject;
		}
		public function set message(s:Message) : void
		{
			_message = s;
		}
		public function get message() : Message
		{
			return _message;
		}
		public function set data(s:*) : void
		{
			_data = s;
		}
		public function get data() : *
		{
			return _data;
		}
		public function set errorCondition(s:String) : void
		{
			_errorCondition = s;
		}
		public function get errorCondition() : String
		{
			return _errorCondition;
		}
		public function set errorMessage(s:String) : void
		{
			_errorMessage = s;
		}
		public function get errorMessage() : String
		{
			return _errorMessage;
		}
		public function set errorType(s:String) : void
		{
			_errorType = s;
		}
		public function get errorType() : String
		{
			return _errorType;
		}
		public function set errorCode(s:Number) : void
		{
			_errorCode = s;
		}
		public function get errorCode() : Number
		{
			return _errorCode;
		}
		public function set nickname(s:String) : void
		{
			_nickname = s;
		}
		public function get nickname() : String
		{
			return _nickname;
		}
		public function set from(s:String) : void
		{
			_from = s;
		}
		public function get from() : String
		{
			return _from;
		}
		public function set reason(s:String) : void
		{
			_reason = s;
		}
		public function get reason() : String
		{
			return _reason;
		}
	}
}