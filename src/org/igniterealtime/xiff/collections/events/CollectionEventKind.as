package org.igniterealtime.xiff.collections.events
{
	/**
	 *  The CollectionEventKind class contains constants for the valid values
	 *  of the CollectionEvent class kind property.
	 */
	public final class CollectionEventKind
	{
		/**
		 *  Indicates that the collection added an item or items.
		 */
		public static const ADD:String = "add";

		/**
		 *  Indicates that the collection removed an item or items.
		 */
		public static const REMOVE:String = "remove";

		/**
		 *  Indicates that the item at the position identified by the
		 *  CollectionEvent location property has been replaced.
		 */
		public static const REPLACE:String = "replace";

		/**
		 *  Indicates that the collection has changed so drastically that
		 *  a reset is required.
		 */
		public static const RESET:String = "reset";

		/**
		 *  Indicates that one or more items were updated within the collection.
		 *  The affected item(s)
		 *  are stored in the items property.
		 */
		public static const UPDATE:String = "update";

	}
}
