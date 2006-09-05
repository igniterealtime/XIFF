package org.jivesoftware.xiff.events
{
	import flash.events.Event;
	import org.jivesoftware.xiff.data.IExtension;
	import org.jivesoftware.xiff.data.IQ;
	
	public class IQEvent extends Event
	{
		private var _data:IExtension;
		private var _iq:IQ;
		
		public function IQEvent(type:String)
		{
			super(type, false, false);
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