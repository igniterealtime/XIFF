/*
 * Copyright (C) 2009
 * Juga Paazmaya <olavic@gmail.com>
 *
 * What ever license will soon be used...
 */
package org.igniterealtime.xiff.data.chat
{	
	 /**
	  * Contains the constants used in the node name of a message having the chat state node.
	  * @see http://xmpp.org/extensions/xep-0085.html
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
