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
package org.igniterealtime.xiff.data
{
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.id.IIDGenerator;
	import org.igniterealtime.xiff.data.id.IncrementalGenerator;
	import org.igniterealtime.xiff.namespaces.xiff_internal;

	/**
	 * A class for abstraction and encapsulation of IQ (info-query) data.
	 *
	 * @see http://tools.ietf.org/html/rfc3920#section-9.2.3
	 */
	public class IQ extends XMPPStanza implements IIQ
	{
		/**
		 * The stanza reports an error that has occurred
		 * regarding processing or delivery of a previously-sent get or
		 * set request.
		 * @see http://tools.ietf.org/html/draft-ietf-xmpp-3920bis-00#section-9.3
		 */
		public static const TYPE_ERROR:String = "error";

		/**
		 * The stanza requests information, inquires about what
		 * data is needed in order to complete further operations, etc.
		 */
		public static const TYPE_GET:String = "get";

		/**
		 * The stanza is a response to a successful get or set request.
		 */
		public static const TYPE_RESULT:String = "result";

		/**
		 * The stanza provides data that is needed for an
		 * operation to be completed, sets new values, replaces existing
		 * values, etc.
		 */
		public static const TYPE_SET:String = "set";

		private static var _idGenerator:IIDGenerator = new IncrementalGenerator( "iq_" );

		
		private var _callback:Function;
		private var _errorCallback:Function;
		
		/**
		 * A class for abstraction and encapsulation of IQ (info-query) data.
		 *
		 * <p>Info/Query, or <strong>IQ</strong>, is a request-response mechanism, similar in some
		 * ways to [HTTP].  The semantics of IQ enable an entity to make a
		 * request of, and receive a response from, another entity.  The data
		 * content of the request and response is defined by the namespace
		 * declaration of a direct child element of the IQ element, and the
		 * interaction is tracked by the requesting entity through use of the
		 * 'id' attribute.  Thus, IQ interactions follow a common pattern of
		 * structured data exchange such as get/result or set/result (although
		 * an error may be returned in reply to a request if appropriate):</p>
		 * <pre>
		 *    Requesting                 Responding
		 *      Entity                     Entity
		 *    ----------                 ----------
		 *        |                           |
		 *        | &lt;iq type='get' id='1'&gt;    |
		 *        | ------------------------&gt; |
		 *        |                           |
		 *        | &lt;iq type='result' id='1'&gt; |
		 *        | &lt;------------------------ |
		 *        |                           |
		 *        | &lt;iq type='set' id='2'&gt;    |
		 *        | ------------------------&gt; |
		 *        |                           |
		 *        | &lt;iq type='error' id='2'&gt;  |
		 *        | &lt;------------------------ |
		 *        |                           |
	     * </pre>
		 *
		 * @param	recipient The JID of the IQ recipient
		 * @param	iqType The type of the IQ - there are static variables declared for each type
		 * @param	iqID The unique ID of the IQ, one of TYPE_* constants
		 * @param	iqCallback The function to be called when the server responds to the IQ
		 * @param	iqErrorCallback The function to be called when there is an error
		 */
		public function IQ( recipient:EscapedJID = null, iqType:String = null, iqID:String = null, iqCallback:Function = null, iqErrorCallback:Function = null )
		{
			var id:String = iqID != null ? iqID : IQ.generateID();

			super( recipient, null, iqType, id, XMPPStanza.ELEMENT_IQ );

			callback = iqCallback;
			errorCallback = iqErrorCallback;
		}

		/**
		 * Generates a unique ID for the stanza. ID generation is handled using
		 * a variety of mechanisms, but the default for the library uses the IncrementalGenerator.
		 *
		 * @param	prefix The prefix for the ID to be generated
		 * @return	The generated ID
		 */
		public static function generateID( prefix:String=null ):String
		{
			return XMPPStanza.xiff_internal::generateID( _idGenerator, prefix );
		}
		
		/**
		 * The ID generator for this stanza type. ID generators must implement
		 * the IIDGenerator interface. The XIFF library comes with a few default
		 * ID generators that have already been implemented (see org.igniterealtime.xiff.data.id.*).
		 *
		 * Setting the ID generator by stanza type is useful if you'd like to use
		 * different ID generation schemes for each type. For instance, messages could
		 * use the incremental ID generation scheme provided by the IncrementalGenerator class, while
		 * IQs could use the shared object ID generation scheme provided by the SOIncrementalGenerator class.
		 *
		 * @param	generator The ID generator class
		 * @example	The following sets the ID generator for the Message stanza type to an IncrementalGenerator
		 * found in org.igniterealtime.xiff.data.id.IncrementalGenerator:
		 * <pre>Message.idGenerator = new IncrementalGenerator();</pre>
		 */
		public static function get idGenerator():IIDGenerator
		{
			return _idGenerator;
		}
		public static function set idGenerator(  value:IIDGenerator ):void
		{
			_idGenerator = value;
		}

		/**
		 * The function that will be called when an IQ result
		 * is received with the same ID as one you send.
		 *
		 * <p>Callback functions take one parameter which will be the IQ instance
		 * received from the server.</p>
		 *
		 * <p>This isn't a required property, but is useful if you
		 * need to respond to server responses to an IQ.</p>
		 */
		public function get callback():Function
		{
			return _callback;
		}
		public function set callback( value:Function ):void
		{
			_callback = value;
		}
		
		/**
		 * The function that will be called when an IQ error
		 * is received with the same ID as one you send.
		 *
		 * <p>Callback functions take one parameter which will be the IQ instance
		 * received from the server.</p>
		 *
		 * <p>This isn't a required property, but is useful if you
		 * need to respond to server responses to an IQ.</p>
		 */
		public function get errorCallback():Function
		{
			return _errorCallback;
		}
		public function set errorCallback( value:Function ):void
		{
			_errorCallback = value;
		}
	}
}
