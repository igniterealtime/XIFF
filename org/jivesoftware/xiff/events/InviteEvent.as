package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	import org.jivesoftware.xiff.conference.Room;
	import org.jivesoftware.xiff.data.Message;

	public class InviteEvent extends Event
	{
		public static var INVITED:String = "invited";
		private var _from:String;
		private var _reason:String;
		private var _room:Room;
		private var _data:Message;
		public function InviteEvent()
		{
			super(INVITED);
		}
		public function get from() : String
		{
			return _from;
		}
		public function set from(s:String) : void
		{
			_from = s;
		}
		public function get reason() : String
		{
			return _reason;
		}
		public function set reason(s:String) : void
		{
			_reason = s;
		}
		public function get room() : Room
		{
			return _room;
		}
		public function set room(d:Room) : void
		{
			_room = d;
		}
		public function get data() : Message
		{
			return _data;
		}
		public function set data(d:Message) : void
		{
			_data = d;
		}
	}
}