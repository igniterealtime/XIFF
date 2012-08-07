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
package org.igniterealtime.xiff.data.si
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * XEP-0095: Stream Initiation
	 *
	 * <p>To be used with XEP-0096: SI File Transfer</p>
	 *
	 * <p>The <strong>si</strong> element is the root element for this
	 * protocol. It is an identifiable container for all the information
	 * necessary for negotiation and signalling. It contains attributes
	 * for the identifier, intended MIME-type, and profile. The contents
	 * convey stream-negotation and profile information.</p>
	 *
	 * <p>When the Sender first negotiates a Stream Initiation, all of the
	 * attributes SHOULD be present, and the id" and "profile" MUST be
	 * present. The contents MUST contain one profile, in the namespace
	 * declared in the "profile" attribute, and the feature negotiation
	 * for the stream. The feature negotiation MUST contain at least one
	 * option and use the field var "stream-method".</p>
	 *
	 * <p>When the Receiver accepts a Stream Initiation, the
	 * <strong>si</strong> element SHOULD NOT possess any attributes.
	 * The selected stream MUST be in the feature negotiation for the
	 * stream. There MUST only be one selected stream.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0095.html
	 */
	public class StreamInitiationExtension extends Extension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/si";
		public static const ELEMENT_NAME:String = "si";

		/**
		 * The SUGGESTED format for profile namespaces is, followed by the profile name.
		 *
		 * @see http://xmpp.org/registrar/si-profiles.html
		 */
		public static const PROFILE_PREFIX:String = "http://jabber.org/protocol/si/profile/";

		/**
		 * @param	parent
		 */
		public function StreamInitiationExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return StreamInitiationExtension.NS;
		}

		public function getElementName():String
		{
			return StreamInitiationExtension.ELEMENT_NAME;
		}

		/**
		 * The "id" attribute is an opaque identifier.
		 *
		 * <p>This attribute MUST be present on type='set',
		 * and MUST be a valid string. This SHOULD NOT be sent back on
		 * type='result', since the <strong>iq</strong> "id" attribute
		 * provides the only context needed. This value is generated
		 * by the Sender, and the same value MUST be used throughout
		 * a session when talking to the Receiver.</p>
		 */
		public function get id():String
		{
			return getAttribute("id");
		}
		public function set id(value:String):void
		{
			setAttribute("id", value);
		}

		/**
		 * The "mime-type" attribute identifies the MIME-type for
		 * the data across the stream.
		 *
		 * <p>This attribute MUST be a valid MIME-type as registered
		 * with the Internet Assigned Numbers Authority (IANA).</p>
		 *
		 * <p>During negotiation, this attribute SHOULD be present, and is
		 * otherwise not required. If not included during negotiation, its value
		 * is assumed to be "application/octet-stream".</p>
		 *
		 * @see http://www.iana.org/assignments/media-types
		 */
		public function get mimeType():String
		{
			return getAttribute("mime-type");
		}
		public function set mimeType(value:String):void
		{
			setAttribute("mime-type", value);
		}

		/**
		 * The "profile" attribute defines the SI profile in use.
		 *
		 * <p>This value MUST be present during negotiation,
		 * and is the namespace of the profile to use.</p>
		 *
		 * <p>TODO: Check validity against PROFILE_PREFIX.</p>
		 */
		public function get profile():String
		{
			return getAttribute("profile");
		}
		public function set profile(value:String):void
		{
			setAttribute("profile", value);
		}
	}
}
