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
	
	// http://xmpp.org/extensions/xep-0048.html
	public class UrlBookmarkTest
	{
		
		[Test( description="UrlBookmark construct - name" )]
		public function testName():void
		{
			var testValue:String = "Complete Works of Shakespeare";
			
			var bookmark:UrlBookmark = new UrlBookmark("http://the-tech.mit.edu/Shakespeare/", testValue);
			
			assertEquals( testValue, bookmark.name );
		}

		[Test( description="UrlBookmark construct - url" )]
		public function testUrl():void
		{
			var testValue:String = "http://the-tech.mit.edu/Shakespeare/";
			
			var bookmark:UrlBookmark = new UrlBookmark(testValue, "Complete Works of Shakespeare");
			
			assertEquals( testValue, bookmark.url );
		}
		
		/*
		TODO: Test for read-only
		
		[Test( description="UrlBookmark value - name" )]
		public function testValueName():void
		{
			var testValue:String = "Complete Works of Shakespeare";
			
			var bookmark:UrlBookmark = new UrlBookmark();
			bookmark.name = testValue;
			
			assertEquals( testValue, bookmark.name );
		}

		[Test( description="UrlBookmark value - url" )]
		public function testValueUrl():void
		{
			var testValue:String = "http://the-tech.mit.edu/Shakespeare/";
			
			var bookmark:UrlBookmark = new UrlBookmark();
			bookmark.url = testValue;
			
			assertEquals( testValue, bookmark.url );
		}
		*/
		
		[Test( description="UrlBookmark parse from XML - name" )]
		public function testParseName():void
		{
			var incoming:XML = <url name='Complete Works of Shakespeare'
					   url='http://the-tech.mit.edu/Shakespeare/'/>;
			var testValue:String = "Complete Works of Shakespeare";
			
			var bookmark:UrlBookmark = new UrlBookmark("temp");
			bookmark.xml = incoming;
			
			assertEquals( testValue, bookmark.name );
		}
		
		[Test( description="UrlBookmark parse from XML - url" )]
		public function testParseUrl():void
		{
			var incoming:XML = <url name='Complete Works of Shakespeare'
					   url='http://the-tech.mit.edu/Shakespeare/'/>;
			var testValue:String = "http://the-tech.mit.edu/Shakespeare/";
			
			var bookmark:UrlBookmark = new UrlBookmark("temp");
			bookmark.xml = incoming;
			
			assertEquals( testValue, bookmark.url );
		}
	
	}
}
