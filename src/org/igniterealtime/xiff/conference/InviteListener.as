/*
 * License
 */
package org.igniterealtime.xiff.conference
{
	import flash.events.EventDispatcher;

	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.muc.MUCUserExtension;
	import org.igniterealtime.xiff.events.InviteEvent;
	import org.igniterealtime.xiff.events.MessageEvent;

	/**
	 * Dispatched when an invitations has been received.
	 *
	 * @eventType org.igniterealtime.xiff.InviteEvent.INVITED
	 * @see	org.igniterealtime.xiff.conference.Room
	 * @see	org.igniterealtime.xiff.conference.Room.#invite
	 */
	[Event( name="invited",type="org.igniterealtime.xiff.events.InviteEvent" )]
	
	
	/**
	 * Manages the dispatching of events during invitations.  Add event
	 * listeners to an instance of this class to monitor invite and decline
	 * events.
	 *
	 * <p>You only need a single instance of this class to listen for all invite
	 * or decline events.</p>
	 */
	public class InviteListener extends EventDispatcher
	{
		private var myConnection:XMPPConnection;

		/**
		 *
		 * @param	aConnection	An XMPPConnection instance that is providing the primary server
		 * connection.
		 */
		public function InviteListener( aConnection:XMPPConnection = null )
		{
			if ( aConnection != null )
			{
				setConnection( aConnection );
			}
		}

		/**
		 * Gets a reference to the XMPPConnection being used for incoming/outgoing XMPP data.
		 *
		 * @return	The XMPPConnection used
		 * @see	org.igniterealtime.xiff.core.XMPPConnection
		 */
		public function getConnection():XMPPConnection
		{
			return myConnection;
		}

		/**
		 * Sets a reference to the XMPPConnection being used for incoming/outgoing XMPP data.
		 *
		 * @param	connection The XMPPConnection instance to use.
		 * @see	org.igniterealtime.xiff.core.XMPPConnection
		 */
		public function setConnection( connection:XMPPConnection ):void
		{
			if ( myConnection != null )
			{
				myConnection.removeEventListener( MessageEvent.MESSAGE, handleEvent );
			}
			myConnection = connection;
			myConnection.addEventListener( MessageEvent.MESSAGE, handleEvent );
		}

		private function handleEvent( eventObj:Object ):void
		{
			switch ( eventObj.type )
			{
				case MessageEvent.MESSAGE:

					try
					{
						var msg:Message = eventObj.data as Message;
						var exts:Array = msg.getAllExtensionsByNS( MUCUserExtension.NS );
						if ( !exts || exts.length < 0 )
						{
							return;
						}
						var muc:MUCUserExtension = exts[ 0 ];
						if ( muc.type == MUCUserExtension.INVITE_TYPE )
						{
							var room:Room = new Room( myConnection );
							room.roomJID = msg.from.unescaped;
							room.password = muc.password;

							var inviteEvent:InviteEvent = new InviteEvent();
							inviteEvent.from = muc.from.unescaped;
							inviteEvent.reason = muc.reason;
							inviteEvent.room = room;
							inviteEvent.data = msg;
							dispatchEvent( inviteEvent );
						}
					}
					catch ( e:Error )
					{
						trace( e.getStackTrace());
					}

					break;
			}
		}
	}
}