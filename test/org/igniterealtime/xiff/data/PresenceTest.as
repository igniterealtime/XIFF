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
package org.igniterealtime.xiff.data
{
	import org.flexunit.asserts.assertEquals;
	
	public class PresenceTest
	{
		
		[Test( description="Presence show away" )]
		public function testShowAway():void
		{
			var show:String = "away";
			var presence:Presence = new Presence();
			presence.show = show;
			
			assertEquals( show, presence.show );
		}
		
		[Test( description="Presence show chat" )]
		public function testShowChat():void
		{
			var show:String = "chat";
			var presence:Presence = new Presence();
			presence.show = show;
			
			assertEquals( show, presence.show );
		}
		
		[Test( description="Presence show dnd" )]
		public function testShowDnd():void
		{
			var show:String = "dnd";
			var presence:Presence = new Presence();
			presence.show = show;
			
			assertEquals( show, presence.show );
		}
		
		[Test( description="Presence show xa" )]
		public function testShowXa():void
		{
			var show:String = "xa";
			var presence:Presence = new Presence();
			presence.show = show;
			
			assertEquals( show, presence.show );
		}
		
		[Test( description="Presence status" )]
		public function testStatus():void
		{
			var status:String = "I am somewhere..";
			var presence:Presence = new Presence();
			presence.status = status;
			
			assertEquals( status, presence.status );
		}
		
		[Test( description="Presence priority" )]
		public function testPriority():void
		{
			var priority:int = 5;
			var presence:Presence = new Presence();
			presence.priority = priority;
			
			assertEquals( priority, presence.priority );
		}

	}
}
