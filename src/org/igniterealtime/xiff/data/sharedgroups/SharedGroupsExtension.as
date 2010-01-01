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
package org.igniterealtime.xiff.data.sharedgroups
{
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;

	/**
	 * Similar idea to XEP-0140 (http://xmpp.org/extensions/xep-0140.html) which was
	 * retracted in favor of XEP-0144 (http://xmpp.org/extensions/xep-0144.html).
	 */
	public class SharedGroupsExtension implements IExtension, ISerializable
	{
		public static const ELEMENT_NAME:String = "sharedgroup";

		public static const NS:String = "http://www.jivesoftware.org/protocol/sharedgroup";

		public function deserialize( node:XML ):Boolean
		{
			return true;
		}

		public function getElementName():String
		{
			return SharedGroupsExtension.ELEMENT_NAME;
		}

		public function getNS():String
		{
			return SharedGroupsExtension.NS;
		}

		public function serialize( parentNode:XML ):Boolean
		{
			var xmlNode:XML = <{ SharedGroupsExtension.ELEMENT_NAME }/>;
			xmlNode.setNamespace( SharedGroupsExtension.NS );
			parentNode.appendChild( xmlNode );
			return true;
		}
	}
}
