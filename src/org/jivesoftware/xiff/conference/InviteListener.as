package org.jivesoftware.xiff.conference{
	/*
	 * Copyright (C) 2003-2004 
	 * Nick Velloff <nick.velloff@gmail.com>
	 * Derrick Grigg <dgrigg@rogers.com>
	 * Sean Voisen <sean@mediainsites.com>
	 * Sean Treadway <seant@oncotype.dk>
	 *
	 * This library is free software; you can redistribute it and/or
	 * modify it under the terms of the GNU Lesser General Public
	 * License as published by the Free Software Foundation; either
	 * version 2.1 of the License, or (at your option) any later version.
	 * 
	 * This library is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	 * Lesser General Public License for more details.
	 * 
	 * You should have received a copy of the GNU Lesser General Public
	 * License along with this library; if not, write to the Free Software
	 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
	 *
	 */
	
	import org.jivesoftware.xiff.core.XMPPConnection;
	import org.jivesoftware.xiff.conference.Room;
	import org.jivesoftware.xiff.data.Message;
	import org.jivesoftware.xiff.data.muc.MUCUserExtension;
	import flash.events.EventDispatcher;
	import org.jivesoftware.xiff.events.MessageEvent;
	import org.jivesoftware.xiff.events.InviteEvent;
	
	/**
	 * Broadcast when an invite has been received to the connection user
	 *
	 * The event object has the following properties:
	 *
	 * <code>from</code> - the JID of the user initiating the invite
	 *
	 * <code>reason</code> - a string containing the reason to join the room
	 *
	 * <code>room</code> - a Room instance of an unjoined room.  Finish the configuration of the
	 * room by adding your nickname then join to accept the invitation, or call the
	 * <code>decline</code> method of this room instance.  If you join this room, remember
	 * to keep a reference to it, and add your event listeners.
	 *
	 * <code>data</code> - the original message containing the invite request
	 *
	 * @see org.jivesoftware.xiff.conference.Room
	 * @see org.jivesoftware.xiff.conference.Room.invite
	 * @availability Flash Player 9
	 */
	[Event("invited")]
	
	/**
	 * Manages the broadcasting of events during invitations.  Add event
	 * listeners to an instance of this class to monitor invite and decline
	 * events
	 *
	 * You only need a single instance of this class to listen for all invite
	 * or decline events.
	 *
	 * @since 2.0.0
	 * @author Sean Treadway
	 * @param connection An XMPPConnection instance that is providing the primary server connection
	 * @toc-path Conferencing
	 * @toc-sort 1
	 */
	public class InviteListener extends EventDispatcher
	{
		private var myConnection:XMPPConnection;
		
		public function InviteListener( aConnection:XMPPConnection=null )
		{
			if (aConnection != null)
				setConnection( aConnection );	
		}
		
		/**
		 * Sets a reference to the XMPPConnection being used for incoming/outgoing XMPP data.
		 *
		 * @param connection The XMPPConnection instance to use.
		 * @availability Flash Player 9
		 * @see org.jivesoftware.xiff.core.XMPPConnection
		 */
		public function setConnection( connection:XMPPConnection ):void
		{
			if (myConnection != null){
				myConnection.removeEventListener(MessageEvent.MESSAGE, handleEvent);
			}
			myConnection = connection;
			myConnection.addEventListener(MessageEvent.MESSAGE, handleEvent);
		}
	
		/**
		 * Gets a reference to the XMPPConnection being used for incoming/outgoing XMPP data.
		 *
		 * @returns The XMPPConnection used
		 * @availability Flash Player 9
		 * @see org.jivesoftware.xiff.core.XMPPConnection
		 */
		public function getConnection():XMPPConnection
		{
			return myConnection;
		}
		 
		private function handleEvent( eventObj:Object ):void
		{
			switch( eventObj.type )
			{
				case MessageEvent.MESSAGE:
				
					try
					{
						var msg:Message = eventObj.data as Message;
						var muc:MUCUserExtension =  msg.getAllExtensionsByNS(MUCUserExtension.NS)[0];
	                    if (muc.type == MUCUserExtension.INVITE_TYPE) {
	                        var room:Room = new Room(myConnection);
	                        room.setRoomJID(msg.from);
	                        room.password = muc.password;
							var e:InviteEvent = new InviteEvent();
							e.from = muc.from;
							e.reason = muc.reason;
							e.room = room;
							e.data = msg;
							dispatchEvent(e);
	                    }
    				 }
    				 catch (e:Error)
    				 {
    				 	trace("Error : null trapped. Resuming.");
    				 }
                    
					break;
			}
		}
	}
}