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
package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;

	
	/**
	 * XEP-0128: Service Discovery Extensions
	 *
	 * INCOMPLETE
	 *
	 * @see http://xmpp.org/extensions/xep-0128.html
	 */
	public class DiscoExtendedInfo extends XMLStanza implements INodeProxy
	{
		public static const NS:String = "jabber:x:data";
		public static const ELEMENT_NAME:String = "x";

		/**
		 *
		 * @param	parent
		 */
		public function DiscoExtendedInfo( parent:XML = null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );
			xml.setNamespace( NS );

			if ( parent != null )
			{
				parent.appendChild( xml );
			}
		}


	}
}
