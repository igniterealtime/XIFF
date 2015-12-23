/**
 * Created by kvint on 04.12.14.
 */
package org.igniterealtime.xiff.rsm {
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.igniterealtime.xiff.data.rsm.RSMSet;
	import org.igniterealtime.xiff.rsm.ISetManager;
	import org.igniterealtime.xiff.rsm.IndexedSetManager;

	public class ResultSetManagement {

		public var _setManager:ISetManager;

		[Before]
		public function setUp():void {
			_setManager = new IndexedSetManager();
			_setManager.bufferSize = 100;
		}

		[Test]
		public function steppingForward():void {
			var nextSet:RSMSet;

			var rsm:RSMSet = new RSMSet();
			rsm.count = 250;

			rsm.firstIndex = 0;
			_setManager.pin(rsm);
			nextSet = _setManager.getNext();

			assertEquals(100, nextSet.index);


			rsm.firstIndex = nextSet.index;
			_setManager.pin(rsm);
			nextSet = _setManager.getNext();

			assertEquals(200, nextSet.index);

			rsm.firstIndex = nextSet.index;
			_setManager.pin(rsm);
			nextSet = _setManager.getNext();

			assertEquals(250, nextSet.index);

			rsm.firstIndex = nextSet.index;
			_setManager.pin(rsm);
			nextSet = _setManager.getNext();

			assertNull(nextSet);
		}


		[Test]
		public function steppingBackward():void {
			var prevSet:RSMSet;

			var rsm:RSMSet = new RSMSet();
			rsm.count = 250;
			prevSet = _setManager.getPrevious();
			assertNotNull(prevSet);

			_setManager.pin(rsm);
			prevSet = _setManager.getPrevious();
			assertEquals(150, prevSet.index);

			rsm.firstIndex = prevSet.index;
			_setManager.pin(rsm);
			prevSet = _setManager.getPrevious();
			assertEquals(50, prevSet.index);

			rsm.firstIndex = prevSet.index;
			_setManager.pin(rsm);
			prevSet = _setManager.getPrevious();
			assertEquals(0, prevSet.index);

			rsm.firstIndex = prevSet.index;
			_setManager.pin(rsm);
			prevSet = _setManager.getPrevious();

			assertNull(prevSet);
		}
		[After]
		public function tearDown():void {
			_setManager = null;
		}
	}
}
