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
package org.igniterealtime.xiff.privatedata
{
	import flash.events.EventDispatcher;
	
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.privatedata.PrivateDataExtension;
	import org.igniterealtime.xiff.filter.CallbackPacketFilter;
	import org.igniterealtime.xiff.filter.IPacketFilter;
	import org.igniterealtime.xiff.util.Callback;

	/**
	 * XEP-0049: Private XML Storage
	 * @see http://xmpp.org/extensions/xep-0049.html
	 */
	public class PrivateDataManager extends EventDispatcher
	{
		private static var privateDataManagerConstructed:Boolean = privateDataManagerStaticConstructor();
		
		/**
	     * Registers this extension with the extension registry for it to be used,
		 * in case incoming data matches the ELEMENT_NAME and NS.
	     */
		private static function privateDataManagerStaticConstructor():Boolean
		{
			ExtensionClassRegistry.register( PrivateDataExtension );
			return true;
		}
		
		private var _connection:XMPPConnection;
		
		/**
		 *
		 * @param	connection
		 */
		public function PrivateDataManager(connection:XMPPConnection)
		{
			_connection = connection;
		}
		
		/**
		 *
		 * @param	elementName
		 * @param	elementNamespace
		 * @param	callback
		 */
		public function getPrivateData(elementName:String, elementNamespace:String, callback:Callback):void
		{
			var packetFilter:IPacketFilter = new CallbackPacketFilter(callback);
			var iq:IQ = new IQ(null, IQ.TYPE_GET, null, packetFilter.accept );
			iq.addExtension(new PrivateDataExtension(elementName, elementNamespace));
			
			_connection.send(iq);
		}
		
		/**
		 *
		 * @param	elementName
		 * @param	elementNamespace
		 * @param	payload
		 */
		public function setPrivateData(elementName:String, elementNamespace:String, payload:IPrivatePayload):void
		{
			var iq:IQ = new IQ(null, IQ.TYPE_SET);
			iq.addExtension(new PrivateDataExtension(elementName, elementNamespace, payload));
			
			_connection.send(iq);
		}
	}
}
