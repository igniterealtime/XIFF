package org.igniterealtime.xiff.collections.events
{
	import flash.events.Event;

	/**
	 *  The CollectionEvent class represents an event that is
	 *  dispatched when the associated collection changes.
	 */
	public class CollectionEvent extends Event
	{
		/**
		 *  The CollectionEvent.COLLECTION_CHANGE constant defines the value of the
		 *  type property of the event object for an event that is
		 *  dispatched when a collection has changed.
		 */
		public static const COLLECTION_CHANGE:String = "collectionChange";

		/**
		 * Constructor.
		 */
		public function CollectionEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false, kind:String=null, location:int=-1, oldLocation:int=-1, items:Array=null )
		{
			super( type, bubbles, cancelable );

			this.kind = kind;
			this.location = location;
			this.oldLocation = oldLocation;
			this.items = items ? items : [];
		}

		/**
		 *  Indicates the kind of event that occurred.
		 */
		public var kind:String;

		//----------------------------------
		//  items
		//----------------------------------

		/**
		 *  When the kind is CollectionEventKind.ADD
		 *  or CollectionEventKind.REMOVE the items property
		 *  is an Array of added/removed items.
		 *  When the kind is CollectionEventKind.REPLACE
		 *  or CollectionEventKind.UPDATE the items property
		 *  is an Array of PropertyChangeEvent objects with information about the items
		 *  affected by the event.
		 *  When a value changes, query the newValue and
		 *  oldValue fields of the PropertyChangeEvent objects
		 *  to find out what the old and new values were.
		 *  When the kind is CollectionEventKind.REFRESH
		 *  or CollectionEventKind.RESET, this array has zero length.
		 */
		public var items:Array;

		/**
		 *  When the kind value is CollectionEventKind.ADD,
		 *  CollectionEventKind.MOVE,
		 *  CollectionEventKind.REMOVE, or
		 *  CollectionEventKind.REPLACE, this property is the
		 *  zero-base index in the collection of the item(s) specified in the
		 *  items property.
		 */
		public var location:int;

		/**
		 *  When the kind value is CollectionEventKind.MOVE,
		 *  this property is the zero-based index in the target collection of the
		 *  previous location of the item(s) specified by the items property.
		 */
		public var oldLocation:int;

		/**
		 *  @private
		 */
		override public function toString():String
		{
			return formatToString( "CollectionEvent", "kind", "location", "oldLocation", "type", "bubbles", "cancelable", "eventPhase" );
		}

		/**
		 *  @private
		 */
		override public function clone():Event
		{
			return new CollectionEvent( type, bubbles, cancelable, kind, location, oldLocation, items );
		}

	}
}
