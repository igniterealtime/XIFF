/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *   
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 * 
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.igniterealtime.xiff.data.im
{
	/**
	 * Represents the groups in users roster.
	 */
	public class RosterGroup
	{
		public var label:String;
		public var shared:Boolean = false;
		
		private var _items:Array = [];
		
		/**		
		 * Create a new group with the given name	
		 * @param	name	
		 */		
		public function RosterGroup(name:String)	
		{
			label = name;
		}
		
		/**
		 * Insert a new roster item if it does not already exists in this group	
		 * @param	item
		 */	
		public function addItem(item:RosterItemVO):void	
		{
			if (_items.indexOf(item) == -1)
			{
				_items.push(item);
			}
		}
		
		/**		
		 * Remove the given roster item from this group.
		 * @param	item		
		 */		
		public function removeItem(item:RosterItemVO):void
		{
			var index:int = _items.indexOf(item);
			if (index != -1)
			{
				_items.splice(index, 1);
			}
		}
		
		/**
		 * Does the given item exists in this group?
		 * @param	item
		 * @return		
		 */		
		public function contains(item:RosterItemVO):Boolean	
		{
			var value:Boolean = false;
			var index:int = _items.indexOf(item);	
			if (index != -1)	
			{			
				value = true;	
			}		
			return value;	
		}
		
		/**
		 * Roster items in this group.	
		 */	
		public function get items():Array
		{
			return _items;
		}
	}
}