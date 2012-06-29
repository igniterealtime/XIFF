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
	
	/**
	 * @see http://docs.flexunit.org/index.php?title=Tests_and_Test_Cases
	 */
	public class DateTimeParserTest
	{
		private var _date:Date;
		
		[Before]
		public function setup():void
		{
			_date = new Date();
			_date.setUTCHours(23, 55, 23, 101);
			_date.setUTCFullYear(2012, 11, 25);
		}		
		
		[Test( description="Date as a string" )]
		public function testDateString():void
		{
			var dateString:String = DateTimeParser.date2string( _date );
			assertEquals( "2012-12-25", dateString );
		}
		
		[Test( description="String to Date parsing" )]
		public function testStringDate():void
		{
			var dateString:String = "2012-12-25";
			var date:Date = DateTimeParser.string2date(dateString);
			assertEquals( _date.toDateString(), date.toDateString() );
		}
		
		[Test( description="Time as a string" )]
		public function testTimeString():void
		{
			var timeString:String = DateTimeParser.time2string( _date );
			assertEquals( "23:55:23", timeString );
		}
		
		[Test( description="String to Time parsing" )]
		public function testStringTime():void
		{
			var timeString:String = "23:55:23";
			var date:Date = DateTimeParser.string2time(timeString);
			assertEquals( _date.toTimeString(), date.toTimeString() );
		}
		
		[Test( description="String to Date and Time parsing" )]
		public function testStringDateTime():void
		{
			var timeString:String = "2012-12-25T23:55:23";
			var date:Date = DateTimeParser.string2dateTime(timeString);
			assertEquals( _date.toUTCString(), date.toUTCString() );
		}
		
		/*
		Not implemented...
		
		[Test( description="String to Time parsing with milliseconds" )]
		public function testStringTimeMs():void
		{
			var timeString:String = "23:55:23.101";
			var date:Date = DateTimeParser.string2time(timeString);
			assertEquals( _date.toUTCString(), date.toUTCString() );
		}
		*/
	}
}