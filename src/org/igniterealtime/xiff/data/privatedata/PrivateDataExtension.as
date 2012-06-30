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
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.privatedata.IPrivatePayload;
	
	/**
	 * XEP-0049: Private XML Storage
	 * @see http://xmpp.org/extensions/xep-0049.html
	 */
	public class PrivateDataExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:private";
		public static const ELEMENT_NAME:String = "query";
	
		private var _query:XML;
		
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
			
			var extension:XML = <{ privateName }/>;
			if (privateNamespace != null)
			{
				extension.setNamespace( privateNamespace );
			}
			
			_query = <{ ELEMENT_NAME }/>;
			_query.setNamespace( NS );
			_query.appendChild(extension);
			
			_payloadExt = payload;
		}
		
		public function getNS():String
		{
			return PrivateDataExtension.NS;
		}
		
		public function getElementName():String
		{
			return PrivateDataExtension.ELEMENT_NAME;
		}
		
		public function get privateName():String
		{
			return _query.children()[0].localName();
		}
		
		public function get privateNamespace():String
		{
			return _query.children()[0].attributes["xmlns"];
		}
		
		public function get payload():IPrivatePayload
		{
			return _payloadExt;
		}
				
		override public function set xml( node:XML ):void
		{
			_query = node;
			
			var payloadNode:XML = node.children()[0];
			var ns:String = payloadNode.attributes["xmlns"];
			if (ns == null)
			{
				return;
			}
			
			
			var extClass:Class = ExtensionClassRegistry.lookup(ns);
			if (extClass == null)
			{
				return;
			}
			var ext:IPrivatePayload = new extClass();
			if (ext != null && ext is IPrivatePayload)
			{
				ext.xml = payloadNode;
				_payloadExt = ext;
				return;
			}
			else
			{
				return;
			}
		}
	
	}
}
