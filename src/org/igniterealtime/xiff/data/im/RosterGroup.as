/*
 * Copyright (C) 2003-2012 Igniterealtime Community Contributors
 *   
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
 *     Michael McCarthy <mikeycmccarthy@gmail.com>
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
	import org.igniterealtime.xiff.collections.ArrayCollection;
	import org.igniterealtime.xiff.collections.ICollection;
	
	/**
	 * Represents the groups in users roster.
	 */
	public class RosterGroup implements IRosterGroup
	{
		private var _label:String;
		private var _shared:Boolean;
		private var _items:ArrayCollection;
		
		/**
		 * Create a new group with the given name
		 * @param	label
		 */
		public function RosterGroup(label:String)
		{
			this.label = label;
			
			_items = new ArrayCollection();
		}
		
		/**
		 * Insert a new roster item if it does not already exist in this group
		 * @param	item
		 */
		public function addItem( item:IRosterItemVO ):void
		{
			if (!_items.contains(item))
			{
				_items.addItem(item);
			}
		}
		
		/**
		 * Remove the given roster item from this group.
		 * @param	item
		 */
		public function removeItem( item:IRosterItemVO ):Boolean
		{
			return _items.removeItem(item);
		}
		
		/**
		 * Does the given item exist in this group?
		 * @param	item
		 * @return
		 */
		public function contains( item:IRosterItemVO ):Boolean
		{
			return _items.contains(item);
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label( value:String ):void
		{
			_label = value;
		}
		
		public function get shared():Boolean
		{
			return _shared;
		}
		
		public function set shared( value:Boolean ):void
		{
			_shared = value;
		}
		
		/**
		 * Roster items in this group.
		 */
		public function get items():ICollection
		{
			return _items;
		}
	}
}
