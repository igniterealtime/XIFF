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
	import org.flexunit.asserts.assertEquals;
	import org.igniterealtime.xiff.bookmark.UrlBookmark;
	
	public class BookmarkPrivatePayloadTest
	{
		
		[Test( description="construct - single UrlBookmark" )]
		public function testSingleUrlBookmark():void
		{
			var testValue:UrlBookmark = new UrlBookmark("http://the-tech.mit.edu/Shakespeare/");
			
			var bookmark:BookmarkPrivatePayload = new BookmarkPrivatePayload(null, [testValue]);
			var list:UrlBookmark = bookmark.urlBookmarks.pop() as UrlBookmark;
			
			assertEquals( testValue.url, list.url );
		}

	
		[Test( description="XML element name and namespace checking" )]
		public function testElement():void
		{
			var nameSpace:String = "storage:bookmarks";
			var elementName:String = "storage";
			
			var ext:BookmarkPrivatePayload = new BookmarkPrivatePayload();
			var node:XML = ext.xml;
			
			assertEquals( nameSpace, node.namespace().uri );
			assertEquals( elementName, node.localName() );
		}
	
		[Test( description="parse from XML" )]
		public function testParseShowDnd():void
		{
			var incoming:XML = <storage xmlns='storage:bookmarks'>
			  <conference name='Council of Oberon'
						  autojoin='true'
						  jid='council@conference.underhill.org'>
				<nick>Puck</nick>
			  </conference>
			</storage>;
			var testValue:int = 1;
			
			var ext:BookmarkPrivatePayload = new BookmarkPrivatePayload();
			ext.xml = incoming;
			
			assertEquals( testValue, ext.groupChatBookmarks.length );
		}
	}
}
