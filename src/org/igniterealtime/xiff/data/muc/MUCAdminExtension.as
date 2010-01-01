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
package org.igniterealtime.xiff.data.muc
{


	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;

	import org.igniterealtime.xiff.data.muc.MUCBaseExtension;

	/**
	 * Implements the administration command data model in XEP-0045 for multi-user chat.
	 * @see http://xmpp.org/extensions/xep-0045.html
	 */
	public class MUCAdminExtension extends MUCBaseExtension implements IExtension
	{

		public static const NS:String = "http://jabber.org/protocol/muc#admin";

		public static const ELEMENT_NAME:String = "query";

		private var _items:Array;

		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function MUCAdminExtension( parent:XML = null )
		{
			super( parent );
		}

		public function getNS():String
		{
			return MUCAdminExtension.NS;
		}

		public function getElementName():String
		{
			return MUCAdminExtension.ELEMENT_NAME;
		}
	}
}
