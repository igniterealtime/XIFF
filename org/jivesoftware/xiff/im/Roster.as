﻿package org.jivesoftware.xiff.im{
/*
 * Copyright (C) 2003-2004 
 * Sean Voisen <sean@mediainsites.com>
 * Sean Treadway <seant@oncotype.dk>
 * Media Insites, Inc.
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
	
	import org.jivesoftware.xiff.data.Presence;
	import org.jivesoftware.xiff.data.IQ;
	import org.jivesoftware.xiff.core.XMPPConnection;
	import org.jivesoftware.xiff.data.im.RosterExtension;
	import org.jivesoftware.xiff.data.ExtensionClassRegistry;
	import org.jivesoftware.xiff.data.XMPPStanza;
	import flash.events.EventDispatcher;
	
	import org.jivesoftware.xiff.events.*;
	import org.jivesoftware.xiff.utility.DataProvider;
	import org.jivesoftware.xiff.utility.DataProviderEvent;
	import flash.events.Event;
	import flash.utils.describeType;
	import org.jivesoftware.xiff.data.XMLStanza;
	import flash.xml.XMLDocument;
	
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
	public class Roster extends EventDispatcher
	{
		private var myConnection:XMPPConnection;
		private var rosterItems:DataProvider;
		
		
		private var pendingSubscriptionRequestJID:String;
		
		// These are needed by the EventDispatcher
		//private var dispatchEvent:Function;
		//public var removeEventListener:Function;
		//public var addEventListener:Function;
		
		// Used for static constructor with EventDispatcher and DataProvider
		/* 
		mx.controls.listclasses.DataProvider is phased out along with support for v2 components
		*/
		private static var staticConstructorDependencies:Array = [
			//mx.events.EventDispatcher,
			//mx.controls.listclasses.DataProvider,
			
			ExtensionClassRegistry,
			RosterExtension
		]
		
		private static var rosterStaticConstructed:Boolean = RosterStaticConstructor();
		
		//public function Roster( aConnection:XMPPConnection = null, externalDataProvider:Object = null)
		public function Roster( aConnection:XMPPConnection = null)
		{	
			// Initialize the rosterItems
			// If an external dataprovider is provided, use that instead
			/*(
			if( externalDataProvider != null ) {
				setExternalDataProvider( externalDataProvider );
			}
			else {
				rosterItems = new DataProvider();
				rosterItems.addEventListener(DataProviderEvent.MODEL_CHANGED, handleEvent);
				//rosterItems.addEventListener( "modelChanged", this );
			}
			*/
			rosterItems = new DataProvider();
			rosterItems.addEventListener(DataProviderEvent.MODEL_CHANGED, handleEvent);
			
			if (aConnection != null){ 
				connection = aConnection;
			}
		}
		
		private static function RosterStaticConstructor():Boolean
		{	
			//mx.events.EventDispatcher.initialize( Roster.prototype );
			//mx.controls.listclasses.DataProvider.Initialize( Array );
			
			ExtensionClassRegistry.register( RosterExtension );
			
			return true;
		}
		
		/**
		 * Allows use of an external data provider instead of the one used internally by the
		 * class by default. This is useful in the case of a Macromedia Central application
		 * where the data provider might need to be an instance of an LCDataProvider.
		 *
		 * The data provider should either implement the Data Provider API interface, or
		 * the interface for Central's LCDataProvider.
		 *
		 * @availability Flash Player 7
		 * @param externalDP A reference to the external data provider
		 */
		/*
		public function setExternalDataProvider( externalDP:Object ):void
		{
			// Check to see that it hasn't already been set, else it will overwrite for no reason
			if( rosterItems !== externalDP ) {
				// Copy what ever is in the current data provider in case switching on the fly
				externalDP.removeAll()
				
				var l = rosterItems.getLength == undefined ? rosterItems.getLength() : rosterItems.length;
				for( var i:uint = 0; i < l; i++ )
					externalDP.addItem( rosterItems.getItemAt( i ) );
					
	            rosterItems.removeEventListener("modelChanged", this);
				rosterItems = externalDP;
			}
		}
		*/
		
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
		public function addContact( id:String, displayName:String, group:String, requestSubscription:Boolean ):void
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
	
			// We can directly add this contact without updating our roster.  We also
			// need the roster item for changing the subscription type (if requested)
			//
			// XXX Sean, please review this and remove this comment
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
		public function requestSubscription( id:String ):void
		{
			// Only request for items in the roster
			var l:int = rosterItems.length;
			for( var i:int = 0; i < l; i++ ) {
				if( rosterItems.getItemAt( i ).jid.toLowerCase() == id.toLowerCase() ) {
					var tempPresence:Presence = new Presence( id, null, Presence.SUBSCRIBE_TYPE );
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
			var l:uint = rosterItems.length;
			//var l = rosterItems.getLength !== undefined ? rosterItems.getLength() : rosterItems.length;
			for( var i:uint = 0; i < l; i++ ) {
				// Only attempt unsubscribe to users that we are currently subscribed to
				if( rosterItems.getItemAt( i ).jid.toLowerCase() == id.toLowerCase() ) {
					var tempIQ:IQ = new IQ( null, IQ.SET_TYPE, XMPPStanza.generateID("remove_user_"), "unsubscribe_result", this );
					var ext:RosterExtension = new RosterExtension( tempIQ.getNode() );
					ext.addItem( id, RosterExtension.SUBSCRIBE_TYPE_REMOVE );
					tempIQ.addExtension( ext );
					myConnection.send( tempIQ );
					rosterItems.removeItemAt(i); 
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
		public function grantSubscription( tojid:String, requestAfterGrant:Boolean = false ):void
		{
			var tempPresence:Presence = new Presence( tojid, null, Presence.SUBSCRIBED_TYPE );
			myConnection.send( tempPresence );
			
			// Request a return subscription
			if( requestAfterGrant ) {
				requestSubscription( tojid );
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
			var l:uint = rosterItems.length;
			//var l = rosterItems.getLength !== undefined ? rosterItems.getLength() : rosterItems.length;
			for( var i:uint = 0; i < l; i++ ) {
				if( id.toLowerCase() == rosterItems.getItemAt( i ).jid.toLowerCase() ) {
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
			var l:uint = rosterItems.length;
			//var l = rosterItems.getLength !== undefined ? rosterItems.getLength() : rosterItems.length;
			for( var i:uint = 0; i < l; i++ ) {
				if( jid.toLowerCase() == rosterItems.getItemAt( i ).jid.toLowerCase() )
					return rosterItems.getItemAt( i );
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
		 * @see org.jivesoftware.xiff.data.Presence
		 */
		public function setPresence( show:String, status:String, priority:Number ):void
		{
			//var tempPresence:Presence = new Presence( null, null, Presence.AVAILABLE_TYPE, show, status, priority );
			var tempPresence:Presence = new Presence( null, null, null, show, status, priority );
			myConnection.send( tempPresence );
		}
		
		/**
		 * Gets a roster item at a specific index. 
		 * Part of the "read-only" implementation of the DataProvider API. Roster items are 
		 * generic objects with the following attributes: <code>jid</code>, <code>displayName</code>, <code>group</code>, 
		 * <code>subscribeType</code>, <code>status</code>, <code>show</code>, and <code>priority</code>.
		 *
		 * @availability Flash Player 7
		 * @param index The index of the item to get
		 * @return An object representing the roster item retrieved. Null, if none is found at the index provided.
		 */
		public function getItemAt( index:Number ):Object
		{
			return rosterItems.getItemAt( index );
		}
		
		/**
		 * Gets the ID of a roster item at a particular index.
		 * Part of the "read-only" implementation of the DataProvider API.
		 *
		 * @availability Flash Player 7
		 * @param index The index of the item whose ID you wish to retrieve
		 * @return The item ID
		 */
		/*
		public function getItemID( index:uint ):Number
		{
			return rosterItems.getItemID( index );
		}
		*/
		
		/**
		 * Sorts items in the roster using a specific comparison function
		 * as passed to the method. Part of the "read-only" implementation
		 * of the DataProvider API. For more information, consult the DataProvider
		 * documentation.
		 *
		 * @param compareFunc The function to use for comparison
		 * @param optionFlags The option flags
		 * @availability Flash Player 7
		 */
		public function sortItems( compareFunc:*, optionFlags:* ):void
		{
			rosterItems.sortItems( compareFunc, optionFlags );
		}
		
		/**
		 * Sorts items in the roster by a specific field name.
		 *
		 * @param fieldName The field name to sort by
		 * @param order The sort order, either ascending or descending - "ASC" or "DSC".
		 * @example The following example sorts roster items by their display name in
		 * ascending order.
		 * <pre>myRoster.sortItemsBy( "displayName", "ASC" );</pre>
		 * @availability Flash Player 7
		 */
		public function sortItemsBy( fieldName:String, order:* ):void
		{
			rosterItems.sortItemsBy( fieldName, order );
		}
		
		// Recommended fix by gepatto to fix B3 issue
		public function fetchRoster_result( resultIQ:IQ ):void
		{
			// Clear out the old roster
			rosterItems.removeAll();
	
			//added an extra loop to go through all the extensions that are found
			var exts:Array = resultIQ.getAllExtensionsByNS( RosterExtension.NS );
			var len:int = exts.length;

			for (var x:int; x < len; x++){
				var ext:RosterExtension = exts[x];
				var newItems:Array = ext.getAllItems();
				var eLen:int = newItems.length;
				for( var i:int=0; i < len; i++ ) {
					var item:* = newItems[ i ];
					var classInfo:XML = flash.utils.describeType(item);
					if (item is XMLStanza){
						var groups:Array = item.getGroups();
						var gLen:int = groups.length;
						
						if( gLen > 0 ){
							//if a user is in several groups, add it as item for each group. Fix by guido
							for (var j:int=0; j < gLen;j++) {
								addRosterItem( item.jid, item.name, RosterExtension.SHOW_UNAVAILABLE, "Offline", 'General', item.subscription.toLowerCase() );
							}	
						}else{
							addRosterItem( item.jid, item.name, RosterExtension.SHOW_UNAVAILABLE, "Offline", "General", item.subscription.toLowerCase() );
						}
					
					}				

				}
			}
			/*
			// Go through the result IQ and add each item
			var ext:RosterExtension = resultIQ.getAllExtensionsByNS( RosterExtension.NS )[0] as RosterExtension;

			var newItems:Array = ext.getAllItems();
			
			for( var i:uint=0; i < newItems.length; i++ ) {
				var item:* = newItems[ i ];
				if( item.getGroups().length > 0 ){
					//if a user is in several groups, add it as item for each group. Fix by guido
					for (var j:uint=0; j < item.getGroups().length;j++) {
						addRosterItem( item.jid, item.name, RosterExtension.SHOW_UNAVAILABLE, "Offline", item.getGroups()[j], item.subscription.toLowerCase() );
					}	
				}else{
					addRosterItem( item.jid, item.name, RosterExtension.SHOW_UNAVAILABLE, "Offline", "General", item.subscription.toLowerCase() );
				}
				
			}
			*/
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
					//trace ("RosterExtension.NS");
					var tempIQ:IQ = eventObj.iq as IQ;
					//trace("eventObj.data is tempIQ:IQ >> " + tempIQ);
					var ext:RosterExtension = tempIQ.getAllExtensionsByNS( RosterExtension.NS )[0] as RosterExtension;
					//trace("tempIQ.getAllExtensionsByNS( RosterExtension.NS )[0] >> " + tempIQ.getAllExtensionsByNS( RosterExtension.NS )[0]);
					//trace("typeof(ext) >> " + typeof(ext));
					//trace("rosterItem = ext.getAllItems()[0] >> " + ext.getAllItems()[0]);
					var rosterItem:* = ext.getAllItems()[0];
					//trace("typeof(rosterItem) >> " + rosterItem);
					// Add this item to the roster if it's not there
					var l:uint = rosterItems.length;
					//var l = rosterItems.getLength !== undefined ? rosterItems.getLength() : rosterItems.length;
					
					//trace("rosterItem.subscription: " + rosterItem.subscription.toLowerCase());
					for( var i:uint = 0; i < l; i++ ) {
						if( rosterItems.getItemAt( i ).jid.toLowerCase() == rosterItem.jid.toLowerCase() ) {
							updateRosterItemSubscription( i, rosterItem.subscription.toLowerCase(), rosterItem.name, rosterItem.getGroups()[0] );
							
							// Check to see if subscription was removed, and send an event if so
							if( rosterItem.subscription.toLowerCase() == RosterExtension.SUBSCRIBE_TYPE_NONE ) {
								
								var ev:RosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_REVOCATION);
								ev.jid = rosterItem.jid;
								dispatchEvent( ev );
								//var eventObj:Object = {target:this, type:"subscriptionRevocation", jid:rosterItem.jid};
								//dispatchEvent( eventObj );
							}
							return;
						}
					}
					
					// Add the new item as long as this is not a remove subscription response
					if( rosterItem.subscription.toLowerCase() != RosterExtension.SUBSCRIBE_TYPE_REMOVE ) {
						// Get any possible group name for this item
						addRosterItem( rosterItem.jid, rosterItem.name, RosterExtension.SHOW_UNAVAILABLE, "Offline", rosterItem.getGroups()[0], rosterItem.subscription.toLowerCase() );
					}
					break;
					
				case DataProviderEvent.MODEL_CHANGED :
					var e:ModelChangedEvent = new ModelChangedEvent();
					
					// Forward to the listener for modelChanged
					//var forwardObj:Object = {type:eventObj.type, eventName:eventObj.eventName}
					if( eventObj.firstItem ) e.firstItem = eventObj.firstItem;
					if( eventObj.lastItem ) e.lastItem = eventObj.lastItem;
					//if( eventObj.removedIDs ) e.removedIDs = eventObj.removedIDs;
					if( eventObj.fieldName ) e.fieldName = eventObj.fieldName;

					//if( eventObj.firstItem ) forwardObj.firstItem = eventObj.firstItem;
					//if( eventObj.lastItem ) forwardObj.lastItem = eventObj.lastItem;
					//if( eventObj.removedIDs ) forwardObj.removedIDs = eventObj.removedIDs;
					//if( eventObj.fieldName ) forwardObj.fieldName = eventObj.fieldName;
					dispatchEvent( e );
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
					//var eventObj:Object = {target:this, type:"subscriptionRequest", jid:aPresence.from};
					//dispatchEvent( eventObj );
					break;
					
				case Presence.UNSUBSCRIBED_TYPE:
					var sDeny:RosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_DENIAL);
					sDeny.jid = aPresence.from;
					dispatchEvent(sDeny);
					
					//var eventObj:Object = {target:this, type:"subscriptionDenial", jid:aPresence.from};
					//dispatchEvent( eventObj );
					break;
					
				case Presence.UNAVAILABLE_TYPE:
					var unavailEv:RosterEvent = new RosterEvent(RosterEvent.USER_UNAVAILABLE);
					unavailEv.jid = aPresence.from;
					dispatchEvent(unavailEv);
					
					//var eventObj:Object = {target:this, type:"userUnavailable", jid:aPresence.from};
					//dispatchEvent( eventObj );
					var l:uint = rosterItems.length;
					//var l = rosterItems.getLength !== undefined ? rosterItems.getLength() : rosterItems.length;
					for( var i:uint = 0; i < l; i++ ) {
						var r:* = rosterItems.getItemAt( i );
						if( r.jid.toLowerCase() == aPresence.from.split("/")[0].toLowerCase() ) {
							r.show = RosterExtension.SHOW_UNAVAILABLE;
							rosterItems.replaceItemAt( i, r );
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
					var ll:uint = rosterItems.length;
					//var l = rosterItems.getLength !== undefined ? rosterItems.getLength() : rosterItems.length;
					for( var ii:uint = 0; ii < ll; ii++ ) {
						if( rosterItems.getItemAt( ii ).jid.toLowerCase() == aPresence.from.split("/")[0].toLowerCase() ) {
							updateRosterItemPresence( ii, aPresence );
							// removed break, beacuse if user is in seeral groups only one itme gets updated. Bug fix by guido
							//break;
						}
					}					
					break;
			}
					
		}
		
		private function addRosterItem( jid:String, displayName:String, show:String, status:String, group:String, type:String ):void
		{
			// If no displayName, use the jid
			if( displayName == null ){
				displayName = jid;
			}
				
			var tempRI:Object = {jid:jid, displayName:displayName, group:group, subscribeType:type, status:status, show:show, priority:null};
			// XIFF-10
			if(jid != null) {

				rosterItems.addItem( tempRI );
			}
		}
		
		private function updateRosterItemSubscription( index:Number, type:String, name:String, group:String ):void
		{
			// Update this appropriately
			if( type == "remove" ) {
				var i:int = rosterItems.removeItemAt( index );
			}
			else {
				var item:Object = rosterItems.getItemAt( index );
				item.subscribeType = type;
				item.group = group;
				item.displayName = name != null ? name : item.jid;
				rosterItems.replaceItemAt( index, item );
			}
		}
		
		private function updateRosterItemPresence( index:*, presence:Presence ):void
		{
			var item:Object = rosterItems.getItemAt( index );
			item.status = presence.status;
			// By default, normal isn't specified, so if null, we will use NORMAL
			item.show = presence.show != null ? presence.show : Presence.SHOW_NORMAL;
			item.priority = presence.priority;
			
			rosterItems.replaceItemAt( index, item );
		}
		
		/**
		 * (Read-only) The number of items in the roster.
		 *
		 * @availability Flash Player 7
		 */
		public function get length():Number
		{
			var l:uint = rosterItems.length;
			//var l:Number = rosterItems.getLength !== undefined ? rosterItems.getLength() : rosterItems.length;
			return l;
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
			//myConnection.addEventListener( "presence", this );
			//myConnection.addEventListener( "login", this );
			myConnection.addEventListener( RosterExtension.NS, handleEvent );
		}
	}
}