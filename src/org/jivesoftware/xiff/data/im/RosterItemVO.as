package org.jivesoftware.xiff.data.im
{
	public class RosterItemVO
	{
		//var tempRI:Object = {jid:jid, displayName:displayName, group:group, subscribeType:type, status:status, show:show, priority:null};
		[Bindable]
		public var jid: String;
		
		[Bindable]
		public var displayName: String;
		
		private var _group: String = '';
		
		[Bindable]
		public var subscribeType: String;
		
		[Bindable]
		public var status: String;
		
		[Bindable]
		public var show: String;
		
		[Bindable]
		public var priority: Number;
		
		[Bindable]
		public function set group(value:String):void
		{
			if (value != null)
			{
				_group = value;
			}
		}
		
		public function get group ():String
		{
			return _group;
		}
	}
}