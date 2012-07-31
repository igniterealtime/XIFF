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
package org.igniterealtime.xiff.data.privatedata
{


	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.privatedata.IPrivatePayload;

	/**
	 * XEP-0049: Private XML Storage
	 *
	 * @see http://xmpp.org/extensions/xep-0049.html
	 */
	public class PrivateDataExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:private";
		public static const ELEMENT_NAME:String = "query";

		private var _payloadExt:IPrivatePayload;

		/**
		 *
		 * @param	privateName
		 * @param	privateNamespace
		 * @param	payload
		 */
		public function PrivateDataExtension(privateName:String = null, privateNamespace:String = null,
											 payload:IPrivatePayload = null)
		{

			if (privateName != null)
			{
				var extension:XML = <{ privateName }/>;
				if (privateNamespace != null)
				{
					extension.setNamespace( privateNamespace );
				}

				xml.appendChild(extension);
			}

			this.payload = payload;
		}


		public function getNS():String
		{
			return PrivateDataExtension.NS;
		}

		public function getElementName():String
		{
			return PrivateDataExtension.ELEMENT_NAME;
		}

		/**
		 * @exampleText exodus
		 */
		public function get privateName():String
		{
			var list:XMLList = xml.children();
			if (list.length() > 0)
			{
				return list[0].localName();
			}

			return null;
		}
		/*
		public function set privateName( value:String ):void
		{
			var list:XMLList = xml.children();
			if (list.length() > 0)
			{
				list[0].setLocalName(value);
			}
		}
		*/

		/**
		 * @exampleText exodus:prefs
		 */
		public function get privateNamespace():String
		{
			var list:XMLList = xml.children();
			if (list.length() > 0)
			{
				var ns:Namespace = list[0].namespace();
				if (ns != null)
				{
					return ns.uri;
				}
			}
			return null;
		}

		/**
		 * @exampleText &gt;defaultnick&lt;Hamlet&gt;/defaultnick&lt;
		 */
		public function get payload():IPrivatePayload
		{
			var list:XMLList = xml[privateName].children();
			if (list.length() > 0)
			{
				return IPrivatePayload(list[0]);
			}
			return null;
		}
		public function set payload( value:IPrivatePayload ):void
		{
			xml[privateName] = value; // TODO: perhaps replace children or similar...
		}
	}
}
