/*
 * Copyright (C) 2003-2007
 * Nick Velloff <nick.velloffgmail.com>
 * Derrick Grigg <dgriggrogers.com>
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
	/*
 * License
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.IQ;
	
	public class IQEvent extends Event
	{
		private var _data:IExtension;
		private var _iq:IQ;
		
		public function IQEvent(type:String)
		{
			super(type, false, false);
		}
		override public function clone():Event
		{
			var event:IQEvent = new IQEvent(type);
			event.data = _data;
			event.iq = _iq;
			return event;
		}
		override public function toString():String
		{
			return '[IQEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
		public function get data():IExtension
		{
			return _data;
		}
		public function set data(x:IExtension):void
		{
			_data = x;
		}
		public function get iq():IQ
		{
			return _iq;
		}
		public function set iq(i:IQ):void
		{
			_iq = i;
		}
	}
}
