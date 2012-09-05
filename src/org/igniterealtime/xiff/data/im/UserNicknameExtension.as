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
package org.igniterealtime.xiff.data.im
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;

	/**
	 * XEP-0172: User Nickname (version 1.1, 2012-03-21)
	 *
	 *
	 * @see http://xmpp.org/extensions/xep-0172.html
	 */
	public class UserNicknameExtension extends Extension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/nick";
		public static const ELEMENT_NAME:String = "nick";

		/**
		 * 
		 * @param	parent
		 */
		public function UserNicknameExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return UserNicknameExtension.NS;
		}

		public function getElementName():String
		{
			return UserNicknameExtension.ELEMENT_NAME;
		}

		/**
		 * The nickname to be used.
		 */
		public function get nickname():String
		{
			return xml.toString();
		}
		public function set nickname( value:String ):void
		{
			xml.setChildren(value);
		}

		
	}
}
