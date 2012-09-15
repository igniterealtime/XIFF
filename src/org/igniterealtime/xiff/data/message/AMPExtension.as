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
package org.igniterealtime.xiff.data.message
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.core.UnescapedJID;

	/**
	 * XEP-0079: Advanced Message Processing
	 *
	 * <p>All delivery semantics are encapsulated in the
	 * <strong>amp</strong> element. This element contains one or more
	 * <strong>rule</strong> elements specifying the specific rules to
	 * process. It can optionally possess attributes about the current
	 * status, the original sender and recipient, and route applicability.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0079.html
	 */
	public class AMPExtension extends Extension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/amp";
		public static const ELEMENT_NAME:String = "amp";

		/**
		 *
		 * @param	parent
		 */
		public function AMPExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return AMPExtension.NS;
		}

		public function getElementName():String
		{
			return AMPExtension.ELEMENT_NAME;
		}

		/**
		 * The 'status' attribute specifies the reason for this
		 * <strong>amp</strong> element. When specifying semantics to be
		 * applied (client to server), this attribute MUST NOT be present.
		 * When replying to a sending entity regarding a met condition, this
		 * attribute MUST be present and SHOULD be the value of the 'action'
		 * attribute for the triggered rule. (Note: Individual action
		 * definitions MAY provide their own requirements.)
		 */
		public function get status():String
		{
			return getAttribute("status");
		}
		public function set status( value:String ):void
		{
			setAttribute("status", value);
		}

		/**
		 * The 'to' attribute specifies the original (intended) recipient of
		 * the containing <strong>message</strong> stanza.
		 *
		 * <p>This attribute MUST be specified for any
		 * <strong>message</strong> stanza sent from a
		 * supporting server, regardless of the recipient. It SHOULD NOT be
		 * specified otherwise. The value of the 'to' attribute MUST be the
		 * full JID (localpart&#64;domain/resource) of the intended recipient for the
		 * original <strong>message</strong> stanza.</p>
		 */
		public function get to():UnescapedJID
		{
			var value:String = getAttribute("to");
			if ( value != null )
			{
				return new UnescapedJID(value);
			}
			return null;
		}
		public function set to( value:UnescapedJID ):void
		{
			setAttribute("to", value != null ? value.toString() : null);
		}

		/**
		 * The 'from' attribute specifies the original sender of the
		 * containing <strong>message</strong> stanza. This attribute MUST
		 * be specified for any <strong>message</strong> stanza sent from
		 * a supporting server, regardless of the recipient. It SHOULD NOT
		 * be specified otherwise. The value of the 'from' attribute MUST be
		 * the full JID (localpart&#64;domain/resource) of the sender for the original
		 * <strong>message</strong> stanza.
		 */
		public function get from():UnescapedJID
		{
			var value:String = getAttribute("from");
			if ( value != null )
			{
				return new UnescapedJID(value);
			}
			return null;
		}
		public function set from( value:UnescapedJID ):void
		{
			setAttribute("from", value != null ? value.toString() : null);
		}

		/**
		 * The 'per-hop' attribute flags the contained ruleset for processing
		 * at each server in the route between the original sender and
		 * original intended recipient. This attribute MAY be present, and
		 * MUST be either "true" or "false". If not present, the default
		 * is "false".
		 */
		public function get perHop():Boolean
		{
			var value:String = getAttribute("per-hop");
			return value != null && value == "true";
		}
		public function set perHop( value:Boolean ):void
		{
			setAttribute("per-hop", value.toString());
		}

		/**
		 * List of AMPRule attached to this instance.
		 *
		 * <p>Each semantic rule is specified with a <strong>rule</strong>
		 * element. This element possesses attributes for the condition, value,
		 * and action.</p>
		 */
		public function get rules():Array
		{
			var list:Array = [];
			for each( var child:XML in xml.children() )
			{
				if ( child.localName() == AMPRule.ELEMENT_NAME )
				{
					var item:AMPRule = new AMPRule();
					item.xml = child;
					list.push(item);
				}
			}
			return list;
		}
		public function set rules( value:Array ):void
		{
			removeFields(AMPRule.ELEMENT_NAME);

			if ( value != null )
			{
				var len:uint = value.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var item:AMPRule = value[i] as AMPRule;
					xml.appendChild( item.xml );
				}
			}
		}
	}
}
