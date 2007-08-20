package org.jivesoftware.xiff.data.im
{
	public class RosterItemVO
	{
		//var tempRI:Object = {jid:jid, displayName:displayName, group:group, subscribeType:type, status:status, show:show, priority:null};
		[Bindable]
		public var jid: String;
		
		[Bindable]
		public var displayName: String;
		
		
		private var _groups:Array = new Array();
		
		[Bindable]
		public var subscribeType: String;
		
		[Bindable]
		public var status: String;
		
		[Bindable]
		public var show: String;
		
		[Bindable]
		public var priority: Number;
		
		public function RosterItemVO():void {
			
		}
		
		public function addGroup(group:String):void {
			if (group != null && !containsGroup(group)){
				_groups.push(group);
			}
		}
		
		public function get groups():Array {
			return _groups;
		}
		
		public function containsGroup(group:String):Boolean {
			for(var i:int = 0; i<_groups.length; i++){
				if(group == _groups[i]){
					return true;
				}
			}
			
			return false;
		}
	}
}