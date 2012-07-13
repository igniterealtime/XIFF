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
package org.igniterealtime.xiff.data.forms.enum
{
	/**
	 * Different field types of form that can exist according to XEP-0004.
	 *
	 * <p>The following field types represent data "types" that are commonly exchanged between
	 * Jabber/XMPP entities. These field types are not intended to be as comprehensive as
	 * the datatypes defined in, for example, XML Schema Part 2, nor do they define
	 * user interface elements.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0004.html#protocol-fieldtypes
	 * @see http://www.w3.org/TR/xmlschema-2/
	 */
	public class FormFieldType
	{
		/**
		 * The field enables an entity to gather or provide an either-or choice between two options.
		 * The default value is "false".
		 */
		public static const BOOLEAN:String = "boolean";
		
		/**
		 * The field is intended for data description (e.g., human-readable text such as "section"
		 * headers) rather than data gathering or provision. The <code>value</code> child SHOULD NOT contain
		 * newlines (the \\n and \\r characters); instead an application SHOULD generate multiple
		 * fixed fields, each with one <code>value</code> child.
		 */
		public static const FIXED:String = "fixed";
		
		/**
		 * The field is not shown to the form-submitting entity, but instead is returned with
		 * the form. The form-submitting entity SHOULD NOT modify the value of a hidden field,
		 * but MAY do so if such behavior is defined for the "using protocol".
		 */
		public static const HIDDEN:String = "hidden";
		
		/**
		 * The field enables an entity to gather or provide multiple Jabber IDs. Each provided JID
		 * SHOULD be unique (as determined by comparison that includes application of the Nodeprep,
		 * Nameprep, and Resourceprep profiles of Stringprep as specified in XMPP Core), and
		 * duplicate JIDs MUST be ignored.
		 *
		 * <p>Note: Data provided for fields of type "jid-single" or "jid-multi" MUST contain one
		 * or more valid Jabber IDs, where validity is determined by the addressing rules
		 * defined in XMPP Core.</p>
		 */
		public static const JID_MULTI:String = "jid-multi";
		
		/**
		 * The field enables an entity to gather or provide a single Jabber ID.
		 *
		 * <p>Note: Data provided for fields of type "jid-single" or "jid-multi" MUST contain
		 * one or more valid Jabber IDs, where validity is determined by the addressing
		 * rules defined in XMPP Core.</p>
		 */
		public static const JID_SINGLE:String = "jid-single";
		
		/**
		 * The field enables an entity to gather or provide one or more options from among many.
		 * A form-submitting entity chooses one or more items from among the options presented
		 * by the form-processing entity and MUST NOT insert new options. The form-submitting
		 * entity MUST NOT modify the order of items as received from the form-processing entity,
		 * since the order of items MAY be significant.
		 *
		 * <p>Note: The <code>option</code> elements in list-multi and list-single fields MUST
		 * be unique, where uniqueness is determined by the value of the 'label' attribute and
		 * the XML character data of the <code>value</code> element (i.e., both must be unique).</p>
		 */
		public static const LIST_MULTI:String = "list-multi";
		
		/**
		 * The field enables an entity to gather or provide one option from among many.
		 * A form-submitting entity chooses one item from among the options presented by the
		 * form-processing entity and MUST NOT insert new options.
		 *
		 * <p>Note: The <code>option</code> elements in list-multi and list-single fields MUST
		 * be unique, where uniqueness is determined by the value of the 'label' attribute and
		 * the XML character data of the <code>value</code> element (i.e., both must be unique).</p>
		 */
		public static const LIST_SINGLE:String = "list-single";
		
		/**
		 * The field enables an entity to gather or provide multiple lines of text.
		 *
		 * <p>Note: Data provided for fields of type "text-multi" SHOULD NOT contain any newlines
		 * (the \\n and \\r characters). Instead, the application SHOULD split the data into
		 * multiple strings (based on the newlines inserted by the platform), then specify
		 * each string as the XML character data of a distinct <code>value</code> element. Similarly,
		 * an application that receives multiple <code>value</code> elements for a field of
		 * type "text-multi" SHOULD merge the XML character data of the value elements into
		 * one text block for presentation to a user, with each string separated by a
		 * newline character as appropriate for that platform.</p>
		 */
		public static const TEXT_MULTI:String = "text-multi";
		
		/**
		 * The field enables an entity to gather or provide a single line or word of text,
		 * which shall be obscured in an interface (e.g., with multiple instances of the
		 * asterisk character).
		 */
		public static const TEXT_PRIVATE:String = "text-private";
		
		/**
		 * The field enables an entity to gather or provide a single line or word of text,
		 * which may be shown in an interface. This field type is the default and MUST be
		 * assumed if a form-submitting entity receives a field type it does not understand.
		 */
		public static const TEXT_SINGLE:String = "text-single";

	}
}
