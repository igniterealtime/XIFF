/**
 * Created by kvint on 16.11.14.
 */
package org.igniterealtime.xiff.data.time {
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	public class Time extends Extension implements IExtension {

		public static const ELEMENT_NAME:String = "time";
		public static const NS:String = "urn:xmpp:time";
		private const UTC:String = "utc";
		private const TZO:String = "tzo";

		public function getNS():String {
			return NS;
		}

		public function get utc():String {
			return getField(UTC);
		}

		public function get tzo():String {
			return getField(TZO);
		}

		public function getElementName():String {
			return ELEMENT_NAME;
		}
	}
}
