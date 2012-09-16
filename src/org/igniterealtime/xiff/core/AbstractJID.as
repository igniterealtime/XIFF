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
package org.igniterealtime.xiff.core
{
	/**
	 * This is a base class for the JID (Jabber Identifier) classes.
	 *
	 * <p>An XMPP entity is anything that is network-addressable and that can
	 * communicate using XMPP. For historical reasons, the native address
	 * of an XMPP entity is called a Jabber Identifier or JID. </p>
	 *
	 * <p>A valid JID
	 * is a string of [UNICODE] code points, encoded using [UTF-8], and
	 * structured as an ordered sequence of localpart, domainpart, and
	 * resourcepart (where the first two parts are demarcated by the ’&#64;’
	 * character used as a separator, and the last two parts are similarly
	 * demarcated by the ’/’ character).</p>
	 *
	 * <p>This class should not be instantiated directly, but should be subclassed
	 * instead.</p>
	 *
	 * <p>It provides functionality to determine if a JID is valid, as well as extract the
	 * localpart, domain and resource from the JID.</p>
	 *
	 * <p>The structure of JID is defined in RFC6122 (March 2011):</p>
	 * <ul>
	 * <li><code>jid = [ localpart "&#64;" ] domainpart [ "/" resourcepart ]</code></li>
	 * <li><code>localpart = 1*(nodepoint)</code></li>
	 * <li><code>domainpart = IP-literal / IPv4address / ifqdn</code></li>
	 * <li><code>ifqdn = 1*(namepoint)</code></li>
	 * <li><code>resourcepart = 1*(resourcepoint)</code></li>
	 * </ul>
	 *
	 * @exampleText user&#64;host/resource
	 * @exampleText room&#64;service/nick
	 * @see http://tools.ietf.org/html/rfc3920#section-3
	 */
	public class AbstractJID
	{
		private const BYTE_LIMIT_ITEM:uint = 1023;
		private const BYTE_LIMIT_TOTAL:uint = 3071; // 3 * BYTE_LIMIT_ITEM + @ + /

		//TODO: this doesn't actually validate properly in some cases; need separate nodePrep, etc...
		protected static var jidNodeValidator:RegExp = /^([\x29\x23-\x25\x28-\x2E\x30-\x39\x3B\x3D\x3F\x41-\x7E\xA0 \u1680\u202F\u205F\u3000\u2000-\u2009\u200A-\u200B\u06DD \u070F\u180E\u200C-\u200D\u2028-\u2029\u0080-\u009F \u2060-\u2063\u206A-\u206F\uFFF9-\uFFFC\uE000-\uF8FF\uFDD0-\uFDEF \uFFFE-\uFFFF\uD800-\uDFFF\uFFF9-\uFFFD\u2FF0-\u2FFB]{1,1023})/;
		protected var _localpart:String = "";
		protected var _domainpart:String = "";
		protected var _resourcepart:String = "";

		//if we use the literal regexp notation, flex gets confused and thinks the quote starts a string
		private static var quoteregex:RegExp = new RegExp('"', "g");
		private static var quoteregex2:RegExp = new RegExp("'", "g");

		/**
		 * Creates a new AbstractJID object. Used via EscapedJID or UnescapedJID.
		 *
		 * @param	inJID The JID as a String.
		 * @param	validate True if the JID should be validated.
		 */
		public function AbstractJID( inJID:String, validate:Boolean = false )
		{
			if (validate)
			{
				if (!jidNodeValidator.test(inJID) || inJID.indexOf(" ") > -1 || inJID.length > BYTE_LIMIT_TOTAL)
				{
					trace("Invalid JID: %s", inJID);
					throw "Invalid JID";
				}
			}
			var separatorIndex:int = inJID.lastIndexOf("@");
			var slashIndex:int = inJID.lastIndexOf("/");

			if (slashIndex >= 0)
			{
				_resourcepart = inJID.substring(slashIndex + 1);
			}

			_domainpart = inJID.substring(separatorIndex + 1, slashIndex >= 0 ? slashIndex : inJID.length);

			if (separatorIndex >= 1)
			{
				_localpart = inJID.substring(0, separatorIndex);
			}
		}

		/**
		 * Provides functionality to convert a JID to an escaped format.
		 *
		 * @param	n The string to escape.
		 *
		 * @return The escaped string.
		 *
		 * TODO: simplify with native methods
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/package.html#encodeURIComponent%28%29
		 */
		public static function escapedNode( n:String ):String
		{
			if( n && (
				n.indexOf("@") >= 0 ||
				n.indexOf(" ") >= 0 ||
				n.indexOf("\\")>= 0 ||
				n.indexOf("/") >= 0 ||
				n.indexOf("&") >= 0 ||
				n.indexOf("'") >= 0 ||
				n.indexOf('"') >= 0 ||
				n.indexOf(":") >= 0 ||
				n.indexOf("<") >= 0 ||
				n.indexOf(">") >= 0))
			{
				n = n.replace(/\\/g, "\\5c");
				n = n.replace(/@/g, "\\40");
				n = n.replace(/ /g, "\\20");
				n = n.replace(/&/g, "\\26");
				n = n.replace(/\>/g, "\\3e");
				n = n.replace(/</g, "\\3c");
				n = n.replace(/:/g, "\\3a");
				n = n.replace(/\//g, "\\2f");
				n = n.replace(quoteregex, "\\22");
				n = n.replace(quoteregex2, "\\27");
			}
			return n;
		}

		/**
		 * Provides functionality to return an escaped JID into a normal String.
		 *
		 * @param	n The string to unescape.
		 *
		 * @return The unescaped string.
		 */
		public static function unescapedNode( n:String ):String
		{
			if( n && (
				n.indexOf("\\40") >= 0 ||
				n.indexOf("\\20") >= 0 ||
				n.indexOf("\\26") >= 0 ||
				n.indexOf("\\3e") >= 0 ||
				n.indexOf("\\3c") >= 0 ||
				n.indexOf("\\5c") >= 0 ||
				n.indexOf("\\3a") >= 0 ||
				n.indexOf("\\2f") >= 0 ||
				n.indexOf("\\22") >= 0 ||
				n.indexOf("\\27") >= 0) )
			{
				n = n.replace(/\40/g, "@");
				n = n.replace(/\20/g, " ");
				n = n.replace(/\26/g, "&");
				n = n.replace(/\3e/g, ">");
				n = n.replace(/\3c/g, "<");
				n = n.replace(/\3a/g, ":");
				n = n.replace(/\2f/g, "/");
				n = n.replace(quoteregex, '"');
				n = n.replace(quoteregex2, "'");
				n = n.replace(/\5c/g, "\\");
			}
			return n;
		}

		/**
		 * Converts JID represented by this class to a String.
		 *
		 * @return The JID as a String.
		 */
		public function toString():String
		{
			var j:String = "";
			if (localpart)
			{
				j += localpart + "@";
			}
			j += domain;
			if (resource)
			{
				j += "/" + resource;
			}

			return j;
		}

		/**
		 * The JID without the resource.
		 */
		public function get bareJID():String
		{
			var str:String = toString();
			var slashIndex:int = str.lastIndexOf("/");
			if (slashIndex > 0)
			{
				str = str.substring(0, slashIndex);
			}
			return str;
		}

		/**
		 * The resource portion of the JID.
		 *
		 * <p>Ensure that the resourcepart of an XMPP address is at
		 * least one byte in length and at most 1023 bytes in length.</p>
		 *
		 * <p>The resourcepart of a JID is an optional identifier placed after the
		 * domainpart and separated from the latter by the ’/’ character. A
		 * resourcepart can modify either a &lt;localpart&#64;domainpart&gt; address or a
		 * mere &lt;domainpart&gt; address. Typically a resourcepart uniquely
		 * identifies a specific connection (e.g., a device or location) or
		 * object (e.g., an occupant in a multi-user chat room) belonging to the
		 * entity associated with an XMPP localpart at a domain (i.e.,
		 * &lt;localpart&#64;domainpart/resourcepart&gt;).</p>
		 *
		 * <p>A resourcepart MUST be formatted such that the Resourceprep profile
		 * of [STRINGPREP] can be applied without failing (see Appendix B).
		 * Before comparing two resourceparts, an application MUST first ensure
		 * that the Resourceprep profile has been applied to each identifier
		 * (the profile need not be applied each time a comparison is made, as
		 * long as it has been applied before comparison).</p>
		 *
		 * <p>A resourcepart MUST NOT be zero bytes in length and MUST NOT be more
		 * than 1023 bytes in length. This rule is to be enforced after any
		 * mapping or normalization resulting from application of the
		 * Resourceprep profile of stringprep (e.g., in Resourceprep some
		 * characters can be mapped to nothing, which might result in a string
		 * of zero length).</p>
		 *
		 * <p>Informational Note: For historical reasons, the term "resource
		 * identifier" is often used in XMPP to refer to the optional portion
		 * of an XMPP address that follows the domainpart and the "/"
		 * separator character; to help prevent confusion between an XMPP
		 * "resource identifier" and the meanings of "resource" and
		 * "identifier" provided in Section 1.1 of [URI], this specification
		 * uses the term "resourcepart" instead of "resource identifier" (as
		 * in RFC 3920).</p>
		 *
		 * <p>XMPP entities SHOULD consider resourceparts to be opaque strings and
		 * SHOULD NOT impute meaning to any given resourcepart. In particular:</p>
		 *
		 * <ul>
		 * <li>Use of the ’/’ character as a separator between the domainpart and
		 * the resourcepart does not imply that XMPP addresses are
		 * hierarchical in the way that, say, HTTP addresses are
		 * hierarchical; thus for example an XMPP address of the form
		 * &lt;localpart&#64;domainpart/foo/bar&gt; does not identify a resource "bar"
		 * that exists below a resource "foo" in a hierarchy of resources
		 * associated with the entity "localpart&#64;domain".</li>
		 * <li>The ’&#64;’ character is allowed in the resourcepart and is often used
		 * in the "nick" shown in XMPP chatrooms. For example, the JID
		 * &lt;room&#64;chat.example.com/user&#64;host&gt; describes an entity who is an
		 * occupant of the room &lt;room&#64;chat.example.com&gt; with an (asserted)
		 * nick of &lt;user&#64;host&gt;. However, chatroom services do not
		 * necessarily check such an asserted nick against the occupant’s
		 * real JID.</li>
		 * </ul>
		 *
		 * @see http://tools.ietf.org/html/rfc6122#section-2.4
		 */
		public function get resource():String
		{
			if (_resourcepart.length > 0)
			{
				return _resourcepart;
			}
			return null;
		}
		public function set resource(value:String):void
		{
			if (value == null || value.length > BYTE_LIMIT_ITEM)
			{
				throw new Error("JID resource value of wrong type");
			}
			_resourcepart = value;
		}

		/**
		 * The localpart (used to be called 'node') portion of the JID.
		 *
		 * <p>Ensure that the localpart of an XMPP address is at
		 * least one byte in length and at most 1023 bytes in length.</p>
		 *
		 * <p>The localpart of a JID is an optional identifier placed before the
		 * domainpart and separated from the latter by the ’&#64;’ character.
		 * Typically a localpart uniquely identifies the entity requesting and
		 * using network access provided by a server (i.e., a local account),
		 * although it can also represent other kinds of entities (e.g., a chat
		 * room associated with a multi-user chat service). The entity
		 * represented by an XMPP localpart is addressed within the context of a
		 * specific domain (i.e., &lt;localpart&#64;domainpart&gt;).</p>
		 *
		 * <p>A localpart MUST be formatted such that the Nodeprep profile of
		 * [STRINGPREP] can be applied without failing (see Appendix A). Before
		 * comparing two localparts, an application MUST first ensure that the
		 * Nodeprep profile has been applied to each identifier (the profile
		 * need not be applied each time a comparison is made, as long as it has
		 * been applied before comparison).</p>
		 *
		 * <p>A localpart MUST NOT be zero bytes in length and MUST NOT be more
		 * than 1023 bytes in length. This rule is to be enforced after any
		 * mapping or normalization resulting from application of the Nodeprep
		 * profile of stringprep (e.g., in Nodeprep some characters can be
		 * mapped to nothing, which might result in a string of zero length).</p>
		 *
		 * @see http://tools.ietf.org/html/rfc6122#section-2.3
		 */
		public function get localpart():String
		{
			if (_localpart.length > 0)
			{
				return _localpart;
			}
			return null;
		}
		public function set localpart(value:String):void
		{
			if (value == null || value.length > BYTE_LIMIT_ITEM)
			{
				throw new Error("JID localpart value of wrong type");
			}
			_localpart = value;
		}

		/**
		 * The domain portion of the JID.
		 *
		 * <p>Ensure that the domainpart of an XMPP address is at
		 * least one byte in length and at most 1023 bytes in length, and
		 * conforms to the underlying length limits of the DNS.</p>
		 *
		 * <p>The domainpart of a JID is that portion after the ’&#64;’ character (if
		 * any) and before the ’/’ character (if any); it is the primary
		 * identifier and is the only REQUIRED element of a JID (a mere
		 * domainpart is a valid JID). Typically a domainpart identifies the
		 * "home" server to which clients connect for XML routing and data
		 * management functionality. However, it is not necessary for an XMPP
		 * domainpart to identify an entity that provides core XMPP server
		 * functionality (e.g., a domainpart can identify an entity such as a
		 * multi-user chat service, a publish-subscribe service, or a user
		 * directory).</p>
		 *
		 * <p>The domainpart for every XMPP service MUST be a fully qualified
		 * domain name (FQDN; see [DNS]), IPv4 address, IPv6 address, or
		 * unqualified hostname (i.e., a text label that is resolvable on a
		 * local network).</p>
		 *
		 * <p>Interoperability Note: Domainparts that are IP addresses might not
		 * be accepted by other services for the sake of server-to-server
		 * communication, and domainparts that are unqualified hostnames
		 * cannot be used on public networks because they are resolvable only
		 * on a local network.</p>
		 *
		 * <p>If the domainpart includes a final character considered to be a label
		 * separator (dot) by [IDNA2003] or [DNS], this character MUST be
		 * stripped from the domainpart before the JID of which it is a part is
		 * used for the purpose of routing an XML stanza, comparing against
		 * another JID, or constructing an [XMPP-URI]. In particular, the
		 * character MUST be stripped before any other canonicalization steps
		 * are taken, such as application of the [NAMEPREP] profile of
		 * [STRINGPREP] or completion of the ToASCII operation as described in
		 * [IDNA2003].</p>
		 *
		 * <p>A domainpart consisting of a fully qualified domain name MUST be an
		 * "internationalized domain name" as defined in [IDNA2003]; that is, it
		 * MUST be "a domain name in which every label is an internationalized
		 * label" and MUST follow the rules for construction of
		 * internationalized domain names specified in [IDNA2003]. When
		 * preparing a text label (consisting of a sequence of UTF-8 encoded
		 * Unicode code points) for representation as an internationalized label
		 * in the process of constructing an XMPP domainpart or comparing two
		 * XMPP domainparts, an application MUST ensure that for each text label
		 * it is possible to apply without failing the ToASCII operation
		 * specified in [IDNA2003] with the UseSTD3ASCIIRules flag set (thus
		 * forbidding ASCII code points other than letters, digits, and
		 * hyphens). If the ToASCII operation can be applied without failing,
		 * then the label is an internationalized label. (Note: The ToASCII
		 * operation includes application of the [NAMEPREP] profile of
		 * [STRINGPREP] and encoding using the algorithm specified in
		 * [PUNYCODE]; for details, see [IDNA2003].) Although XMPP applications
		 * do not communicate the output of the ToASCII operation (called an
		 * "ACE label") over the wire, it MUST be possible to apply that
		 * operation without failing to each internationalized label. If an
		 * XMPP application receives as input an ACE label, it SHOULD convert
		 * that ACE label to an internationalized label using the ToUnicode
		 * operation (see [IDNA2003]) before including the label in an XMPP
		 * domainpart that will be communicated over the wire on an XMPP network
		 * (however, instead of converting the label, there are legitimate
		 * reasons why an application might instead refuse the input altogether
		 * and return an error to the entity that provided the offending data).</p>
		 *
		 * <p>A domainpart MUST NOT be zero bytes in length and MUST NOT be more
		 * than 1023 bytes in length. This rule is to be enforced after any
		 * mapping or normalization resulting from application of the Nameprep
		 * profile of stringprep (e.g., in Nameprep some characters can be
		 * mapped to nothing, which might result in a string of zero length).
		 * Naturally, the length limits of [DNS] apply, and nothing in this
		 * document is to be interpreted as overriding those more fundamental
		 * limits.</p>
		 *
		 * <p>In the terms of IDNA2008 [IDNA-DEFS], the domainpart of a JID is a
		 * "domain name slot".</p>
		 *
		 * @see http://tools.ietf.org/html/rfc6122#section-2.2
		 */
		public function get domain():String
		{
			return _domainpart;
		}
		public function set domain(value:String):void
		{
			if (value == null || value.length > BYTE_LIMIT_ITEM)
			{
				throw new Error("JID domain value of wrong type");
			}
			_domainpart = value;
		}
	}
}
