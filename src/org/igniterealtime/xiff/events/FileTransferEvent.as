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
	
	import org.igniterealtime.xiff.data.IQ;

	/**
	 * Events from the FileTransferManager
	 */
	public class FileTransferEvent extends Event
	{
		public static const OUTGOING_FEATURE:String = "outgoingFeature";
		public static const OUTGOING_OPEN:String = "outgoingOpen";
		public static const OUTGOING_CLOSE:String = "outgoingClose";

		public static const INCOMING_FEATURE:String = "incomingFeature";
		public static const INCOMING_OPEN:String = "incomingOpen";
		public static const INCOMING_CLOSE:String = "incomingClose";

		/**
		 * Extensions that might be related to the event type.
		 * FeatureNegotiationExtension, FileTransferExtension
		 */
		public var extensions:Array;

		/**
		 * The original IQ that contained the extension that might have triggered this event.
		 */
		public var iq:IQ;

		/**
		 *
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function FileTransferEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

		override public function clone():Event
		{
			var event:FileTransferEvent = new FileTransferEvent( type, bubbles, cancelable );
			return event;
		}

		override public function toString():String
		{
			return '[FileTransferEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
