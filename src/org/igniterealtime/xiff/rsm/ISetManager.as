/**
 * Created by AlexanderSla on 04.12.2014.
 */
package org.igniterealtime.xiff.rsm {
	import org.igniterealtime.xiff.data.rsm.RSMSet;

	public interface ISetManager {

		function get bufferSize():int;
		function set bufferSize(value:int):void;

		function getNext():RSMSet;
		function getPrevious():RSMSet;
		function pin(value:RSMSet):void;
		function reset():void;
	}
}
