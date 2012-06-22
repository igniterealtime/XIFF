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
package org.igniterealtime.xiff.util
{
	import org.flexunit.asserts.assertEquals;
	
	public class DateTimeParserTest
	{
		[Test( description="Date as a string" )]
		public function testDateString():void
		{
			var date:Date = new Date( 2000, 10, 30, 0, 0 );
			var dateString:String = DateTimeParser.date2string( date );
			assertEquals( "2000-11-30", dateString );
		}
		
		[Test( description="String to Date parsing" )]
		public function testStringDate():void
		{
			var dateString:String = "2012-06-22";
			var date:Date = DateTimeParser.string2date(dateString);
			assertEquals( new Date(2012, 5, 22), date );
		}
		
		[Test( description="Time as a string" )]
		public function testTimeString():void
		{
			var date:Date = new Date( 2000, 10, 30, 23, 59, 10 );
			var timeString:String = DateTimeParser.time2string( date );
			assertEquals( "23:59:10", timeString );
		}
		
		[Test( description="String to Time parsing" )]
		public function testStringTime():void
		{
			var timeString:String = "12:34:22";
			var date:Date = DateTimeParser.string2time(timeString);
			assertEquals( new Date(2012, 5, 22, 12, 34, 22), date );
		}
		
		/*
		Not implemented...
		
		[Test( description="String to Time parsing with milliseconds" )]
		public function testStringTimeMs():void
		{
			var timeString:String = "12:34:22.101";
			var date:Date = DateTimeParser.string2time(timeString);
			assertEquals( new Date(2012, 5, 22, 12, 34, 22), date );
		}
		*/
	}
}