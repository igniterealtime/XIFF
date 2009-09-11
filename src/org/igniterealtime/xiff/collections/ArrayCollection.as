package org.igniterealtime.xiff.collections
{
	import flash.events.EventDispatcher;
	
	import org.igniterealtime.xiff.collections.events.CollectionEvent;
	import org.igniterealtime.xiff.collections.events.CollectionEventKind;
	
	/**
	 * The ArrayCollection class is a wrapper class that exposes an Array as a
	 * collection that can be accessed and manipulated using collection methods.
	 */
	public class ArrayCollection extends EventDispatcher
	{
		protected const OUT_OF_BOUNDS_MESSAGE:String = "The supplied index is out of bounds.";
		
		protected var _source:Array = [];
		
		/**
		 * Constructor.
		 */
		public function ArrayCollection( source:Array = null )
		{
			super();
			
			if (source)
			{
				this.source = source;
			}
		}
		
		/**
		 * The source of data in the ArrayCollection.
		 */
		public function get source():Array
		{
			return _source;
		}
		
		/**
		 * @private
		 */
		public function set source( value:Array ):void
		{
			_source = value ? value : [];
			internalDispatchEvent( CollectionEventKind.RESET );
		}
		
		/**
		 * The number of items in the ArrayCollection.
		 */
		public function get length():int
		{
			return _source ? _source.length : 0;
		}
		
		/**
		 * Get the item at the specified index.
		 */
		public function getItemAt( index:int ):*
		{
			if ( index < 0 || index >= length )
			{
				throw new RangeError( OUT_OF_BOUNDS_MESSAGE );
			}
			
			return _source[ index ];
		}
		
		/**
		 * Places the item at the specified index.
		 * If an item was already at that index the new item will replace it
		 * and it will be returned.
		 */
		public function setItemAt( item:*, index:int ):*
		{
			if ( index < 0 || index >= length )
			{
				throw new RangeError( OUT_OF_BOUNDS_MESSAGE );
			}
			
			var replaced:* = _source.splice( index, 1, item )[ 0 ];
			internalDispatchEvent( CollectionEventKind.REPLACE, item, index );
			return replaced;
		}
		
		/**
		 * Add the specified item to the end of the list.
		 * Equivalent to addItemAt( item, length );
		 */
		public function addItem( item:* ):void
		{
			addItemAt( item, length );
		}
		
		/**
		 * Add the specified item at the specified index.
		 * Any item that was after this index is moved out by one.
		 */
		public function addItemAt( item:*, index:int ):void
		{
			if ( index < 0 || index > length )
			{
				throw new RangeError( OUT_OF_BOUNDS_MESSAGE );
			}
			
			_source.splice( index, 0, item );
			
			internalDispatchEvent( CollectionEventKind.ADD, item, index );
		}
		
		/**
		 * Get the index of the item if it is in the ArrayCollection such that getItemAt( index ) == item.
		 */
		public function getItemIndex( item:* ):int
		{
			var n:int = _source.length;
			
			for ( var i:int = 0; i < n; i++ )
			{
				if ( _source[ i ] === item ) return i;
			}
			
			return -1;
		}
		
		/**
		 * Remove the specified item from this list, should it exist.
		 */
		public function removeItem( item:* ):Boolean
		{
			var index:int = getItemIndex( item );
			var result:Boolean = index >= 0;
			
			if ( result )
			{
				removeItemAt( index );
			}
			
			return result;
		}
		
		/**
		 * Removes the item at the specified index and returns it.
		 * Any items that were after this index are now one index earlier.
		 */
		public function removeItemAt( index:int ):*
		{
			if ( index < 0 || index >= length )
			{
				throw new RangeError( OUT_OF_BOUNDS_MESSAGE );
			}
			
			var removed:* = _source.splice( index, 1 )[ 0 ];
			internalDispatchEvent( CollectionEventKind.REMOVE, removed, index );
			return removed;
		}
		
		/**
		 * Remove all items from the ArrayCollection.
		 */
		public function removeAll():void
		{
			if ( length > 0 )
			{
				clearSource();
				internalDispatchEvent( CollectionEventKind.RESET );
			}
		}
		
		/**
		 * Remove all items from the ArrayCollection without dispatching a RESET event.
		 */
		public function clearSource():void
		{
			_source.splice( 0, length );
		}
		
		/**
		 * Returns whether the ArrayCollection contains the specified item.
		 */
		public function contains( item:* ):Boolean
		{
			return getItemIndex( item ) != -1;
		}
		
		/**
		 * Notifies the view that an item has been updated.
		 */
		public function itemUpdated( item:* ):void
		{
			internalDispatchEvent( CollectionEventKind.UPDATE, item );
		}
		
		/**
		 * Return an Array that is populated in the same order as the ArrayCollection.
		 */
		public function toArray():Array
		{
			return _source.concat();
		}
		
		/**
		 * Pretty prints the contents of the ArrayCollection to a string and returns it.
		 */
		override public function toString():String
		{
			if ( _source )
			{
				return _source.toString();
			}
			else
			{
				return super.toString();
			}
		}
		
		/**
		 * Dispatches a collection event with the specified information.
		 */
		protected function internalDispatchEvent( kind:String, item:* = null, location:int = -1 ):void
		{
			var event:CollectionEvent = new CollectionEvent( CollectionEvent.COLLECTION_CHANGE );
			event.kind = kind;
			event.items.push( item );
			event.location = location;
			dispatchEvent( event );
		}
		
	}
}
