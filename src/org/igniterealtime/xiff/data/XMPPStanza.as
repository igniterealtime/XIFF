/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
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

	/**
	 * The base class for all XMPP stanza data classes.
	 *
	 * @see http://xmpp.org/rfcs/rfc3920.html#stanzas
	 */
	public dynamic class XMPPStanza extends XMLStanza implements ISerializable, IExtendable
	{
		public static const CLIENT_NAMESPACE:String = "jabber:client";

		/**
		 * The version of XMPP specified in RFC 3920 is "1.0"; in particular, this
		 * encapsulates the stream-related protocols (Use of TLS (Section 5),
		 * Use of SASL (Section 6), and Stream Errors (Section 4.7)), as well as
		 * the semantics of the three defined XML stanza types (message,
		 * presence, and iq).
		 */
		public static const CLIENT_VERSION:String = "1.0";

		public static const NAMESPACE_FLASH:String = "http://www.jabber.com/streams/flash";

		public static const NAMESPACE_STREAM:String = "http://etherx.jabber.org/streams";

		public static const XML_LANG:String = "en";

		private var _errorNode:XML;

		private var _errorConditionNode:XML;

		//private static var theIDGenerator:IIDGenerator = new IncrementalGenerator();
		private static var staticDependencies:Array = [ IncrementalGenerator, ExtensionContainer ];

		private static var isStaticConstructed:* = XMPPStanzaStaticConstructor();

		/**
		 * The following four first attributes are common to message, presence, and IQ stanzas.
		 * The fifth, xml:lang, is not included here.
		 * @param	recipient	to
		 * @param	sender		from
		 * @param	theType		type
		 * @param	theID		id
		 * @param	nName		Name of the node
		 */
		public function XMPPStanza( recipient:EscapedJID, sender:EscapedJID, 
			theType:String, theID:String, nName:String )
		{
			super();

			node.setName( nName );
			to = recipient;
			from = sender;
			type = theType;
			id = theID;
		}

		private static function XMPPStanzaStaticConstructor():void
		{
			//ExtensionContainer.decorate(XMPPStanza.prototype);
		}

		/**
		 * (Static method) Generates a unique ID for the stanza. ID generation is handled using
		 * a variety of mechanisms, but the default for the library uses the IncrementalGenerator.
		 *
		 * @see	org.igniterealtime.xiff.data.id.IncrementalGenerator
		 * @param	prefix The prefix for the ID to be generated
		 * @return The generated ID
		 */
		public static function generateID( prefix:String ):String
		{
			var id:String = IncrementalGenerator.getInstance().getID( prefix );
			return id;
		}

		/**
		 * (Static method) Sets the ID generator for this stanza type. ID generators must implement
		 * the IIDGenerator interface. The XIFF library comes with a few default
		 * ID generators that have already been implemented (see org.igniterealtime.xiff.data.id.*).
		 *
		 * Setting the ID generator by stanza type is useful if you'd like to use
		 * different ID generation schemes for each type. For instance, messages could
		 * use the incremental ID generation scheme provided by the IncrementalGenerator class, while
		 * IQs could use the shared object ID generation scheme provided by the SharedObjectGenerator class.
		 *
		 * @param	generator The ID generator class
		 * @example	The following sets the ID generator for the Message stanza type to the IncrementalGenerator
		 * class found in org.igniterealtime.xiff.data.id.IncrementalGenerator:
		 * <pre>Message.setIDGenerator( org.igniterealtime.xiff.data.id.IncrementalGenerator );</pre>
		 */
		public static function setIDGenerator( generator:IIDGenerator ):void
		{
			//XMPPStanza.theIDGenerator = generator;
		}

		/**
		 * Prepares the XML version of the stanza for transmission to the server.
		 *
		 * @param	parentNode The parent node that the stanza should be appended to during serialization
		 * @return An indication as to whether serialization was successful
		 */
		public function serialize( parentNode:XML ):Boolean
		{
			var exts:Array = getAllExtensions();
			trace("XMPPStanza.serialize. exts: " + exts);
			
			for each ( var ext:ISerializable in exts )
			{
				ext.serialize( node );
			}

			trace("XMPPStanza.serialize. node: " + node.toXMLString() + ", parentNode: " + parentNode.toXMLString() + ", node.parent(): " + node.parent());
			
			if ( parentNode != node.parent() )
			{
				parentNode.appendChild( node );
			}
			trace("XMPPStanza.serialize. parentNode: " + parentNode.toXMLString() + ", node.parent(): " + node.parent());
			

			return true;
		}

		/**
		 * 
		 * @param	xmlNode
		 * @return
		 */
		public function deserialize( xmlNode:XML ):Boolean
		{
			node = xmlNode;

			var children:XMLList = node.children();
			for each ( var child:XML in children )
			{

				var nName:String = child.localName();
				var nNamespace:String = child.@xmlns.toString();

				nNamespace = exists( nNamespace ) ? nNamespace : CLIENT_NAMESPACE;

				if ( nName == "error" )
				{
					_errorNode = child;
					// If there is an error condition node, then we need that saved as well
					if ( exists( _errorNode[ 0 ].name() ) )
					{
						_errorConditionNode = _errorNode[ 0 ];
					}
				}
				else
				{
					var extClass:Class = ExtensionClassRegistry.lookup( nNamespace );
					if ( extClass != null )
					{
						var ext:IExtension = new extClass();
						ISerializable( ext ).deserialize( child );
						addExtension( ext );
					}
				}
			}
			return true;
		}

		/**
		 * The JID of the recipient.
		 *
		 */
		public function get to():EscapedJID
		{
			var value:EscapedJID;
			if ( node.@to.length() == 1 )
			{
				value = new EscapedJID( node.@to );
			}
			return value;
		}

		public function set to( value:EscapedJID ):void
		{
			delete node.@to;
			if ( exists( value ) )
			{
				node.@to = value.toString();
			}
		}

		/**
		 * The JID of the sender. Most, if not all, server implementations follow the specifications
		 * that prevent this from being falsified. Thus, under normal circumstances, you don't
		 * need to supply this information because the server will fill it in automatically.
		 *
		 */
		public function get from():EscapedJID
		{
			var value:EscapedJID;
			if ( node.@from.length() == 1 )
			{
				value = new EscapedJID( node.@from );
			}
			return value;
		}

		public function set from( value:EscapedJID ):void
		{
			delete node.@from;
			if ( exists( value ) )
			{
				node.@from = value.toString();
			}
		}

		/**
		 * The stanza type. There are MANY types available, depending on what kind of stanza this is.
		 * The XIFF Library defines the types for IQ, Presence, and Message in each respective class
		 * as static string variables. Below is a listing of each:
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
		 */
		public function get type():String
		{
			return node.@type;
		}

		public function set type( value:String ):void
		{
			delete node.@type;
			if ( exists( value ) )
			{
				node.@type = value;
			}
		}

		/**
		 * The unique identifier of this stanza. ID generation is accomplished using
		 * the static <code>generateID</code> method.
		 *
		 * @see	#generateID
		 */
		public function get id():String
		{
			return node.@id;
		}

		public function set id( value:String ):void
		{
			delete node.@id;
			if ( exists( value ) )
			{
				node.@id = value;
			}
		}

		/**
		 * The error message, assuming this stanza contains error information.
		 * @see http://tools.ietf.org/html/draft-ietf-xmpp-3920bis-00#section-9.3.4
		 */
		public function get errorMessage():String
		{
			if ( exists( errorCondition ) )
			{
				return errorCondition.toString();
			}
			else if ( _errorNode && _errorNode[ 0 ] )
			{
				return node.error;
			}
			return null;
		}

		public function set errorMessage( value:String ):void
		{
			value = exists( value ) ? value : "";

			if ( exists( errorCondition ) )
			{
				_errorConditionNode = replaceTextNode( _errorNode, _errorConditionNode,
													   errorCondition, value );
			}
			else
			{
				node.error = value;
			}
		}

		/**
		 * The error condition, assuming this stanza contains error information.
		 * @see http://tools.ietf.org/html/draft-ietf-xmpp-3920bis-00#section-9.3.3
		 */
		public function get errorCondition():String
		{
			// @xmlns = urn:ietf:params:xml:ns:xmpp-stanzas
			return node.error.children()[0].localName().toString();
		}

		public function set errorCondition( value:String ):void
		{
			// A message might exist, so remove it first
			var attributes:Object = _errorNode.attributes();
			var msg:String = errorMessage;

			if ( exists( value ) )
			{
				var condition:XML = <{ value }/>;
				condition.setChildren( msg );
				node.error.setChildren( condition );
			}
			else
			{
				node.error = msg;
			}

			_errorNode.attributes = attributes;
		}

		/**
		 * The error type, assuming this stanza contains error information.
		 * <p>The "error-type MUST be one of the following:</p>
		 * <ul>
		 * <li>auth -- retry after providing credentials</li>
		 * <li>cancel -- do not retry (the error cannot be remedied)</li>
		 * <li>continue -- proceed (the condition was only a warning)</li>
		 * <li>modify -- retry after changing the data sent</li>
		 * <li>wait -- retry after waiting (the error is temporary)</li>
		 * </ul>
		 */
		public function get errorType():String
		{
			return node.error.@type;
		}

		public function set errorType( value:String ):void
		{
			delete node.error.@type;
			if ( exists( value ) )
			{
				node.error.@type = value;
			}
		}

		/**
		 * The error code, assuming this stanza contains error information. Error codes are
		 * deprecated in standard XMPP, but they are commonly used by older Jabber servers
		 * like Jabberd 1.4. Value usually 300...510.
		 * @see http://xmpp.org/extensions/xep-0086.html
		 */
		public function get errorCode():int
		{
			return parseInt( _errorNode.@code );
		}
		
		public function set errorCode( value:int ):void
		{
			delete node.error.@code;
			if ( exists( value ) )
			{
				node.error.@code = value;
			}
		}
	}
}
