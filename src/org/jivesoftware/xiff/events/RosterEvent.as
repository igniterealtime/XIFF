package org.jivesoftware.xiff.events
{
	/*
	 * Copyright (C) 2003-2004 
	 * Nick Velloff <nick.velloff@gmail.com>
	 * Derrick Grigg <dgrigg@rogers.com>
	 * Sean Voisen <sean@mediainsites.com>
	 * Sean Treadway <seant@oncotype.dk>
	 *
	 * This library is free software; you can redistribute it and/or
	 * modify it under the terms of the GNU Lesser General Public
	 * License as published by the Free Software Foundation; either
	 * version 2.1 of the License, or (at your option) any later version.
	 * 
	 * This library is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	 * Lesser General Public License for more details.
	 * 
	 * You should have received a copy of the GNU Lesser General Public
	 * License along with this library; if not, write to the Free Software
	 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
	 *
	 */
	import flash.events.Event;

	public class RosterEvent extends Event
	{
		public static var SUBSCRIPTION_REVOCATION:String = "subscriptionRevocation";
		public static var SUBSCRIPTION_REQUEST:String = "subscriptionRequest";
		public static var SUBSCRIPTION_DENIAL:String = "subscriptionDenial";
		public static var USER_AVAILABLE:String = "userAvailable";
		public static var USER_UNAVAILABLE:String = "userUnavailable";
		private var _data:*;
		private var _jid:String;
		
		public function RosterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public function get jid():String
		{
			return _jid;
		}
		public function set jid(s:String):void
		{
			_jid = s;
		}
		public function get data():*
		{
			return _data;
		}
		public function set data(d:*):void
		{
			_data = d;
		}
	}
}