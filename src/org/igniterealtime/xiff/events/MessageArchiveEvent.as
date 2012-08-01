/*
 * Copyright (C) 2003-2012 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
 *     Michael McCarthy <mikeycmccarthy@gmail.com>
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.igniterealtime.xiff.events
{
	import flash.events.Event;

	import org.igniterealtime.xiff.data.message.ArchiveExtension;

	/**
	 * XEP-0136: Message Archiving
	 *
	 * @see http://xmpp.org/extensions/xep-0136.html
	 */
	public class MessageArchiveEvent extends Event
	{
		public static const PREF_RECEIVED:String = "prefReceived";
		public static const PREF_ERROR:String = "prefError";
		public static const ITEM_REMOVED:String = "itemRemoved";
		public static const COLLECTION_RECEIVED:String = "collectionReceived";

		private var _data:ArchiveExtension;

		public function MessageArchiveEvent(type:String)
		{
			super( type, false, false );
		}

		override public function clone():Event
		{
			var event:MessageArchiveEvent = new MessageArchiveEvent(type);
			event.data = _data;
			return event;
		}

		public function get data():ArchiveExtension
		{
			return _data;
		}
		public function set data( value:ArchiveExtension ):void
		{
			_data = value;
		}

		override public function toString():String
		{
			return '[MessageEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
