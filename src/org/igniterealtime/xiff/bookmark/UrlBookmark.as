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
package org.igniterealtime.xiff.bookmark
{
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;

	/**
	 * The <strong>url</strong> element is designed for bookmarking web pages,
	 * i.e., HTTP or HTTPS URLs.
	 *
	 * @see http://xmpp.org/extensions/xep-0048.html#format-url
	 */
	public class UrlBookmark extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "url";

		/**
		 * Bookmark an url.
		 *
		 * @param	url REQUIRED
		 * @param	name RECOMMENDED
		 */
		public function UrlBookmark( url:String, name:String = null )
		{
			xml.setLocalName( ELEMENT_NAME );
			if (name != null)
			{
				xml.@name = name;
			}
			xml.@url = url;
		}

		/**
		 * A friendly name for the bookmark.
		 */
		public function get name():String
		{
			return getAttribute("name");
		}

		/**
		 * The HTTP or HTTPS URL of the web page.
		 */
		public function get url():String
		{
			return getAttribute("url");
		}
	}
}
