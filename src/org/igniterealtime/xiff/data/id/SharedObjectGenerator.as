/*
 * License
 */
package org.igniterealtime.xiff.data.id
{
	
	import org.igniterealtime.xiff.data.id.IIDGenerator;
	import flash.net.SharedObject;
	
	/**
	 * Generates an incrementing ID and saves the last value in a local shared object.
	 * Guaranteed to generate unique IDs for a single machine.
	 */
	public class SharedObjectGenerator implements IIDGenerator
	{
		private static var SO_COOKIE_NAME:String = "IIDGenerator";
	
		private var mySO:SharedObject;
	
		public function SharedObjectGenerator()
		{
			mySO = SharedObject.getLocal(SO_COOKIE_NAME);
			if (mySO.data.myCounter == undefined) {
				mySO.data.myCounter = 0;
			}
		}
	
		/**
		 * Gets the unique ID.
		 *
		 * @param	prefix The ID prefix to use when generating the ID
		 * @return The generated ID
		 */
		public function getID(prefix:String):String
		{
			mySO.data.myCounter++;
	
			var id:String;
	
			if (prefix != null) {
				id = prefix + mySO.data.myCounter;
			} else {
				id = mySO.data.myCounter.toString();
			}
			return id;
		}
	}
}