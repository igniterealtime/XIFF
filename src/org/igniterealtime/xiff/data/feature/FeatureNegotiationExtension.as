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
package org.igniterealtime.xiff.data.feature
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.forms.FormExtension;

	/**
	 * XEP-0020: Feature Negotiation
	 *
	 * <p>Features are negotiated through the exchange of
	 * <strong>iq</strong> or <strong>message</strong> stanzas
	 * containing <strong>feature</strong> child elements qualified
	 * by the 'http://jabber.org/protocol/feature-neg' namespace.
	 * However, this <strong>feature</strong> element is simply a
	 * wrapper for structured data encapsulated in the
	 * Data Forms (<code>FormExtension</code>) protocol.</p>

	 * <p>In order to begin a negotation, the initiator sends an
	 * <strong>iq</strong> stanza of type "get" (or a
	 * <strong>message</strong> stanza type "normal" - see Stanza
	 * Session Negotiation for examples) to the recipient with a
	 * single <strong>feature</strong> element containing a data form
	 * of type "form" which defines the available options for one or
	 * more features. Each feature is represented as an x-data "field".</p>

	 * <p>The recipient SHOULD examine each feature and the values of
	 * the options provided. In order to indicate preferred values,
	 * the recipient then SHOULD specify one value for each feature
	 * and return a data form of type "submit" to the initiator in an
	 * <strong>iq</strong> stanza of type "result" (or a
	 * <strong>message</strong> stanza type "normal").</p>

	 * <p>The following examples show some likely scenarios for feature
	 * negotiation between entities. Further examples can be found in
	 * "using protocols", such as File Transfer
	 * (<code>FileTransferExtension</code>).</p>
	 *
	 * <p>Peter Millard, the primary author of this specification from version 0.1
	 * through version 1.4, died on April 26, 2006. The remaining authors are
	 * thankful for Peter's work on this specification.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0020.html
	 * @see org.igniterealtime.xiff.data.forms.FormExtension
	 * @see org.igniterealtime.xiff.data.si.FileTransferExtension
	 */
	public class FeatureNegotiationExtension extends Extension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/feature-neg";
		public static const ELEMENT_NAME:String = "feature";

		/**
		 * Use <code>FormExtension</code> as a child extension.
		 *
		 * @param	parent
		 */
		public function FeatureNegotiationExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return FeatureNegotiationExtension.NS;
		}

		public function getElementName():String
		{
			return FeatureNegotiationExtension.ELEMENT_NAME;
		}
	}
}
