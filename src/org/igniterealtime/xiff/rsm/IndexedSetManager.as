/**
 * Created by AlexanderSla on 04.12.2014.
 */
package org.igniterealtime.xiff.rsm {
	import org.igniterealtime.xiff.data.rsm.RSMSet;

	public class IndexedSetManager extends ASetManager{

		public function IndexedSetManager(bufferSize:int = 0) {
			if(bufferSize > 0){
				this.bufferSize = bufferSize;
			}
		}

		override public function getNext():RSMSet {
			var result:RSMSet = new RSMSet();
			if(current) {
				result.index = Math.min(current.firstIndex + bufferSize, current.count);
				if(result.index == current.firstIndex) return null;
			}
			result.max = bufferSize;
			return result;
		}


		override public function getPrevious():RSMSet {
			var result:RSMSet = new RSMSet();
			if(current) {
				if(current.first == null && current.count > 0) {
					result.index = Math.max(current.count - bufferSize, 0);;
				}else{
					result.index = Math.max(current.firstIndex - bufferSize, 0);;
					if(result.index == current.firstIndex) return null;
				}
			}
			result.max = bufferSize;
			return result;
		}
	}
}
