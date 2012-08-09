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
	import org.igniterealtime.xiff.util.DateTimeParser;

	/**
	 * The base class for all XMPP stanza data classes.
	 *
	 * <p>Three types can exist:</p>
	 * <ul>
	 * <li>message</li>
	 * <li>presence</li>
	 * <li>iq</li>
	 * </ul>
	 *
	 * @see http://xmpp.org/rfcs/rfc3920.html#stanzas
	 * @see http://tools.ietf.org/html/rfc3920#section-9
	 */
	public dynamic class XMPPStanza extends XMLStanza implements IXMPPStanza
	{
		public static const CLIENT_NAMESPACE:String = "jabber:client";

		/**
		 * The version of XMPP specified in RFC 3920 is "1.0"; in particular, this
		 * encapsulates the stream-related protocols (Use of TLS (Section 5),
		 * Use of SASL (Section 6), and Stream Errors (Section 4.7)), as well as
		 * the semantics of the three defined XML stanza types (<strong>message</strong>,
		 * <strong>presence</strong>, and <strong>iq</strong>).
		 */
		public static const CLIENT_VERSION:String = "1.0";

		public static const NAMESPACE_FLASH:String = "http://www.jabber.com/streams/flash";
		public static const NAMESPACE_STREAM:String = "http://etherx.jabber.org/streams";
		public static const NAMESPACE_BOSH:String = "urn:xmpp:xbosh";
		public static const XML_LANG:String = "en";

		// Three XML element names allowed
		public static const ELEMENT_MESSAGE:String = "message";
		public static const ELEMENT_PRESENCE:String = "presence";
		public static const ELEMENT_IQ:String = "iq";


		/**
		 * Do not retry (the error is unrecoverable)
		 */
		public static const ERROR_CANCEL:String = "cancel";
		/**
		 * Proceed (the condition was only a warning)
		 */
		public static const ERROR_CONTINUE:String = "continue";
		/**
		 * Retry after changing the data sent
		 */
		public static const ERROR_MODIFY:String = "modify";
		/**
		 * Retry after providing credentials
		 */
		public static const ERROR_AUTH:String = "auth";
		/**
		 * Retry after waiting (the error is temporary)
		 */
		public static const ERROR_WAIT:String = "wait";

		/**
		 * Internal name in XIFF for incoming data.
		 * The proper element name should be available after setting the XML.
		 */
		public static const ELEMENT_TEMP:String = "temp";

		private static var _idGenerator:IIDGenerator = new IncrementalGenerator();


		/**
		 * The following four first attributes are common to message, presence, and IQ stanzas.
		 * The fifth, xml:lang, is not included here.
		 *
		 * <p>RFC 3920: 9.  XML Stanzas</p>
		 *
		 * <p>After TLS negotiation (Section 5) if desired, SASL negotiation
		 * (Section 6), and Resource Binding (Section 7) if necessary, XML
		 * stanzas can be sent over the streams.  Three kinds of XML stanza are
		 * defined for the 'jabber:client' and 'jabber:server' namespaces:
		 * &gt;message/&lt;, &gt;presence/&lt;, and &gt;iq/&lt;.  In addition, there are five
		 * common attributes for these kinds of stanza.  These common
		 * attributes, as well as the basic semantics of the three stanza kinds,
		 * are defined herein; more detailed information regarding the syntax of
		 * XML stanzas in relation to instant messaging and presence
		 * applications is provided in [XMPP-IM].</p>
		 *
		 * <pre>
		 *           |  initiating to receiving  |  receiving to initiating
		 *  ---------+---------------------------+-----------------------
		 *  to       |  hostname of receiver     |  silently ignored
		 *  from     |  silently ignored         |  hostname of receiver
		 *  id       |  silently ignored         |  session key
		 *  xml:lang |  default language         |  default language
		 *  version  |  signals XMPP 1.0 support |  signals XMPP 1.0 support
		 * </pre>
		 *
		 * @param	recipient	to
		 * @param	sender		from
		 * @param	theType		type
		 * @param	theID		id
		 * @param	nodeName	One of the four ELEMENT_* constants
		 *
		 * @see http://tools.ietf.org/html/rfc3920#section-9
		 */
		public function XMPPStanza( recipient:EscapedJID, sender:EscapedJID, theType:String, theID:String, nodeName:String )
		{
			super();

			if (nodeName != ELEMENT_IQ &&
				nodeName != ELEMENT_MESSAGE &&
				nodeName != ELEMENT_PRESENCE &&
				nodeName != ELEMENT_TEMP)
			{
				throw new Error("nodeName must be one of 'iq', 'message' or 'presence', and in rare cases 'temp'.");
			}

			xml.setLocalName( nodeName );
			to = recipient;
			from = sender;
			type = theType;
			id = theID;
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

		xiff_internal static function generateID( generator:IIDGenerator, prefix:String=null ):String
		{
			var previousPrefix:String = generator.prefix;
			if ( prefix )
			{
				generator.prefix = prefix;
			}
			var id:String = generator.generateID();
			if ( prefix )
			{
				generator.prefix = previousPrefix;
			}
			return id;
		}

		/**
		 * The ID generator for this stanza type.
		 *
		 * <p>ID generators must implement
		 * the IIDGenerator interface. The XIFF library comes with a few default
		 * ID generators that have already been implemented (see org.igniterealtime.xiff.data.id.*).</p>
		 *
		 * <p>Setting the ID generator by stanza type is useful if you'd like to use
		 * different ID generation schemes for each type. For instance, messages could
		 * use the incremental ID generation scheme provided by the IncrementalGenerator class, while
		 * IQs could use the shared object ID generation scheme provided by the SOIncrementalGenerator class.</p>
		 *
		 * @example	The following sets the ID generator for the Message stanza type to an IncrementalGenerator
		 * found in org.igniterealtime.xiff.data.id.IncrementalGenerator:
		 * <pre>Message.idGenerator = new IncrementalGenerator();</pre>
		 * @see org.igniterealtime.xiff.data.id.IIDGenerator
		 */
		public static function get idGenerator():IIDGenerator
		{
			return _idGenerator;
		}
		public static function set idGenerator( value:IIDGenerator ):void
		{
			_idGenerator = value;
		}

		/**
		 * In addition to saving the XML, check for possible Extensions that are registered for listening this XML data.
		 */
		override public function set xml( elem:XML ):void
		{
			super.xml = elem;


			// Check for possible IExtensions in the given incoming "elem"
			for each ( var child:XML in elem.children() )
			{
				if (child.nodeKind() == "element")
				{
					var nName:String = child.localName();
					var nNamespace:Namespace = child.namespace(); // Should this request only the unprefixed namespace?

					trace("XMPPStanza. xml setter. nName: " + nName + ", nNamespace: " + nNamespace);

					if (nNamespace.uri == null || nNamespace.uri == "")
					{
						nNamespace = new Namespace(null, CLIENT_NAMESPACE);
					}

					if ( nName != "error" )
					{
						// Check registered extensions that can be used with the given xml data
						var extClass:Class = ExtensionClassRegistry.lookup(nNamespace.uri, nName);
						if (extClass != null)
						{
							var ext:IExtension = new extClass() as IExtension;
							ext.xml = child;
							addExtension(ext);
						}
					}
				}

			} // for each ...
		}

		/**
		 * The JID of the recipient.
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 */
		public function get to():EscapedJID
		{
			var value:String = getAttribute("to");
			if ( value != null )
			{
				return new EscapedJID(value);
			}
			return null;
		}
		public function set to( value:EscapedJID ):void
		{
			setAttribute("to", value != null ? value.toString() : null);
		}

		/**
		 * The JID of the sender. Most, if not all, server implementations follow the specifications
		 * that prevent this from being falsified. Thus, under normal circumstances, you don't
		 * need to supply this information because the server will fill it in automatically.
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 */
		public function get from():EscapedJID
		{
			var value:String = getAttribute("from");
			if ( value != null )
			{
				return new EscapedJID(value);
			}
			return null;
		}
		public function set from( value:EscapedJID ):void
		{
			setAttribute("from", value != null ? value.toString() : null);
		}

		/**
		 * The stanza type. There are MANY types available, depending on what kind of stanza this is.
		 *
		 * <p>The XIFF Library defines the types for IQ, Presence, and Message in each respective class
		 * as static string variables. Below is a listing of each:</p>
		 *
		 * <b>IQ</b>
		 * <ul>
		 * <li>IQ.TYPE_ERROR</li>
		 * <li>IQ.TYPE_GET</li>
		 * <li>IQ.TYPE_RESULT</li>
		 * <li>IQ.TYPE_SET</li>
		 * </ul>
		 *
		 * <b>Presence</b>
		 * <ul>
		 * <li>Presence.TYPE_ERROR</li>
		 * <li>Presence.TYPE_PROBE</li>
		 * <li>Presence.TYPE_SUBSCRIBE</li>
		 * <li>Presence.TYPE_SUBSCRIBED</li>
		 * <li>Presence.TYPE_UNAVAILABLE</li>
		 * <li>Presence.TYPE_UNSUBSCRIBE</li>
		 * <li>Presence.TYPE_UNSUBSCRIBED</li>
		 * </ul>
		 *
		 * <b>Message</b>
		 * <ul>
		 * <li>Message.TYPE_CHAT</li>
		 * <li>Message.TYPE_ERROR</li>
		 * <li>Message.TYPE_GROUPCHAT</li>
		 * <li>Message.TYPE_HEADLINE</li>
		 * <li>Message.TYPE_NORMAL</li>
		 * </ul>
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 *
		 * <p>RFC: The 'type' attribute specifies detailed information about the purpose
		 * or context of the message, presence, or IQ stanza.  The particular
		 * allowable values for the 'type' attribute vary depending on whether
		 * the stanza is a message, presence, or IQ; the values for message and
		 * presence stanzas are specific to instant messaging and presence
		 * applications and therefore are defined in [XMPP-IM], whereas the
		 * values for IQ stanzas specify the role of an IQ stanza in a
		 * structured request-response "conversation" and thus are defined under
		 * IQ Semantics (Section 9.2.3) below.  The only 'type' value common to
		 * all three stanzas is "error"; see Stanza Errors (Section 9.3).</p>
		 *
		 * @see http://tools.ietf.org/html/rfc3920#section-9.2.3
		 */
		public function get type():String
		{
			return getAttribute("type");
		}
		public function set type( value:String ):void
		{
			setAttribute("type", value);
		}

		/**
		 * The unique identifier of this stanza. ID generation is accomplished using
		 * the static <code>generateID</code> method of the particular stanza type.
		 *
		 * <p>RFC: The optional 'id' attribute MAY be used by a sending entity for
		 * internal tracking of stanzas that it sends and receives (especially
		 * for tracking the request-response interaction inherent in the
		 * semantics of IQ stanzas).  It is OPTIONAL for the value of the 'id'
		 * attribute to be unique globally, within a domain, or within a stream.
		 * The semantics of IQ stanzas impose additional restrictions; see IQ
		 * Semantics (Section 9.2.3).</p>
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 *
		 * @see	#generateID
		 */
		public function get id():String
		{
			return getAttribute("id");
		}
		public function set id( value:String ):void
		{
			setAttribute("id", value);
		}

		/**
		 * The error message, assuming this stanza contains error information.
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 *
		 * <p>This is the <strong>text</strong> element that is a child
		 * of <strong>error</strong> element.</p>
		 *
		 * @see http://tools.ietf.org/html/rfc3920#section-9.3
		 */
		public function get errorMessage():String
		{
			return getChildField("error", "text");
		}
		public function set errorMessage( value:String ):void
		{
			setChildField("error", "text", value); // Should the namespace be added? urn:ietf:params:xml:ns:xmpp-stanzas
		}

		/**
		 * The error condition, assuming this stanza contains error information.
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 *
		 * <p>Error condition should be in lowercase and not contain any whitespace.</p>
		 *
		 * <p>Error element must be qualified by urn:ietf:params:xml:ns:xmpp-stanzas namespace.</p>
		 *
		 * @see http://tools.ietf.org/html/rfc3920#section-9.3.3
		 * @see http://xmpp.org/extensions/xep-0182.html
		 * @see http://xmpp.org/extensions/xep-0086.html
		 *
		 * TODO: Conform spec... find examples
		 */
		public function get errorCondition():String
		{
			// TODO: Add check that this is not the "text" field that would have the same namespace...
			var list:XMLList = xml.children().(localName() == "error");
			if ( list.length() > 0 && list[0].children().length() > 0 )
			{
				return list[0].children()[0].localName();
			}

			return null;
		}
		public function set errorCondition( value:String ):void
		{
			if ( value != null )
			{
				var errorNode:XML = <{ value }/>;
				errorNode.setNamespace("urn:ietf:params:xml:ns:xmpp-stanzas");
				if (errorMessage != null)
				{
					errorNode.appendChild(errorMessage);
				}

				// Add existing attributes
				errorNode.attributes = xml.error.attributes;

				xml.error = errorNode;
			}
			else
			{
				setField("error", errorMessage);
			}

		}

		/**
		 * The error type, assuming this stanza contains error information.
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 *
		 * <p>The value of the <strong>error</strong> element's 'type' attribute
		 * MUST be one of the following:</p>
		 * <ul>
		 * <li>cancel -- do not retry (the error is unrecoverable)</li>
		 * <li>continue -- proceed (the condition was only a warning)</li>
		 * <li>modify -- retry after changing the data sent</li>
		 * <li>auth -- retry after providing credentials</li>
		 * <li>wait -- retry after waiting (the error is temporary)</li>
		 * </ul>
		 *
		 * @see http://tools.ietf.org/html/rfc3920#section-9.3
		 */
		public function get errorType():String
		{
			return getChildAttribute("error", "type");
		}
		public function set errorType( value:String ):void
		{
			// TODO: Check that it is one of the ERROR_*
			setChildAttribute("error", "type", value);
		}

		/**
		 * The error code, assuming this stanza contains error information. Error codes are
		 * deprecated in standard XMPP, but they are commonly used by older Jabber servers
		 * like Jabberd 1.4.
		 *
		 * <p>Use <code>NaN</code> to remove.</p>
		 *
		 * <p>See the link for XEP-0086: Error Condition Mappings</p>
		 *
		 * @see http://xmpp.org/extensions/xep-0086.html
		 */
		public function get errorCode():int
		{
			var code:String = getChildAttribute("error", "code");
			if ( code != null )
			{
				return parseInt(code);
			}
			return NaN;
		}
		public function set errorCode( value:int ):void
		{
			if ( isNaN(value) )
			{
				setChildAttribute("error", "code", null);
			}
			else
			{
				setChildAttribute("error", "code", value.toString());
			}
		}

		/**
		 * Time of the message/presence in case of a delay. Used only for messages
		 * which were sent while user was offline.
		 *
		 * <p>Can be set only via XML as the value should come from the server.</p>
		 *
		 * <p>There are two ways that might be possible coming from the server,
		 * XEP-0203 or XEP-0091, of which the latter is legacy.</p>
		 *
		 * <p>XEP-0203: <code>CCYY-MM-DDThh:mm:ss[.sss]TZD</code></p>
		 * <p>XEP-0091: <code>CCYYMMDDThh:mm:ss</code></p>
		 *
		 * @see http://xmpp.org/extensions/xep-0203.html
		 * @see http://xmpp.org/extensions/xep-0091.html
		 * @see http://xmpp.org/extensions/xep-0082.html
		 */
		protected function get delayedDelivery():Date
		{
			var stamp:Date;
			var list:XMLList = xml.children().(localName() == "delay");
			var legacy:XMLList = xml.children().(localName() == "x");

			if (list.length() > 0 && list[0].attribute("stamp").length() > 0)
			{
				// Current
				// XEP-0203: Delayed Delivery - CCYY-MM-DDThh:mm:ssZ
				stamp = DateTimeParser.string2dateTime(list[0].attribute("stamp")[0]);
			}
			else if (legacy.length() > 0 && legacy[0].attribute("stamp").length() > 0 && legacy[0].namespace().uri == "jabber:x:delay")
			{
				// Legacy
				// XEP-0091: Legacy Delayed Delivery - CCYYMMDDThh:mm:ss
				var value:String = legacy[0].attribute("stamp")[0];
				stamp = DateTimeParser.legacyString2dateTime(legacy[0].attribute("stamp")[0]);
			}
			else
			{
				return null;
			}

			return stamp;
		}
	}
}
