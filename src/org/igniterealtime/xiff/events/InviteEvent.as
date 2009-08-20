/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	import org.igniterealtime.xiff.conference.Room;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.data.Message;

	public class InviteEvent extends Event
	{
		public static const INVITED:String = "invited";

		private var _data:Message;

		private var _from:UnescapedJID;

		private var _reason:String;

		private var _room:Room;

		public function InviteEvent()
		{
			super( INVITED );
		}

		override public function clone():Event
		{
			var event:InviteEvent = new InviteEvent();
			event.from = _from;
			event.reason = _reason;
			event.room = _room;
			event.data = _data;
			return event;
		}

		public function get data():Message
		{
			return _data;
		}

		public function set data( value:Message ):void
		{
			_data = value;
		}

		public function get from():UnescapedJID
		{
			return _from;
		}

		public function set from( value:UnescapedJID ):void
		{
			_from = value;
		}

		public function get reason():String
		{
			return _reason;
		}

		public function set reason( value:String ):void
		{
			_reason = value;
		}

		public function get room():Room
		{
			return _room;
		}

		public function set room( value:Room ):void
		{
			_room = value;
		}

		override public function toString():String
		{
			return '[InviteEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
