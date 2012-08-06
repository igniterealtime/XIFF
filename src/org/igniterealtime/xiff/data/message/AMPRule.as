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
	import org.igniterealtime.xiff.data.XMLStanza;
	import org.igniterealtime.xiff.data.INodeProxy;
	
	/**
	 * XEP-0079: Advanced Message Processing - Rule
	 *
	 * @see http://xmpp.org/extensions/xep-0079.html#formal-rule
	 */
	public class AMPRule extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "rule";
		
		public static const ACTION_ALERT:String = "alert";
		public static const ACTION_DROP:String = "drop";
		public static const ACTION_ERROR:String = "error";
		public static const ACTION_NOTIFY:String = "notify";
		
		public static const CONDITION_DELIVER:String = "deliver";
		public static const CONDITION_EXPIRE_AT:String = "expire-at";
		public static const CONDITION_MATCH_RESOURCE:String = "match-resource";
		
		/**
		 *
		 * @param	parent
		 */
		public function AMPRule( parent:XML = null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if (parent != null)
			{
				parent.appendChild(xml);
			}
		}
		
		public function getElementName():String
		{
			return AMPExtension.ELEMENT_NAME;
        }
		
		/**
		 * Required. Must be one of the ACTION_* constants.
		 *
		 * <p>The 'action' attribute defines the result for this rule. This
		 * attribute MUST be present, and MUST be either a value defined in the
		 * Defined Actions section, or one registered with the XMPP Registrar.</p>
		 *
		 * @see http://xmpp.org/extensions/xep-0079.html#actions-def
		 */
		public function get action():String
		{
			return getAttribute("action");
		}
		public function set action( value:String ):void
		{
			if (value != AMPRule.ACTION_ALERT
				&& value != AMPRule.ACTION_DROP
				&& value != AMPRule.ACTION_ERROR
				&& value != AMPRule.ACTION_NOTIFY
				&& value != null)
			{
				throw new Error("Invalid 'action' value: " + value + " for AMPRule");
			}
			
			setAttribute("action", value);
		}
		
		/**
		 * Required. Must be one of the CONDITION_* constants.
		 *
		 * <p>The 'condition' attribute defines the overall condition this rule
		 * applies to. This attribute MUST be present, and MUST be either a value
		 * defined in the Defined Conditions section, or one registered with the
		 * XMPP Registrar.</p>
		 *
		 * @see http://xmpp.org/extensions/xep-0079.html#conditions-def
		 */
		public function get condition():String
		{
			return getAttribute("condition");
		}
		public function set condition( value:String ):void
		{
			if (value != AMPRule.CONDITION_DELIVER
				&& value != AMPRule.CONDITION_EXPIRE_AT
				&& value != AMPRule.CONDITION_MATCH_RESOURCE
				&& value != null)
			{
				throw new Error("Invalid 'condition' value: " + value + " for AMPRule");
			}
			setAttribute("condition", value);
		}
		
		/**
		 * Required.
		 *
		 * <p>The 'value' attribute defines how the condition is matched. This
		 * attribute MUST be present, and MUST NOT be an empty string.
		 * The interpretation of this attribute's value is determined by the
		 * 'condition' attribute.</p>
		 *
		 * @see http://xmpp.org/extensions/xep-0079.html#description
		 */
		public function get value():String
		{
			return getAttribute("value");
		}
		public function set value( val:String ):void
		{
			setAttribute("value", val);
		}
		
		
		
		
		
		
	}
}
