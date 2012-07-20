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

	import org.igniterealtime.xiff.data.Extension;

	/**
	 * RFC 3920 (XMPP Core, published October 2004),
	 * in chapters 4.7. defines Stream Errors.
	 *
	 * <p>The following rules apply to stream-level errors:</p>
	 *
	 * <p>It is assumed that all stream-level errors are unrecoverable;
	 * therefore, if an error occurs at the level of the stream, the
	 * entity that detects the error MUST send a stream error to the
	 * other entity, send a closing <strong>stream</strong> tag, and terminate the
	 * underlying TCP connection.</p>
	 *
	 * <p>If the error occurs while the stream is being set up, the
	 * receiving entity MUST still send the opening <strong>stream</strong> tag, include
	 * the <strong>error</strong> element as a child of the stream element, send the
	 * closing <strong>stream</strong> tag, and terminate the underlying TCP
	 * connection.  In this case, if the initiating entity provides an
	 * unknown host in the 'to' attribute (or provides no 'to' attribute
	 * at all), the server SHOULD provide the server's authoritative
	 * hostname in the 'from' attribute of the stream header sent before
	 * termination.</p>
	 *
	 * @see http://tools.ietf.org/html/rfc3920#section-4.7
	 */
	public class XIFFErrorEvent extends Event
	{
		/**
		 *
		 * @default
		 */
		public static const XIFF_ERROR:String = "error";

		/**
		 *
		 * @default
		 */
				private var _errorCode:int = 0;

		/**
		 *
		 * @default
		 */
		private var _errorCondition:String;

		/**
		 *
		 * @default
		 */
		private var _errorExt:Extension;

		/**
		 *
		 * @default
		 */
		private var _errorMessage:String;

		/**
		 *
		 * @default
		 */
		private var _errorType:String;

		/**
		 *
		 */
		public function XIFFErrorEvent()
		{
			super( XIFFErrorEvent.XIFF_ERROR, false, false );
		}

		override public function clone():Event
		{
			var event:XIFFErrorEvent = new XIFFErrorEvent();
			event.errorCondition = _errorCondition;
			event.errorMessage = _errorMessage;
			event.errorType = _errorType;
			event.errorCode = _errorCode;
			event.errorExt = _errorExt;
			return event;
		}

		/**
		 * Legacy error code
		 * @see http://xmpp.org/extensions/xep-0086.html
		 */
		public function get errorCode():int
		{
			return _errorCode;
		}
		public function set errorCode( value:int ):void
		{
			_errorCode = value;
		}

		/**
		 * <p>The following stream-level error conditions are defined:</p>
		 *
		 * <ul>
		 * <li><strong>bad-format</strong> - the entity has sent XML that cannot be processed;
		 * this error MAY be used instead of the more specific XML-related
		 * errors, such as <strong>bad-namespace-prefix</strong>, <strong>invalid-xml</strong>,
		 * <strong>restricted-xml</strong>, <strong>unsupported-encoding</strong>, and
		 * <strong>xml-not-well-formed</strong>, although the more specific errors are
		 * preferred.</li>
		 *
		 * <li><strong>bad-namespace-prefix</strong> - the entity has sent a namespace prefix
		 * that is unsupported, or has sent no namespace prefix on an element
		 * that requires such a prefix (see XML Namespace Names and Prefixes
		 * (Section 11.2)).</li>
		 *
		 * <li><strong>conflict</strong> - the server is closing the active stream for this
		 * entity because a new stream has been initiated that conflicts with
		 * the existing stream.</li>
		 *
		 * <li><strong>connection-timeout</strong> - the entity has not generated any traffic
		 * over the stream for some period of time (configurable according to
		 * a local service policy).</li>
		 *
		 * <li><strong>host-gone</strong> - the value of the 'to' attribute provided by the
		 * initiating entity in the stream header corresponds to a hostname
		 * that is no longer hosted by the server.</li>
		 *
		 * <li><strong>host-unknown</strong> - the value of the 'to' attribute provided by the
		 * initiating entity in the stream header does not correspond to a
		 * hostname that is hosted by the server.</li>
		 *
		 * <li><strong>improper-addressing</strong> - a stanza sent between two servers lacks
		 * a 'to' or 'from' attribute (or the attribute has no value).</li>
		 *
		 * <li><strong>internal-server-error</strong> - the server has experienced a
		 * misconfiguration or an otherwise-undefined internal error that
		 * prevents it from servicing the stream.</li>
		 *
		 * <li><strong>invalid-from</strong> - the JID or hostname provided in a 'from'
		 * address does not match an authorized JID or validated domain
		 * negotiated between servers via SASL or dialback, or between a
		 * client and a server via authentication and resource binding.</li>
		 *
		 * <li><strong>invalid-id</strong> - the stream ID or dialback ID is invalid or does
		 * not match an ID previously provided.</li>
		 *
		 * <li><strong>invalid-namespace</strong> - the streams namespace name is something
		 * other than "http://etherx.jabber.org/streams" or the dialback
		 * namespace name is something other than "jabber:server:dialback"
		 * (see XML Namespace Names and Prefixes (Section 11.2)).</li>
		 *
		 * <li><strong>invalid-xml</strong> - the entity has sent invalid XML over the stream
		 * to a server that performs validation (see Validation (Section
		 * 11.3)).</li>
		 *
		 * <li><strong>not-authorized</strong> - the entity has attempted to send data before
		 * the stream has been authenticated, or otherwise is not authorized
		 * to perform an action related to stream negotiation; the receiving
		 * entity MUST NOT process the offending stanza before sending the
		 * stream error.</li>
		 *
		 * <li><strong>policy-violation</strong> - the entity has violated some local service
		 * policy; the server MAY choose to specify the policy in the <strong>text</strong>
		 * element or an application-specific condition element.</li>
		 *
		 * <li><strong>remote-connection-failed</strong> - the server is unable to properly
		 * connect to a remote entity that is required for authentication or
		 * authorization.</li>
		 *
		 * <li><strong>resource-constraint</strong> - the server lacks the system resources
		 * necessary to service the stream.</li>
		 *
		 * <li><strong>restricted-xml</strong> - the entity has attempted to send restricted
		 * XML features such as a comment, processing instruction, DTD,
		 * entity reference, or unescaped character (see Restrictions
		 * (Section 11.1)).</li>
		 *
		 * <li><strong>see-other-host</strong> - the server will not provide service to the
		 * initiating entity but is redirecting traffic to another host; the
		 * server SHOULD specify the alternate hostname or IP address (which
		 * MUST be a valid domain identifier) as the XML character data of
		 * the <strong>see-other-host</strong> element.</li>
		 *
		 * <li><strong>system-shutdown</strong> - the server is being shut down and all active
		 * streams are being closed.</li>
		 *
		 * <li><strong>undefined-condition</strong> - the error condition is not one of those
		 * defined by the other conditions in this list; this error condition
		 * SHOULD be used only in conjunction with an application-specific
		 * condition.</li>
		 *
		 * <li><strong>unsupported-encoding</strong> - the initiating entity has encoded the
		 * stream in an encoding that is not supported by the server (see
		 * Character Encoding (Section 11.5)).</li>
		 *
		 * <li><strong>unsupported-stanza-type</strong> - the initiating entity has sent a
		 * first-level child of the stream that is not supported by the
		 * server.</li>
		 *
		 * <li><strong>unsupported-version</strong> - the value of the 'version' attribute
		 * provided by the initiating entity in the stream header specifies a
		 * version of XMPP that is not supported by the server; the server
		 * MAY specify the version(s) it supports in the <strong>text</strong> element.</li>
		 *
		 * <li><strong>xml-not-well-formed</strong> - the initiating entity has sent XML that
		 * is not well-formed as defined by [XML].</li>
		 * </ul>
		 *
		 * @see http://tools.ietf.org/html/rfc3920#section-4.7.3
		 */
		public function get errorCondition():String
		{
			return _errorCondition;
		}
		public function set errorCondition( value:String ):void
		{
			_errorCondition = value;
		}

		/**
		 *
		 */
		public function get errorExt():Extension
		{
			return _errorExt;
		}
		public function set errorExt( value:Extension ):void
		{
			_errorExt = value;
		}

		/**
		 *
		 */
		public function get errorMessage():String
		{
			return _errorMessage;
		}
		public function set errorMessage( value:String ):void
		{
			_errorMessage = value;
		}

		/**
		 *
		 */
		public function get errorType():String
		{
			return _errorType;
		}
		public function set errorType( value:String ):void
		{
			_errorType = value;
		}

		override public function toString():String
		{
			return '[XIFFErrorEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' +
				cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}
