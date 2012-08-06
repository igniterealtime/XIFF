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

	/**
	 * This class provides encapsulation for manipulation of presence data for sending and receiving.
	 *
	 * <p>2.2.1.  Types of Presence</p>
	 *
	 * <p>The 'type' attribute of a presence stanza is OPTIONAL.  A presence
	 * stanza that does not possess a 'type' attribute is used to signal to
	 * the server that the sender is online and available for communication.
	 * If included, the 'type' attribute specifies a lack of availability, a
	 * request to manage a subscription to another entity's presence, a
	 * request for another entity's current presence, or an error related to
	 * a previously-sent presence stanza.  If included, the 'type' attribute
	 * MUST have one of the following values:</p>
	 * <p>
	 * o  unavailable -- Signals that the entity is no longer available for communication.<br />
	 * o  subscribe -- The sender wishes to subscribe to the recipient's presence.<br />
	 * o  subscribed -- The sender has allowed the recipient to receive their presence.<br />
	 * o  unsubscribe -- The sender is unsubscribing from another entity's presence.<br />
	 * o  unsubscribed -- The subscription request has been denied or a previously-granted subscription has been cancelled.<br />
	 * o  probe -- A request for an entity's current presence; SHOULD be generated only by a server on behalf of a user.<br />
	 * o  error -- An error has occurred regarding processing or delivery of a previously-sent presence stanza.</p>
	 *
	 * <p>For detailed information regarding presence semantics and the
	 * subscription model used in the context of XMPP-based instant
	 * messaging and presence applications, refer to Exchanging Presence
	 * Information (Section 5) and Managing Subscriptions (Section 6).</p>

	 * @see http://tools.ietf.org/html/rfc3921
	 */
	public class Presence extends XMPPStanza implements IPresence
	{
		/**
		 * An error has occurred regarding processing of a
		 * previously-sent presence stanza; if the presence stanza is of type
		 * "error", it MUST include an error child element.
		 */
		public static const TYPE_ERROR:String = "error";

		/**
		 * A request for an entity's current presence; SHOULD be
		 * generated only by a server on behalf of a user.
		 */
		public static const TYPE_PROBE:String = "probe";

		/**
		 * The sender wishes to subscribe to the recipient's
		 * presence.
		 */
		public static const TYPE_SUBSCRIBE:String = "subscribe";

		/**
		 * The sender has allowed the recipient to receive their presence.
		 */
		public static const TYPE_SUBSCRIBED:String = "subscribed";

		/**
		 * Signals that the entity is no longer available for communication.
		 */
		public static const TYPE_UNAVAILABLE:String = "unavailable";

		/**
		 *  The sender is unsubscribing from the receiver's presence.
		 */
		public static const TYPE_UNSUBSCRIBE:String = "unsubscribe";

		/**
		 * The subscription request has been denied or a
		 * previously-granted subscription has been cancelled.
		 */
		public static const TYPE_UNSUBSCRIBED:String = "unsubscribed";

		/**
		 * The entity or resource is temporarily away.
		 */
		public static const SHOW_AWAY:String = "away";

		/**
		 * The entity or resource is actively interested in chatting.
		 */
		public static const SHOW_CHAT:String = "chat";

		/**
		 * The entity or resource is busy (dnd = "Do Not Disturb").
		 */
		public static const SHOW_DND:String = "dnd";

		/**
		 * The entity or resource is away for an extended period (xa = "eXtended Away").
		 */
		public static const SHOW_XA:String = "xa";

		/**
		 * According to Google Talk developers via their presentation [somewhere few years ago],
		 * most of the XMPP related traffic in their service is made by Presence.
		 *
		 * <p>The <strong>presence</strong> element can be seen as a basic broadcast or
		 * "publish-subscribe" mechanism, whereby multiple entities receive
		 * information about an entity to which they have subscribed (in this
		 * case, network availability information).  In general, a publishing
		 * entity SHOULD send a presence stanza with no 'to' attribute, in which
		 * case the server to which the entity is connected SHOULD broadcast or
		 * multiplex that stanza to all subscribing entities.  However, a
		 * publishing entity MAY also send a presence stanza with a 'to'
		 * attribute, in which case the server SHOULD route or deliver that
		 * stanza to the intended recipient.  See Server Rules for Handling XML
		 * Stanzas (Section 10) for general routing and delivery rules related
		 * to XML stanzas, and [XMPP-IM] for presence-specific rules in the
		 * context of an instant messaging and presence application.</p>
		 *
		 * @param	recipient The recipient of the presence, usually in the form of a JID.
		 * @param	sender The sender of the presence, usually in the form of a JID.
		 * @param	presenceType The type of presence as a string. There are predefined static variables for
		 * @param	showVal What to show for this presence (away, online, etc.) There are predefined static variables for
		 * @param	statusVal The status; usually used for the "away message."
		 * @param	priorityVal The priority of this presence; usually on a scale of 1-5.
		 */
		public function Presence( recipient:EscapedJID = null, sender:EscapedJID = null, presenceType:String = null, showVal:String = null, statusVal:String = null, priorityVal:int = 0 )
		{
			super( recipient, sender, presenceType, null, XMPPStanza.ELEMENT_PRESENCE );

			show = showVal;
			status = statusVal;
			priority = priorityVal;
		}

		/**
		 * The show value; away, online, etc. There are predefined static variables in the Presence
		 * class for this:
		 * <ul>
		 * <li>Presence.SHOW_AWAY</li>
		 * <li>Presence.SHOW_CHAT</li>
		 * <li>Presence.SHOW_DND</li>
		 * <li>Presence.SHOW_XA</li>
		 * </ul>
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 */
		public function get show():String
		{
			return getField("show");
		}
		public function set show( value:String ):void
		{
			if (value != SHOW_AWAY
				&& value != SHOW_CHAT
				&& value != SHOW_DND
				&& value != SHOW_XA
				&& value != null)
			{
				throw new Error("Invalid show value: " + value + " for Presence");
			}

			setField("show", value);
		}

		/**
		 * The status; usually used for "away messages."
		 *
		 * <p>The OPTIONAL status element contains XML character data specifying
		 * a natural-language description of availability status.  It is
		 * normally used in conjunction with the show element to provide a
		 * detailed description of an availability state (e.g., "In a meeting").
		 * The <strong>status</strong> element MUST NOT possess any attributes, with the
		 * exception of the 'xml:lang' attribute.  Multiple instances of the
		 * <strong>status</strong> element MAY be included but only if each instance possesses
		 * an 'xml:lang' attribute with a distinct language value.</p>
		 *
		 * <p>Use <code>null</code> to remove.</p>
		 */
		public function get status():String
		{
			return getField("status");
		}
		public function set status( value:String ):void
		{
			setField("status", value);
		}

		/**
		 * The priority of the presence, usually on a scale of 1-5.
		 *
		 * <p>RFC: "The value MUST be an integer between -128 and +127".</p>
		 * <p>If no priority is provided,
		 * a server SHOULD consider the priority to be zero.</p>
		 *
		 * <p>Use <code>NaN</code> or <code>0</code> to remove.</p>
		 */
		public function get priority():int
		{
			var list:XMLList = xml.children().(localName() == "priority");
			if ( list.length() > 0 )
			{
				return parseInt(list[0]);
			}

			return NaN;
		}
		public function set priority( value:int ):void
		{
			if (isNaN(value) || value == 0)
			{
				delete xml.priority;
				return;
			}

			if ( -129 < value && value < 128)
			{
				xml.priority = value.toString();
			}
			else
			{
				throw new Error("Invalid priority value: " + value.toString() + " for Presence. Must be between -128 and 127.");
			}
		}

		/**
		 * Time of the presence in case of a delay. Used only for messages
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
		 */
		public function get time():Date
		{
			return delayedDelivery;
		}
	}
}
