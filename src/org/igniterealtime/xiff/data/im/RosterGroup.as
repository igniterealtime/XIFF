/*
 * License
 */
package org.igniterealtime.xiff.data.im
{
	/*
	 * Copyright (C) 2008
	 * Jive Software

	 */
	 
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class RosterGroup extends ArrayCollection
	{
		public var label:String;
		public var shared:Boolean = false;
		
		public function RosterGroup(l:String)
		{
			var s:Sort = new Sort();
		    s.fields = [new SortField("displayName", true)];
		    sort = s;
		    refresh();
			label = l;
		}
		
		public override function addItem(item:Object):void
		{
			if(!item is RosterItemVO)
				throw new Error("Assertion Failure: attempted to add something other than a RosterItemVO to a RosterGroup");
			if(source.indexOf(item) == -1)
				super.addItem(item);
		}
		
		public function removeItem(item:RosterItemVO):void
		{
			var itemIndex:int = getItemIndex(item);
			if(itemIndex >= 0)
				removeItemAt(itemIndex);
			else
			{
				itemIndex =	source.indexOf(item);
				if(itemIndex >= 0)
					source.splice(itemIndex, 1);
			}
		}
		
		public override function set filterFunction(f:Function):void
		{
			throw new Error("Setting the filterFunction on RosterGroup is not allowed; Wrap it in a ListCollectionView and filter that.");
		}

		private function sortContacts(item1:RosterItemVO, item2:RosterItemVO, fields:Array = null):int
		{
			if(item1.displayName.toLowerCase() < item2.displayName.toLowerCase())
				return -1;
			else if(item1.displayName.toLowerCase() > item2.displayName.toLowerCase())
				return 1;
			return 0;
		}
	}
}