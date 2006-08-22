package org.jivesoftware.xiff.utility
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.DataEvent;

	public class DataProvider extends Array implements IEventDispatcher
	{
		private var evD:EventDispatcher;
		
		public function DataProvider(numElements:int=0)
		{
			super(numElements);
			evD = new EventDispatcher();
		}
		// MM Methods pulled from mx.listclasses.DataProvider and ported
	
	
		public function addItemAt(index:uint, value:*) : void
		{
			if (index<length) {
				splice(index, 0, value);
			} else if (index>length) {
				trace("Cannot add an item past the end of the DataProvider");
				return;
			}
			this[index] = value;
	
			updateViews( "addItems", index, index);
		}
		
		public function addItem(value:*) : void
		{
			addItemAt(this.length, value);
		}
		
		public function addItemsAt(index:uint, newItems:Array) : void
		{
			index = Math.min(length, index);
			newItems.unshift(index, 0);
			splice.apply(this, newItems);
			newItems.splice(0, 2);
			updateViews( "addItems", index, index+newItems.length-1 );
		}
		public function removeItemsAt(index:uint, len:uint) : void
		{
			var oldItems:Array = this.splice(index, len);
			var event:DataProviderEvent = new DataProviderEvent(DataProviderEvent.MODEL_CHANGED);
			event.eventName = "removeItems";
			event.firstItem = index;
			event.lastItem = index+len-1;
			event.removedItems = oldItems;
			dispatchEvent(event);
		}
		public function removeItemAt(index:uint):uint
		{
			var ret:uint = this[index];
			removeItemsAt(index, 1);
			return ret;
		}
		public function removeAll() : void
		{
			this.splice(0);
			updateViews("removeItems", 0, length-1);
		}
		
		public function replaceItemAt(index:uint, itemObj:*) : Boolean
		{
			if (index<0 || index>=length) {
				return false;
			}
			this[index] = itemObj;
			updateViews( "updateItems", index, index );
			return true;
		}
		public function getItemAt(index : uint):*
		{
			return this[index];
		}
		public function sortItemsBy(fieldName:String = null, order:* = null) : void
		{
			if (typeof(order)=="string") {
				var order:String = order as String;
				this.sortOn(fieldName);
				if (order.toUpperCase()=="DESC") {
					this.reverse();
				}
			} else {
				this.sortOn(fieldName, order);
			}
			updateViews( "sort" );
		}
		
		public function sortItems(compareFunc:*, optionFlags:*) : void
		{
			this.sort(compareFunc, optionFlags);
			updateViews( "sort" );
		}
		public function editField(index:uint, fieldName:String, newData:*) : void
		{
			this[index][fieldName] = newData;
			var event:DataProviderEvent = new DataProviderEvent(DataProviderEvent.MODEL_CHANGED);
			event.eventName = "updateField";
			event.firstItem = index;
			event.lastItem = index;
			event.fieldName = fieldName;
			dispatchEvent(event);
		}
		public function getEditingData(index:uint, fieldName:String):String
		{
			return this[index][fieldName];
	
		}
		public function updateViews(eventName:String, first:uint=0, last:uint=0) : void
		{
			var event:DataProviderEvent = new DataProviderEvent(DataProviderEvent.MODEL_CHANGED);
			event.eventName = eventName;
			event.firstItem = first;
			event.lastItem = last;
			dispatchEvent(event);
		}
		
		
		// Event Handling
		public function hasEventListener(type:String):Boolean
		{
			return evD.hasEventListener.apply(null,arguments);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return evD.willTrigger.apply(null,arguments);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
			evD.addEventListener.apply(null,arguments);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			evD.removeEventListener.apply(null,arguments);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return evD.dispatchEvent.apply(null,arguments);;
		}
		
	}
}