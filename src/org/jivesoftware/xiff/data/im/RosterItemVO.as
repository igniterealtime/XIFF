package org.jivesoftware.xiff.data.im
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.IPropertyChangeNotifier;
	import mx.events.PropertyChangeEvent;
	
	import org.jivesoftware.xiff.data.Presence;
	
	public class RosterItemVO extends EventDispatcher implements IPropertyChangeNotifier
	{
		//var tempRI:Object = {jid:jid, displayName:displayName, group:group, subscribeType:type, status:status, show:show, priority:null};
		private var _jid: String;
		private var _displayName: String;
		private var _groups:Array = [];
		private var _askType: String;
		private var _subscribeType: String;
		private var _status: String;
		private var _show: String;
		private var _priority: Number;
		
		public function RosterItemVO():void {
			
		}
		
		public function set uid(i:String):void
		{
			
		}
		
		public function get uid():String
		{
			return _jid;
		}
		
		public function set subscribeType(newSub:String):void
		{
			var oldSub:String = subscribeType;
			_subscribeType = newSub;
			PropertyChangeEvent.createUpdateEvent(this, "subscribeType", oldSub, subscribeType);
		}
		
		[Bindable]
		public function get subscribeType():String
		{
			return _subscribeType;
		}
		
		public function set priority(newPriority:Number):void
		{
			var oldPriority:Number = priority;
			_priority = newPriority;
			PropertyChangeEvent.createUpdateEvent(this, "priority", oldPriority, priority);
		}
		
		[Bindable]
		public function get priority():Number
		{
			return _priority;
		}
		
		public function set askType(aT:String):void
		{
			var oldasktype:String = askType;
			var oldPending:Boolean = pending;
			_askType = aT;
			dispatchEvent(new Event("changeAskType"));
			PropertyChangeEvent.createUpdateEvent(this, "askType", oldasktype, askType);
			PropertyChangeEvent.createUpdateEvent(this, "pending", oldPending, pending);
		}
		
		[Bindable]
		public function get askType():String
		{
			return _askType;	
		}
		
		public function set status(newStatus:String):void
		{
			var oldStatus:String = status;
			_status = newStatus;
			PropertyChangeEvent.createUpdateEvent(this, "status", oldStatus, status);
		}
		
		[Bindable]
		public function get status():String
		{
			if(show == Presence.SHOW_OFFLINE)
				return Presence.SHOW_OFFLINE;
			return _status ? _status : "Available";
		}
		
		public function set show(newShow:String):void
		{
			// By default, normal isn't specified, so if null, we will use NORMAL
			newShow = newShow != null ? newShow : Presence.SHOW_NORMAL;
			var oldShow:String = show;
			_show = newShow;
			PropertyChangeEvent.createUpdateEvent(this, "show", oldShow, show);
		}
		
		[Bindable]
		public function get show():String
		{
			return _show;
		}
		
		public function set jid(j:String):void
		{
			var oldjid:String = _jid;
			_jid = j;
			//if we aren't using a custom display name, then settings the jid updates the display name
			if(!_displayName)
				dispatchEvent(new Event("changeDisplayName"));
				
			PropertyChangeEvent.createUpdateEvent(this, "jid", oldjid, j);
		}
		
		[Bindable]
		public function get jid():String
		{
			return _jid;
		}
		
		public function set displayName(name:String):void
		{
			var olddisplayname:String = displayName;
			_displayName = name;
			PropertyChangeEvent.createUpdateEvent(this, "displayName", olddisplayname, displayName);
			dispatchEvent(new Event("changeDisplayName"));
		}
		
		[Bindable(event=changeDisplayName)]
		public function get displayName():String
		{
			return _displayName ? _displayName : node;
		}

		public function addGroup(group:String):void 
		{
			if (group && !containsGroup(group))
			{
				_groups.push(group);
				dispatchEvent(new Event("groupsModified"));
				PropertyChangeEvent.createUpdateEvent(this, "groups", null, groups);
			}
		}
		
		public function set groups(newGroups:Array):void
		{
			if(!newGroups || newGroups.length == 0)
				newGroups = ["General"];
			_groups = newGroups;
			dispatchEvent(new Event("groupsModified"));
			PropertyChangeEvent.createUpdateEvent(this, "groups", null, groups);
		}
		
		[Bindable(event=groupsModified)]
		public function get groups():Array {
			return _groups;
		}
		
		public function containsGroup(group:String):Boolean {
			return groups.indexOf(group) >= 0;
		}
		
		[Bindable(event=changeAskType)]
		public function get pending():Boolean {
			return askType == RosterExtension.ASK_TYPE_SUBSCRIBE && (subscribeType == RosterExtension.SUBSCRIBE_TYPE_NONE || subscribeType == RosterExtension.SUBSCRIBE_TYPE_FROM);
		}
		
	    public function get node():String 
	    {
	        var atIndex:int = _jid.lastIndexOf("@");
	        if (atIndex <= 0)
	            return "";
	        else
	            return _jid.substring(0, atIndex);
	    }

	    public function get server():String 
	    {
	        var atIndex:int = _jid.lastIndexOf("@");
	        // If the String ends with '@', return the empty string.
	        if (atIndex + 1 > _jid.length)
	            return "";
	        var slashIndex:int = _jid.indexOf("/");
	        if (slashIndex > 0 && slashIndex > atIndex)
	            return _jid.substring(atIndex + 1, slashIndex);
	        else
	            return _jid.substring(atIndex + 1);
	    }

	    public function get resource():String 
	    {
	        var slashIndex:int = _jid.indexOf("/");
	        if (slashIndex + 1 > _jid.length || slashIndex < 0)
	            return "";
	        else
	            return _jid.substring(slashIndex + 1);
	    }

	    public function get bareAddress():String 
	    {
	        var slashIndex:int = _jid.indexOf("/");
	        if (slashIndex < 0)
	            return _jid;
	        else if (slashIndex == 0)
	            return "";
	        else
	            return _jid.substring(0, slashIndex);
	    }
	}
}