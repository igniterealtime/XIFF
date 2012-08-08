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
package org.igniterealtime.xiff.si
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	import org.igniterealtime.xiff.core.*;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.data.feature.FeatureNegotiationExtension;
	import org.igniterealtime.xiff.data.forms.*;
	import org.igniterealtime.xiff.data.forms.enum.*;
	import org.igniterealtime.xiff.data.si.*;
	import org.igniterealtime.xiff.data.stream.*;
	import org.igniterealtime.xiff.data.message.*;
	import org.igniterealtime.xiff.events.*;

	/**
	 *
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.TRANSFER_INIT
	 */
	[Event(name="transferInit", type="org.igniterealtime.xiff.events.FileTransferEvent")]
	/**
	 *
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.FEATURE_NEGOTIATED
	 */
	[Event(name="featureNegotiated", type="org.igniterealtime.xiff.events.FileTransferEvent")]
	
	/**
	 * INCOMPLETE
	 *
	 * Manages Stream Initiation (XEP-0095) based File Transfer (XEP-0096)
	 *
	 * @see http://xmpp.org/extensions/xep-0095.html
	 * @see http://xmpp.org/extensions/xep-0096.html
	 */
	public class FileTransferManager extends EventDispatcher
	{

		private var _connection:IXMPPConnection;
		private var _outGoingData:ByteArray;
		private var _sequence:uint = 0;
		private var _chunkSize:uint = 4096;

		/**
		 * Set the out going data first.
		 * Then beginNegotiation with all the relevant information
		 * Once FEATURE_NEGOTIATED occurs, call initiateSession.
		 *
		 * @param	aConnection A reference to an XMPPConnection class instance
		 */
		public function FileTransferManager( aConnection:IXMPPConnection = null )
		{
			if ( aConnection != null )
			{
				connection = aConnection;
			}
		}

		/**
		 * Negotiate a suitable transfer protocol.
		 * Feature negotiation is done with a FormExtension.
		 *
		 * <p>It can for example contain a list of possible stream methods.
		 * It seems that SOCKS5 Bytestreams (XEP-0065) will always be
		 * preferable, but it not implemented in XIFF.</p>
		 *
		 * @see http://xmpp.org/extensions/xep-0065.html
		 * @see http://xmpp.org/extensions/xep-0066.html
		 * @see http://xmpp.org/extensions/xep-0047.html
		 */
		public function beginNegotiation(to:EscapedJID, fileName:String, fileSize:uint, mimeType:String):void
		{
			/*
			<iq type='set' id='offer1' to='receiver@jabber.org/resource'>
			  <si xmlns='http://jabber.org/protocol/si'
				  id='a0'
				  mime-type='text/plain'
				  profile='http://jabber.org/protocol/si/profile/file-transfer'>
				<file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
					  name='test.txt'
					  size='1022'/>
				<feature xmlns='http://jabber.org/protocol/feature-neg'>
				  <x xmlns='jabber:x:data' type='form'>
					<field var='stream-method' type='list-single'>
					  <option><value>http://jabber.org/protocol/bytestreams</value></option>
					  <option><value>http://jabber.org/protocol/ibb</value></option>
					</field>
				  </x>
				</feature>
			  </si>
			</iq>
			*/
			var options:Array = [
				{ label: "XEP-0066: Out of Band Data", value: OutOfBoundDataExtension.NS },
				{ label: "XEP-0047: In-Band Bytestreams", value: IBBExtension.NS }
			];
			var field:FormField = new FormField(
				FormFieldType.LIST_SINGLE,
				"stream-method",
				null,
				options
			);
			var formExt:FormExtension = new FormExtension();
			formExt.type = FormType.FORM;
			formExt.fields = [field];

			var featExt:FeatureNegotiationExtension = new FeatureNegotiationExtension();
			featExt.addExtension(formExt);

			var fileExt:FileTransferExtension = new FileTransferExtension();
			fileExt.name = fileName;
			fileExt.size = fileSize;
			fileExt.addExtension(featExt);

			var siExt:StreamInitiationExtension = new StreamInitiationExtension();
			siExt.id = "letsdoit";
			siExt.profile = FileTransferExtension.NS;
			siExt.mimeType = mimeType;
			siExt.addExtension(featExt);

			var iq:IQ = new IQ(to, IQ.TYPE_SET, null, beginNegotiation_callback, beginNegotiation_errorCallback);
			iq.addExtension(siExt);
			_connection.send(iq);
		}

		/**
		 * Called once the IQ stanza with the proper id is coming back
		 */
		private function beginNegotiation_callback(iq:IQ):void
		{
			var event:FileTransferEvent = new FileTransferEvent(FileTransferEvent.FEATURE_NEGOTIATED);
			dispatchEvent(event);
			/*
			<iq type='result' to='sender@jabber.org/resource' id='offer1'>
			  <si xmlns='http://jabber.org/protocol/si'>
				<feature xmlns='http://jabber.org/protocol/feature-neg'>
				  <x xmlns='jabber:x:data' type='submit'>
					<field var='stream-method'>
					  <value>http://jabber.org/protocol/bytestreams</value>
					</field>
				  </x>
				</feature>
			  </si>
			</iq>
			*/
			var siExt:StreamInitiationExtension = iq.getAllExtensionsByNS(StreamInitiationExtension.NS)[0] as StreamInitiationExtension;

			var featExt:FeatureNegotiationExtension = siExt.getAllExtensionsByNS(FeatureNegotiationExtension.NS)[0] as FeatureNegotiationExtension;

			var formExt:FormExtension = featExt.getAllExtensionsByNS(FormExtension.NS)[0] as FormExtension;

			var field:FormField = formExt.getFormField("stream-method");
			trace("beginNegotiation_callback. field.value: " + field.value);
		}

		private function beginNegotiation_errorCallback(iq:IQ):void
		{
			// fail....
		}

		/**
		 * Once the stream method has been negotiated, initiate the session.
		 */
		public function initiateSession(to:EscapedJID):void
		{
			/*
			<iq from='romeo@montague.net/orchard'
				id='jn3h8g65'
				to='juliet@capulet.com/balcony'
				type='set'>
			  <open xmlns='http://jabber.org/protocol/ibb'
					block-size='4096'
					sid='i781hf64'
					stanza='iq'/>
			</iq>
			*/
			var openExt:IBBOpenExtension = new IBBOpenExtension();
			openExt.sid = "letsdoit";
			openExt.blockSize = _chunkSize;

			var iq:IQ = new IQ(to, IQ.TYPE_SET, null, initiateSession_callback, initiateSession_errorCallback);
			iq.addExtension(openExt);
			_connection.send(iq);
		}

		/**
		 * Called once the IQ stanza with the proper id is coming back
		 */
		private function initiateSession_callback(iq:IQ):void
		{
			var event:FileTransferEvent = new FileTransferEvent(FileTransferEvent.TRANSFER_INIT);
			dispatchEvent(event);
			/*
			<iq from='juliet@capulet.com/balcony'
				id='jn3h8g65'
				to='romeo@montague.net/orchard'
				type='result'/>
			*/
			sendChunk(iq.from);
		}

		private function initiateSession_errorCallback(iq:IQ):void
		{
			// fail....
		}

		private function sendChunk(to:EscapedJID):void
		{
			/*
			<iq from='romeo@montague.net/orchard'
				id='kr91n475'
				to='juliet@capulet.com/balcony'
				type='set'>
			  <data xmlns='http://jabber.org/protocol/ibb' seq='0' sid='i781hf64'>
				qANQR1DBwU4DX7jmYZnncmUQB/9KuKBddzQH+tZ1ZywKK0yHKnq57kWq+RFtQdCJ
				WpdWpR0uQsuJe7+vh3NWn59/gTc5MDlX8dS9p0ovStmNcyLhxVgmqS8ZKhsblVeu
				IpQ0JgavABqibJolc3BKrVtVV1igKiX/N7Pi8RtY1K18toaMDhdEfhBRzO/XB0+P
				AQhYlRjNacGcslkhXqNjK5Va4tuOAPy2n1Q8UUrHbUd0g+xJ9Bm0G0LZXyvCWyKH
				kuNEHFQiLuCY6Iv0myq6iX6tjuHehZlFSh80b5BVV9tNLwNR5Eqz1klxMhoghJOA
			  </data>
			</iq>
			*/
			var iq:IQ = new IQ(to, IQ.TYPE_SET, null, sendChunk_callback, sendChunk_errorCallback);
			var len:uint = Math.min(_outGoingData.bytesAvailable, _chunkSize);
			if (len > 0)
			{
				var dataExt:IBBDataExtension = new IBBDataExtension();
				dataExt.sid = "letsdoit";
				dataExt.seq = _sequence;
				dataExt.data = _outGoingData.readUTFBytes(len);
				iq.addExtension(dataExt);
				++_sequence;
			}
			else
			{
				iq.addExtension(new IBBCloseExtension());
			}

			_connection.send(iq);
		}

		private function sendChunk_callback(iq:IQ):void
		{
			if (_outGoingData.bytesAvailable > 0)
			{
				sendChunk(iq.from);
			}
		}

		private function sendChunk_errorCallback(iq:IQ):void
		{
			// fail....
		}
		
		/**
		 * Base64 encoded data that is sent to the recipient.
		 */
		public function get outGoingData():ByteArray
		{
			return _outGoingData;
		}
		public function set outGoingData( value:ByteArray ):void
		{
			_outGoingData = value;
		}

		/**
		 * The connection used for sending and receiving data.
		 */
		public function get connection():IXMPPConnection
		{
			return _connection;
		}
		public function set connection( value:IXMPPConnection ):void
		{
			if ( _connection != null )
			{
			}

			_connection = value;
			_connection.enableExtensions( FileTransferExtension, FormExtension, StreamInitiationExtension );
		}
	}
}
