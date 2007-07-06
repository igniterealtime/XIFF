package org.igniterealtime.xiff.im{
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
	
	import org.igniterealtime.xiff.data.Presence;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.im.RosterExtension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.XMPPStanza;
	
	import org.igniterealtime.xiff.events.*;
	import flash.events.Event;
	import flash.utils.describeType;
	import org.igniterealtime.xiff.data.XMLStanza;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Broadcast whenever someone revokes your presence subscription. This is not
	 * an event that is fired when you revoke a subscription, but rather when one of your
	 * contacts decides that he/she/it no longer wants you to know about their presence
	 * status.
	 *
	 * The event object contains an attribute <code>jid</code> with the JID of
	 * the user who revoked your subscription.
	 *
	 * @availability Flash Player 7
	 */
	[Event("subscriptionRevocation")]
	
	/**
	 * Broadcast whenever someone requests to subscribe to your presence. The event object
	 * contains an attribute <code>jid</code> with the JID of the user who is requesting
	 * a presence subscription.
	 *
	 * @availability Flash Player 7
	 */
	[Event("subscriptionRequest")]
	
	/**
	 * Broadcast whenever a subscription request that you make (via the <code>addContact()</code>
	 * or <code>requestSubscription()</code> methods) is denied.
	 *
	 * The event object contains an attribute <code>jid</code> with the JID of the user who
	 * denied the request.
	 *
	 * @availability Flash Player 7
	 */
	[Event("subscriptionDenial")]
	
	/**
	 * Broadcast whenever a contact in the roster becomes unavailable. (Goes from online to offline.)
	 * The event object contains an attribute <code>jid</code> with the JID of the user who
	 * became unavailable.
	 *
	 * @availability Flash Player 7
	 */
	[Event("userUnavailable")]
	
	/**
	 * Broadcast whenever a contact in the roster becomes available. (Goes from offline to online.)
	 * The event object contains an attribute <code>jid</code> with the JID of the user who
	 * became available.
	 *
	 * @availability Flash Player 7
	 */
	[Event("userAvailable")]
	
	/**
	 * Manages a user's server-side instant messaging roster (or "buddy list"). By default,
	 * this class uses an internal data provider to keep track of roster data locally and
	 * provides a "read-only" form of the Data Provider API for external use. Non-read operations
	 * are performed using alternative, roster-specific methods.
	 *
	 * You can also use your own, external data provider if you choose, by using the
	 * <code>setExternalDataProvider()</code> method. This is most useful for applications
	 * where the data provider might need to be a class other than an array with the Data Provider
	 * API decorations, like in the case of a Macromedia Central LCDataProvider. Overall,
	 * however, its probably a rare occurence.
	 *
	 * @author Sean Voisen
	 * @since 2.0.0
	 * @toc-path Instant Messaging
	 * @toc-sort 1
	 * @availability Flash Player 7
	 * @param aConnection A reference to an XMPPConnection class instance
	 * @param externalDataProvider (Optional) A reference to an instance of a data provider
	 */ 
	public class Roster extends ArrayCollection
	{
		private var myConnection:XMPPConnection;
		private var pendingSubscriptionRequestJID:String;
		
		private static var staticConstructorDependencies:Array = [			
			ExtensionClassRegistry,
			RosterExtension
		]
		
		private static var rosterStaticConstructed:Boolean = RosterStaticConstructor();
		
		public function Roster( aConnection:XMPPConnection = null)
		{	
			
			if (aConnection != null){ 
				connection = aConnection;
			}
		}
		
		private static function RosterStaticConstructor():Boolean
		{	
			ExtensionClassRegistry.register( RosterExtension );
			return true;
		}
		
		/**
		 * Adds a contact to the roster. Remember: All roster data is managed on the server-side,
		 * so this contact is added to the server-side roster first, and upon successful addition,
		 * reflected in the local client-side copy of the roster.
		 *
		 * @param id The JID of the contact to add
		 * @param displayName A friendly name for use when displaying this contact in the roster
		 * @param group (Optional) The name of the group that this contact should be added to. (Used for
		 * organization in the roster listing.
		 * @param requestSubscription (Optional) Determines whether a subscription request should be sent
		 * to this user. Most of the time you will want this parameter to be true.
		 * You will be unable to view the contacts presence status until a subscription request is granted.
		 * @availability Flash Player 7
		 * @example This example adds a contact to the roster and simultaneously requests a presence subscription
		 * with the new contact.
		 * <pre>myRoster.addContact( "homer@springfield.com", "Homer", "Drinking Buddies", true );</pre>
		 */
		public function addContact( id:String, displayName:String, group:String, requestSubscription:Boolean=true ):void
		{
			if( displayName == null )
				displayName = id;
				
			var callbackObj:Roster = null;
			var callbackMethod:String = null;
			var subscription:String = RosterExtension.SUBSCRIBE_TYPE_NONE;
			
			if( requestSubscription == true ) {
				callbackObj = this;
				callbackMethod = "addContact_result";
				pendingSubscriptionRequestJID = id;
				subscription = RosterExtension.SUBSCRIBE_TYPE_TO;
			}
				
			var tempIQ:IQ = new IQ (null, IQ.SET_TYPE, XMPPStanza.generateID("add_user_"), callbackMethod, callbackObj );
			var ext:RosterExtension = new RosterExtension( tempIQ.getNode() );
			ext.addItem( id, null, displayName, [group] );
			tempIQ.addExtension( ext );
			myConnection.send( tempIQ );
	
			
			addRosterItem( id, displayName, RosterExtension.SHOW_UNAVAILABLE, "Pending", group, subscription );
		}
		
		/**
		 * Requests subscription authorization with a user or service. In the XMPP-world, you cannot receive
		 * notifications on changes to a contact's presence until that contact has authorized you to subscribe
		 * to his/her/its presence.
		 *
		 * @param id The JID of the user or service that you wish to subscribe to
		 * @availability Flash Player 7
		 * @see #subscriptionDenial
		 */
		public function requestSubscription( id:String, isResponse:Boolean=false):void
		{
			// Roster length is 0 if it a response to a user request. we must handle this event.
			var tempPresence:Presence;
			if (isResponse)
			{
				tempPresence = new Presence( id, null, Presence.SUBSCRIBE_TYPE );
				myConnection.send( tempPresence );
				return;
			}
			// Only request for items in the roster
			var l:int = length;
			for( var i:int = 0; i < l; i++ ) {
				if( getItemAt( i ).jid.toLowerCase() == id.toLowerCase() ) {
					tempPresence = new Presence( id, null, Presence.SUBSCRIBE_TYPE );
					myConnection.send( tempPresence );
					return;
				}
			}
		}
		
		/**
		 * Removes a contact from the roster and revokes all presence subscriptions for that contact.
		 * This method will only attempt action if the contact you are trying to remove is currently on the
		 * roster in the first place.
		 *
		 * @param id The JID of the contact to remove
		 * @availability Flash Player 7
		 */
		public function removeContact( id:String ):void
		{
			var l:uint = length;
			for( var i:uint = 0; i < l; i++ ) {
				// Only attempt unsubscribe to users that we are currently subscribed to
				if( getItemAt( i ).jid.toLowerCase() == id.toLowerCase() ) {
					var tempIQ:IQ = new IQ( null, IQ.SET_TYPE, XMPPStanza.generateID("remove_user_"), "unsubscribe_result", this );
					var ext:RosterExtension = new RosterExtension( tempIQ.getNode() );
					ext.addItem( id, RosterExtension.SUBSCRIBE_TYPE_REMOVE );
					tempIQ.addExtension( ext );
					myConnection.send( tempIQ );
					removeItemAt(i); 
					return;
				}
			}
		}
		
		/**
		 * Fetches the roster data from the server. Once the data has been fetched, the Roster's data
		 * provider is populated appropriately. If the Roster-XMPPConnection class dependency has been
		 * set up before logging in, then this method will be called automatically because the Roster
		 * listens for "login" events from the XMPPConnection.
		 *
		 * @availability Flash Player 7
		 */
		public function fetchRoster():void
		{
			var tempIQ:IQ = new IQ( null, IQ.GET_TYPE, XMPPStanza.generateID("roster_"), "fetchRoster_result", this );
			tempIQ.addExtension( new RosterExtension( tempIQ.getNode() ) );
			myConnection.send( tempIQ );
		}
		
		/**
		 * Grants a user or service authorization for subscribing to your presence. Once authorization
		 * is granted, the user can see whether you are offline, online, away, etc. Subscriptions can
		 * be revoked at any time using the <code>denySubscription()</code> method.
		 *
		 * @availability Flash Player 7
		 * @param to The JID of the user or service to grant subscription to
		 * @param requestAfterGrant Whether or not a reciprocal subscription request should be sent
		 * to the grantee, so that you may, in turn, subscribe to his/her/its presence.
		 */
		public function grantSubscription( tojid:String, requestAfterGrant:Boolean = true ):void
		{
			var tempPresence:Presence = new Presence( tojid, null, Presence.SUBSCRIBED_TYPE );
			myConnection.send( tempPresence );
			
			// Request a return subscription
			if( requestAfterGrant ) {
				requestSubscription( tojid, true );
			}
		}
		
		/**
		 * Revokes an existing presence subscription or denies a subscription request. If a user
		 * has sent you a subscription request you can use this method to deny that request. Otherwise,
		 * if a user already has a granted presence subscription, you can use this method to revoke that
		 * subscription.
		 *
		 * @availability Flash Player 7
		 * @param to The JID of the user or service that you are denying subscription
		 */
		public function denySubscription( tojid:String ):void
		{
			var tempPresence:Presence = new Presence( tojid, null, Presence.UNSUBSCRIBED_TYPE );
			myConnection.send( tempPresence );
		}
		
		/**
		 * Updates the information for an existing contact. You can use this method to change the
		 * display name or associated group for a contact in your roster.
		 *
		 * @availability Flash Player 7
		 * @param id The JID of the contact to update
		 * @param newName The new display name for this contact
		 * @param newGroup The new group to associate the contact with
		 */
		public function updateContact( id:String, newName:String, newGroup:String ):void
		{
			// Make sure we already subscribe
			var l:uint = length;
			for( var i:uint = 0; i < l; i++ ) {
				if( id.toLowerCase() == getItemAt( i ).jid.toLowerCase() ) {
					trace("updateContact: " + id);
					var tempIQ:IQ = new IQ( null, IQ.SET_TYPE, XMPPStanza.generateID("update_contact_") );
					var ext:RosterExtension = new RosterExtension( tempIQ.getNode() );
					ext.addItem( id, null, newName, [newGroup] );
					tempIQ.addExtension( ext );
					myConnection.send( tempIQ );
					break;
				}
			}
		}
		
		/**
		 * Gets all of the locally-cached information for a certain contact by in the roster.
		 *
		 * @availability Flash Player 7
		 * @param jid The JID of the contact to lookup.
		 * @return An object with the attributes <code>jid</code>, <code>displayName</code>, <code>subscribeType</code>,
		 * <code>group</code>, <code>status</code>, <code>show</code> and <code>priority</code>.
		 */
		public function getContactInformation( jid:String ):Object
		{
			var l:uint = length;
			for( var i:uint = 0; i < l; i++ ) 
			{
				if( jid.toLowerCase() == getItemAt( i ).jid.toLowerCase() )
				{
					return getItemAt( i );
				}
					
			}
			
			return null;
		}
		
		/**
		 * Sets your current presence status. Calling this method notifies others who
		 * are subscribed to your presence of a presence change. You should use this to
		 * change your status to away, extended-away, etc. There are static variables that
		 * you can use defined in the presence class for the <code>show</code> parameter:
		 * <ul>
		 * <li><code>Presence.SHOW_AWAY</code></li>
		 * <li><code>Presence.SHOW_CHAT</code></li>
		 * <li><code>Presence.SHOW_DND</code></li>
		 * <li><code>Presence.SHOW_NORMAL</code></li>
		 * <li><code>Presence.SHOW_XA</code></li>
		 * </ul>
		 *
		 * @availability Flash Player 7
		 * @param show The show type for your presence. This represents what others should see - whether
		 * you are offline, online, away, etc.
		 * @param status The status message associated with the show value
		 * @param priority (Optional) A priority number for the presence
		 * @see org.igniterealtime.xiff.data.Presence
		 */
		public function setPresence( show:String, status:String, priority:Number ):void
		{
			//var tempPresence:Presence = new Presence( null, null, Presence.AVAILABLE_TYPE, show, status, priority );
			var tempPresence:Presence = new Presence( null, null, null, show, status, priority );
			myConnection.send( tempPresence );
		}
		

		
		public function fetchRoster_result( resultIQ:IQ ):void
		{
			// Clear out the old roster
			removeAll();
			try
			{
				var exts:Array = resultIQ.getAllExtensionsByNS( RosterExtension.NS );
				var len:int = exts.length;
				for (var x:int; x < len; x++){
					var ext:RosterExtension = exts[x];
					var newItems:Array = ext.getAllItems();
					var eLen:int = newItems.length;
					for( var i:int=0; i < eLen; i++ ) {
						var item:* = newItems[ i ];
						//var classInfo:XML = flash.utils.describeType(item);
						if (item is XMLStanza){
							var groups:Array = item.getGroups();
							var gLen:int = groups.length;
							if( gLen > 0 ){
								for (var j:int=0; j < gLen;j++) {
									addRosterItem( item.jid, item.name, RosterExtension.SHOW_UNAVAILABLE, "Offline", item.getGroups()[j], item.subscription.toLowerCase() );
								}	
							}else{
								addRosterItem( item.jid, item.name, RosterExtension.SHOW_UNAVAILABLE, "Offline", "General", item.subscription.toLowerCase() );
							}
						}				
					}
				}
			}
			catch (e:Error)
			{
				trace("Error : null trapped. Resuming.");
			}
		}
	
	
		public function addContact_result( resultIQ:IQ ):void
		{
			// Contact was added, request subscription
			requestSubscription( pendingSubscriptionRequestJID );
			pendingSubscriptionRequestJID = null;
		}
		
		public function unsubscribe_result( resultIQ:IQ ):void
		{
			// Does nothing for now
		}
		
		private function handleEvent( eventObj:* ):void
		{
			switch( eventObj.type )
			{	
				// Handle any incoming presence items
				case "presence":
					handlePresence( eventObj.data );
					break;
				
				// Fetch the roster immediately after login
				case "login":
					fetchRoster();
					// Tell the server we are online and available
					//setPresence( Presence.SHOW_NORMAL, "Online", 5 );
					setPresence( null, "Online", 5 );
					break;
					
				case RosterExtension.NS:
					try
					{
						var tempIQ:IQ = eventObj.iq as IQ;
						var ext:RosterExtension = tempIQ.getAllExtensionsByNS( RosterExtension.NS )[0] as RosterExtension;
						var rosterItem:* = ext.getAllItems()[0];
						// Add this item to the roster if it's not there
						var l:uint = length;
						for( var i:uint = 0; i < l; i++ ) {
							if( getItemAt( i ).jid.toLowerCase() == rosterItem.jid.toLowerCase() ) {
								updateRosterItemSubscription( i, rosterItem.subscription.toLowerCase(), rosterItem.name, rosterItem.getGroups()[0] );
								
								// Check to see if subscription was removed, and send an event if so
								if( rosterItem.subscription.toLowerCase() == RosterExtension.SUBSCRIBE_TYPE_NONE ) {
									
									var ev:RosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_REVOCATION);
									ev.jid = rosterItem.jid;
									dispatchEvent( ev );
								}
								return;
							}
						}
						
						// Add the new item as long as this is not a remove subscription response
						if( rosterItem.subscription.toLowerCase() != RosterExtension.SUBSCRIBE_TYPE_REMOVE ) {
							// Get any possible group name for this item
							addRosterItem( rosterItem.jid, rosterItem.name, RosterExtension.SHOW_UNAVAILABLE, "Offline", rosterItem.getGroups()[0], rosterItem.subscription.toLowerCase() );
						}
					}
					catch (e:Error)
					{
						trace("Error : null trapped. Resuming.");
					}
					break;
			}
		}
		
		private function handlePresence( aPresence:Presence ):void
		{
			// Handle based on the type of the presence received
			aPresence.type = (aPresence.type == null)?(Presence.AVAILABLE_TYPE):(aPresence.type);
			
			switch( aPresence.type.toLowerCase() )
			{
				case Presence.SUBSCRIBE_TYPE:
					var sReq:RosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_REQUEST);
					sReq.jid = aPresence.from;
					dispatchEvent(sReq);
					break;
					
				case Presence.UNSUBSCRIBED_TYPE:
					var sDeny:RosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_DENIAL);
					sDeny.jid = aPresence.from;
					dispatchEvent(sDeny);
					break;
					
				case Presence.UNAVAILABLE_TYPE:
					var unavailEv:RosterEvent = new RosterEvent(RosterEvent.USER_UNAVAILABLE);
					unavailEv.jid = aPresence.from;
					dispatchEvent(unavailEv);
					var l:uint = length;
					for( var i:uint = 0; i < l; i++ ) {
						var r:* = getItemAt( i );
						if( r.jid.toLowerCase() == aPresence.from.split("/")[0].toLowerCase() ) {
							r.show = RosterExtension.SHOW_UNAVAILABLE;
							removeItemAt(i);
							addItemAt(r,i);
							break;
						}
					}
					break;
				
				// AVAILABLE is the default type, so undefined is also possible
				case Presence.AVAILABLE_TYPE:
				//case undefined:
					var availEv:RosterEvent = new RosterEvent(RosterEvent.USER_AVAILABLE);
					availEv.jid =  aPresence.from;
					availEv.data = aPresence;
					dispatchEvent(availEv);
					
					// Change the item on the roster
					var ll:uint = length;
					for( var ii:uint = 0; ii < ll; ii++ ) {
						if( getItemAt( ii ).jid.toLowerCase() == aPresence.from.split("/")[0].toLowerCase() ) {
							updateRosterItemPresence( ii, aPresence );
							// removed break, beacuse if user is in seeral groups only one itme gets updated. Bug fix by guido
							//break;
						}
					}					
					break;
			}
					
		}
		private function addRosterItem( jid:String, displayName:String, show:String, status:String, group:String, type:String ):Boolean
		{
			// If no displayName, use the jid
			if( displayName == null ){
				displayName = jid;
			}
				
			var tempRI:Object = {jid:jid, displayName:displayName, group:group, subscribeType:type, status:status, show:show, priority:null};
			// XIFF-10
			if(jid != null) {
				// we need to check if the item already exists (as in pending request)
				for (var i:int=0; i<length; i++){
					if (getItemAt(i).jid == jid)
					{
						// if so, do nothing.. item will update with presence information
						return true;
					}
				}
				
				addItem( tempRI );
			}
			return true;
		}
		
		private function updateRosterItemSubscription( index:Number, type:String, name:String, group:String ):void
		{
			// Update this appropriately
			if( type == "remove" ) {
				var i:Object = removeItemAt( index );
			}
			else {
				var item:Object = getItemAt( index );
				item.subscribeType = type;
				item.group = group;
				item.displayName = name != null ? name : item.jid;
				removeItemAt(index);
				addItemAt(item, index);
			}
		}
		
		private function updateRosterItemPresence( index:*, presence:Presence ):void
		{
			var item:Object = getItemAt( index );
			item.status = presence.status;
			// By default, normal isn't specified, so if null, we will use NORMAL
			item.show = presence.show != null ? presence.show : Presence.SHOW_NORMAL;
			item.priority = presence.priority;
			removeItemAt(index);
			addItemAt(item, index);
		}
		
		
		/**
		 * The instance of the XMPPConnection class to use for the roster to use for
		 * sending and receiving data.
		 *
		 * @availability Flash Player 7
		 */
		public function get connection():XMPPConnection
		{
			return myConnection;
		}
		
		public function set connection( aConnection:XMPPConnection ):void
		{
			myConnection = aConnection;
			// Set up listeners
			myConnection.addEventListener(PresenceEvent.PRESENCE, handleEvent);
			myConnection.addEventListener(LoginEvent.LOGIN, handleEvent);
			myConnection.addEventListener( RosterExtension.NS, handleEvent );
		}
	}
}
