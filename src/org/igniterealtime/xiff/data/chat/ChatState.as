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
package org.igniterealtime.xiff.data.chat
{	
	 /**
	  * Contains the constants used in the node name of a message having the chat state node.
	  * @see	http://xmpp.org/extensions/xep-0085.html
	  */
	public class ChatState
	{
		/**
		 * User is actively participating in the chat session.
		 */
		public static const ACTIVE:String = "active";
		
		/**
		 * User is composing a message.
		 */
		public static const COMPOSING:String = "composing";
		
		/**
		 * User had been composing but now has stopped. 
		 * Suggested delay after last activity some 30 seconds.
		 */
		public static const PAUSED:String = "paused";
		
		/**
		 * User has not been actively participating in the chat session.
		 * Suggested delay after last activity some 2 minutes.
		 */
		public static const INACTIVE:String = "inactive";
		
		/**
		 * User has effectively ended their participation in the chat session.
		 * Suggested delay after last activity some 10 minutes.
		 */
		public static const GONE:String = "gone";
	}
}
