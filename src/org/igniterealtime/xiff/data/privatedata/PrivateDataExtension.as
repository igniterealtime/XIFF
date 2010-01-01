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
package org.igniterealtime.xiff.data.privatedata
{
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.privatedata.IPrivatePayload;

	public class PrivateDataExtension implements IExtension, ISerializable
	{
		public static const ELEMENT_NAME:String = "query";

		public static const NS:String = "jabber:iq:private";

		private var _extension:XML;

		private var _payload:IPrivatePayload;

		/**
		 *
		 * @param	privateName
		 * @param	privateNamespace
		 * @param	payload
		 */
		public function PrivateDataExtension( privateName:String = null, privateNamespace:String = null, payload:IPrivatePayload = null )
		{
			if (privateName != null)
			{
				_extension = <{ privateName }/>;
				_extension.setNamespace( privateNamespace );
				_payload = payload;
			}
		}

		public function deserialize( node:XML ):Boolean
		{
			var payloadNode:XML = node[0];
			var ns:String = payloadNode.@xmlns.toString();
			if ( ns == null )
			{
				return false;
			}

			_extension = <{ payloadNode.localName() }/>;
			_extension.setNamespace( ns );

			var extClass:Class = ExtensionClassRegistry.lookup( ns );
			if ( extClass == null )
			{
				return false;
			}
			var ext:IPrivatePayload = new extClass();
			if ( ext != null && ext is IPrivatePayload )
			{
				ext.deserialize( payloadNode );
				_payload = ext;
				return true;
			}
			else
			{
				return false;
			}
		}

		public function getElementName():String
		{
			return PrivateDataExtension.ELEMENT_NAME;
		}

		public function getNS():String
		{
			return PrivateDataExtension.NS;
		}

		public function get payload():IPrivatePayload
		{
			return _payload;
		}

		public function get privateName():String
		{
			return _extension.name();
		}

		public function get privateNamespace():String
		{
			return _extension.@xmlns.toString();
		}

		public function serialize( parentNode:XML ):Boolean
		{
			var extension:XML = _extension.copy();
			var query:XML = <{ PrivateDataExtension.ELEMENT_NAME }/>;
			query.setNamespace( PrivateDataExtension.NS );
			query.appendChild( extension );
			parentNode.appendChild( query );

			return _serializePayload( extension );
		}

		private function _serializePayload( parentNode:XML ):Boolean
		{
			if ( _payload == null )
			{
				return true;
			}
			else
			{
				return _payload.serialize( parentNode );
			}
		}
	}
}
