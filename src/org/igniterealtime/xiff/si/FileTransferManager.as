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

	import com.hurlant.util.Base64;
	import com.hurlant.crypto.hash.MD5;

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
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.OUTGOING_FEATURE
	 */
	[Event(name="featureNegotiated", type="org.igniterealtime.xiff.events.FileTransferEvent")]

	/**
	 *
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.OUTGOING_OPEN
	 */
	[Event(name="outgoingOpen", type="org.igniterealtime.xiff.events.FileTransferEvent")]

	/**
	 * Recipient received the closing
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.OUTGOING_CLOSE
	 */
	[Event(name="outgoingClose", type="org.igniterealtime.xiff.events.FileTransferEvent")]

	/**
	 * Incoming stream method feature negotiation request
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.INCOMING_FEATURE
	 */
	[Event(name="incomingFeature", type="org.igniterealtime.xiff.events.FileTransferEvent")]

	/**
	 * Starting the incoming data stream.
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.INCOMING_OPEN
	 */
	[Event(name="incomingOpen", type="org.igniterealtime.xiff.events.FileTransferEvent")]

	/**
	 * Incoming data should be complete.
	 * @eventType org.igniterealtime.xiff.events.FileTransferEvent.INCOMING_CLOSE
	 */
	[Event(name="incomingClose", type="org.igniterealtime.xiff.events.FileTransferEvent")]



	/**
	 * INCOMPLETE
	 *
	 * Manages Stream Initiation (XEP-0095) based File Transfer (XEP-0096),
	 * which uses In-Band Bytestreams (XEP-0047) as the transfer stream method.
	 *
	 * <p>You can have maximum of one outgoing and one incoming file
	 * transfer ongoing at the same time.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0095.html
	 * @see http://xmpp.org/extensions/xep-0096.html
	 * @see http://xmpp.org/extensions/xep-0047.html
	 */
	public class FileTransferManager extends EventDispatcher
	{

		private var _connection:IXMPPConnection;

		private var _outGoingData:ByteArray;
		private var _outGoingBase64:String;
		private var _sequenceOut:uint = 0;

		private var _inComingData:ByteArray;
		private var _inComingBase64:String;
		private var _sequenceIn:uint = 0;
		private var _incomingMethodFieldName:String;

		private var _chunkSize:uint = 4096;
		private var _md5:MD5;

		/**
		 * Set the out going data first.
		 * Then sendFile with all the relevant information.
		 *
		 * @param	aConnection A reference to an XMPPConnection class instance
		 */
		public function FileTransferManager( aConnection:IXMPPConnection = null )
		{
			if ( aConnection != null )
			{
				connection = aConnection;
			}
			_md5 = new MD5();
		}

		/**
		 * Negotiate a suitable transfer protocol.
		 *
		 * <p><code>FileReferenceList.browse()</code> might be used to get the
		 * file and the relevant information.</p>
		 *
		 * <p>It seems that SOCKS5 Bytestreams (XEP-0065) would be the
		 * most preferred method, but it not implemented in XIFF.</p>
		 *
		 * <p>Negotiation the method for transferring files is done with
		 * the following extensions:</p>
		 * <ol>
		 * <li><code>FormExtension</code>, that contains a single
		 *   <code>FormField</code> with possible methods listed</li>
		 * <li><code>FeatureNegotiationExtension</code> wraps the form</li>
		 * <li><code>FileTransferExtension</code> contains information
		 *   about the file</li>
		 * <li>Both <code>FeatureNegotiationExtension</code> and
		 *   <code>FileTransferExtension</code> are wrapped in
		 *   <code>StreamInitiationExtension</code></li>
		 * <li>Finally <code>StreamInitiationExtension</code> is
		 *   wrapped in <code>IQ</code></li>
		 * </ol>
		 *
		 * @see http://xmpp.org/extensions/xep-0065.html
		 * @see http://xmpp.org/extensions/xep-0095.html#usecase
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/FileReference.html#load%28%29
		 */
		public function sendFile(to:EscapedJID, fileName:String, fileSize:uint, mimeType:String, modificationDate:Date = null):void
		{
			trace("sendFile. to: " + to.toString() + ", fileName: " + fileName + ", fileSize: " + fileSize + ", mimeType: " + mimeType);
			
			var options:Array = [
				{ label: "XEP-0047: In-Band Bytestreams", value: IBBExtension.NS } // Only supported method...
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
			fileExt.date = modificationDate;
			//fileExt.hash = _md5.hash();

			var siExt:StreamInitiationExtension = new StreamInitiationExtension();
			siExt.id = "letsdoit";
			siExt.profile = FileTransferExtension.NS;
			siExt.mimeType = mimeType;
			siExt.addExtension(featExt);
			siExt.addExtension(fileExt);

			var iq:IQ = new IQ(to, IQ.TYPE_SET, null, sendFile_callback, sendFile_errorCallback);
			iq.addExtension(siExt);
			_connection.send(iq);
		}

		/**
		 * Called once the IQ stanza with the proper id is coming back
		 */
		private function sendFile_callback(iq:IQ):void
		{
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
			if (siExt != null)
			{
				var featExt:FeatureNegotiationExtension = siExt.getAllExtensionsByNS(FeatureNegotiationExtension.NS)[0] as FeatureNegotiationExtension;

				var formExt:FormExtension = featExt.getAllExtensionsByNS(FormExtension.NS)[0] as FormExtension;

				var field:FormField = formExt.getFormField("stream-method");
				trace("sendFile_callback. field.value: " + field.value);

				var event:FileTransferEvent = new FileTransferEvent(FileTransferEvent.OUTGOING_FEATURE);
				event.extensions = [featExt];
				dispatchEvent(event);

				sendOpen(iq.from);
			}
		}

		private function sendFile_errorCallback(iq:IQ):void
		{
			// fail....
		}

		/**
		 * Once the stream method has been negotiated, initiate the session.
		 */
		private function sendOpen(to:EscapedJID):void
		{
			var openExt:IBBOpenExtension = new IBBOpenExtension();
			openExt.sid = "letsdoit";
			openExt.blockSize = _chunkSize;

			var iq:IQ = new IQ(to, IQ.TYPE_SET, null, sendOpen_callback, sendOpen_errorCallback);
			iq.addExtension(openExt);
			_connection.send(iq);
		}

		/**
		 * Called once the IQ stanza with the proper id is coming back
		 */
		private function sendOpen_callback(iq:IQ):void
		{
			var event:FileTransferEvent = new FileTransferEvent(FileTransferEvent.OUTGOING_OPEN);
			dispatchEvent(event);
			/*
			<iq from='juliet@capulet.com/balcony'
				id='jn3h8g65'
				to='romeo@montague.net/orchard'
				type='result'/>
			*/
			// Create Base64 version of the out going data
			_outGoingData.position = 0;
			_outGoingBase64 = Base64.encode( _outGoingData.readUTFBytes(_outGoingData.length) );
			sendChunk(iq.from);
		}

		private function sendOpen_errorCallback(iq:IQ):void
		{
			// IBB not supported by the other party
			/*
			<iq from='juliet@capulet.com/balcony'
				id='jn3h8g65'
				to='romeo@montague.net/orchard'
				type='error'>
			  <error type='cancel'>
				<service-unavailable xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
			  </error>
			</iq>
			*/

		}

		private function sendChunk(to:EscapedJID):void
		{
			var iq:IQ = new IQ(to, IQ.TYPE_SET, null, sendChunk_callback, sendChunk_errorCallback);
			var len:uint = Math.min(_outGoingBase64.length - _chunkSize * _sequenceOut, _sequenceOut);
			if (len > 0)
			{
				var dataExt:IBBDataExtension = new IBBDataExtension();
				dataExt.sid = "letsdoit";
				dataExt.seq = _sequenceOut;
				dataExt.data = _outGoingBase64.substr(_chunkSize * _sequenceOut, len);
				iq.addExtension(dataExt);
				++_sequenceOut;
			}
			else
			{
				iq.addExtension(new IBBCloseExtension());
			}

			_connection.send(iq);
		}

		private function sendChunk_callback(iq:IQ):void
		{
			if (_outGoingBase64.length - _chunkSize * _sequenceOut > 0)
			{
				sendChunk(iq.from);
			}
			else
			{
				var event:FileTransferEvent = new FileTransferEvent(FileTransferEvent.OUTGOING_CLOSE);
				dispatchEvent(event);
			}
		}

		private function sendChunk_errorCallback(iq:IQ):void
		{
			// fail....
		}

		/**
		 * This listener will catch any incoming requests.
		 *
		 * <p>Will dispatch an INCOMING_FEATURE event if suitable stream
		 * method is suggested.</p>
		 */
		private function onStreamInitiation(event:IQEvent):void
		{
			var iq:IQ;
			/*
			<si xmlns='http://jabber.org/protocol/si'
				  id='a0'
				  mime-type='text/plain'
				  profile='http://jabber.org/protocol/si/profile/file-transfer'>
				<file xmlns='http://jabber.org/protocol/si/profile/file-transfer'
					  name='test.txt'
					  size='1022'>
				  <desc>This is info about the file.</desc>
				</file>
				<feature xmlns='http://jabber.org/protocol/feature-neg'>
				  <x xmlns='jabber:x:data' type='form'>
					<field var='stream-method' type='list-single'>
					  <option><value>http://jabber.org/protocol/bytestreams</value></option>
					  <option><value>jabber:iq:oob</value></option>
					  <option><value>http://jabber.org/protocol/ibb</value></option>
					</field>
				  </x>
				</feature>
			  </si>
			*/
			var siExt:StreamInitiationExtension = event.data as StreamInitiationExtension;
			if (siExt != null)
			{
				if (siExt.profile != FileTransferExtension.NS)
				{
					// Profile not understood
					/*
					<iq type='error' to='sender@jabber.org/resource' id='offer1'>
					  <error code='400' type='cancel'>
						<bad-request xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
						<bad-profile xmlns='http://jabber.org/protocol/si'/>
					  </error>
					</iq>
					*/
					iq = new IQ(event.iq.from, IQ.TYPE_ERROR, event.iq.id);
					iq.errorCondition = "bad-request";
					iq.errorType = XMPPStanza.ERROR_MODIFY; // spec says modify, example cancel
					// http://xmpp.org/extensions/xep-0095.html#def-error

					// TODO: application specific error message..
					//<bad-profile xmlns='http://jabber.org/protocol/si'/>

					_connection.send(iq);

					return;
				}

				var featExt:FeatureNegotiationExtension = siExt.getAllExtensionsByNS(FeatureNegotiationExtension.NS)[0] as FeatureNegotiationExtension;
				var fileExt:FileTransferExtension = siExt.getAllExtensionsByNS(FileTransferExtension.NS)[0] as FileTransferExtension;
				if (featExt != null && fileExt != null)
				{
					var formExt:FormExtension = featExt.getAllExtensionsByNS(FormExtension.NS)[0] as FormExtension;
					if (formExt != null)
					{
						// Look for suitable stream method...
						var fieldName:String;
						var fields:Array = formExt.fields;
						for each (var field:FormField in fields)
						{
							var index:int = field.values.indexOf(IBBExtension.NS);; // Only supported method...
							if (index !== -1)
							{
								trace("field.varName: " + field.varName);
								fieldName = field.varName;
							}
						}

						if (fieldName != null)
						{
							_incomingMethodFieldName = fieldName;
							var fileEvent:FileTransferEvent = new FileTransferEvent(FileTransferEvent.INCOMING_FEATURE);
							fileEvent.iq = event.iq;
							dispatchEvent(fileEvent);
						}
						else
						{
							// No Valid Streams
							// Respond with an error
							iq = new IQ(event.iq.from, IQ.TYPE_ERROR, event.iq.id);
							iq.errorCondition = "bad-request";
							iq.errorType = XMPPStanza.ERROR_CANCEL;

							// TODO: application specific error message..
							//<no-valid-streams xmlns='http://jabber.org/protocol/si'/>

							_connection.send(iq);
						}
					}
				}
			}
		}

		/**
		 * Send feature request responce.
		 */
		public function acceptFile(originalIq:IQ):void
		{
			if (_incomingMethodFieldName == null || _incomingMethodFieldName == "")
			{
				throw new Error("Incoming method field name is not set.");
			}

			var field:FormField = new FormField();
			field.varName = _incomingMethodFieldName;
			field.value = IBBExtension.NS; // Only supported method...

			var formExt:FormExtension = new FormExtension();
			formExt.type = FormType.SUBMIT;
			formExt.fields = [field];

			var featExt:FeatureNegotiationExtension = new FeatureNegotiationExtension();
			featExt.addExtension(formExt);

			var siExt:StreamInitiationExtension = new StreamInitiationExtension();
			siExt.addExtension(featExt);

			var iq:IQ = new IQ(originalIq.from, IQ.TYPE_RESULT, originalIq.id);
			iq.addExtension(siExt);
			_connection.send(iq);
		}

		/**
		 * Reject the file, possible with an explanation
		 */
		public function rejectFile(originalIq:IQ, text:String = null):void
		{
			/*
			<iq type='error' to='sender@jabber.org/resource' id='offer1'>
			  <error code='403' type='cancel'>
				<forbidden xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'/>
				<text xmlns='urn:ietf:params:xml:ns:xmpp-stanzas'>Offer Declined</text>
			  </error>
			</iq>
			*/
			// Respond with an error
			var iq:IQ = new IQ(originalIq.from, IQ.TYPE_ERROR, originalIq.id);
			iq.errorCondition = "forbidden";
			iq.errorType = XMPPStanza.ERROR_CANCEL;
			iq.errorMessage = text;
			_connection.send(iq);
		}


		/**
		 * Incoming In-Band Byte Stream listener.
		 */
		private function onInBandData(event:IQEvent):void
		{
			if (event.data != null)
			{
				if (event.data is IBBDataExtension)
				{
					var dataExt:IBBDataExtension = event.data as IBBDataExtension;
					_sequenceIn = dataExt.seq;
					_inComingBase64 += dataExt.data;
				}
				else if (event.data is IBBOpenExtension)
				{
					_inComingData = new ByteArray();
					_inComingBase64 = "";
					var openExt:IBBOpenExtension = event.data as IBBOpenExtension;
					dispatchEvent(new FileTransferEvent(FileTransferEvent.INCOMING_OPEN));
				}
				else if (event.data is IBBCloseExtension)
				{
					_inComingData.writeUTFBytes(Base64.decode(_inComingBase64));
					var closeExt:IBBCloseExtension = event.data as IBBCloseExtension;
					dispatchEvent(new FileTransferEvent(FileTransferEvent.INCOMING_CLOSE));
				}

				// Send acknowledgement
				var iq:IQ = new IQ(event.iq.from, IQ.TYPE_RESULT, event.iq.id);
				_connection.send(iq);
			}

		}

		/**
		 * Data that is sent to the recipient.
		 * This should be the raw data, possible Base64
		 * encoding is handled internally.
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
		 * Data that is received from the other party.
		 * This should be the raw data, possible Base64
		 * decoding is handled internally.
		 *
		 * <p>Read-only</p>
		 */
		public function get inComingData():ByteArray
		{
			return _inComingData;
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
				_connection.removeEventListener(StreamInitiationExtension.NS, onStreamInitiation);
				_connection.removeEventListener(IBBExtension.NS, onInBandData);
			}

			_connection = value;
			_connection.addEventListener(StreamInitiationExtension.NS, onStreamInitiation);
			_connection.addEventListener(IBBExtension.NS, onInBandData);
			_connection.enableExtensions(
				FileTransferExtension,
				FormExtension,
				StreamInitiationExtension,
				FeatureNegotiationExtension,
				OutOfBoundDataExtension,
				IBBOpenExtension
			);
		}
	}
}
