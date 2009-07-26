/*
 * License
 */
package org.igniterealtime.xiff.data.id
{
	import org.igniterealtime.xiff.data.id.IIDGenerator;
	
	/**
	 * Uses a simple incrementation of a static variable to generate new IDs.
	 * Guaranteed to generate unique IDs for the duration of application execution.
	 */
	public class IncrementalGenerator implements IIDGenerator
	{
		private var myCounter:Number;
		private static var instance:IIDGenerator;
		
		public static function getInstance():IIDGenerator
		{
			if(instance == null)
			{
				instance = new IncrementalGenerator();
			}
			
			return instance;
		}
	
		public function IncrementalGenerator()
		{
			myCounter = 0;
		}
	
		/**
		 * Gets the unique ID.
		 *
		 * @param	prefix The ID prefix to use when generating the ID
		 * @return The generated ID
		 */
		public function getID(prefix:String):String
		{
			myCounter++;
			var id:String;
	
			if ( prefix != null ) {
				id = prefix + myCounter;
			} else {
				id = myCounter.toString();
			}
			return id;
		}
	}
}