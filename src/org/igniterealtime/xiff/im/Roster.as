/*
 * License
 */
package org.igniterealtime.xiff.im
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import org.igniterealtime.xiff.core.*;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.data.im.*;
	import org.igniterealtime.xiff.events.*;
	
	/**
	 * Broadcast whenever someone revokes your presence subscription. This is not
	 * an event that is fired when you revoke a subscription, but rather when one of your
	 * contacts decides that he/she/it no longer wants you to know about their presence
	 * status.
	 *
	 * The event object contains an attribute <code>jid</code> with the JID of
	 * the user who revoked your subscription.
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.SUBSCRIPTION_REVOCATION
	 */
	[Event(name="subscriptionRevocation", type="org.igniterealtime.xiff.events.RosterEvent")]
	
	/**
	 * Broadcast whenever someone requests to subscribe to your presence. The event object
	 * contains an attribute <code>jid</code> with the JID of the user who is requesting
	 * a presence subscription.
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.SUBSCRIPTION_REQUEST
	 */
	[Event(name="subscriptionRequest", type="org.igniterealtime.xiff.events.RosterEvent")]
	
	/**
	 * Broadcast whenever a subscription request that you make (via the <code>addContact()</code>
	 * or <code>requestSubscription()</code> methods) is denied.
	 *
	 * The event object contains an attribute <code>jid</code> with the JID of the user who
	 * denied the request.
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.SUBSCRIPTION_DENIAL
	 */
	[Event(name="subscriptionDenial", type="org.igniterealtime.xiff.events.RosterEvent")]
	
	/**
	 * Broadcast whenever a contact in the roster becomes unavailable. (Goes from online to offline.)
	 * The event object contains an attribute <code>jid</code> with the JID of the user who
	 * became unavailable.
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.USER_UNAVAILABLE
	 */
	[Event(name="userAvailable", type="org.igniterealtime.xiff.events.RosterEvent")]
	
	/**
	 * Broadcast whenever a contact in the roster becomes available. (Goes from offline to online.)
	 * The event object contains an attribute <code>jid</code> with the JID of the user who
	 * became available.
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.USER_AVAILABLE
	 */
	[Event(name="userAvailable", type="org.igniterealtime.xiff.events.RosterEvent")]
	
	/**
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.ROSTER_LOADED
	 */
	[Event(name="rosterLoaded", type="org.igniterealtime.xiff.events.RosterEvent")]
	
	/**
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.USER_REMOVED
	 */
	[Event(name="userRemoved", type="org.igniterealtime.xiff.events.RosterEvent")]
	
	/**
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.USER_PRESENCE_UPDATED
	 */
	[Event(name="userPresenceUpdated", type="org.igniterealtime.xiff.events.RosterEvent")]
	
	/**
	 * @eventType org.igniterealtime.xiff.events.RosterEvent.USER_SUBSCRIPTION_UPDATED
	 */
	[Event(name="userSubscriptionUpdated", type="org.igniterealtime.xiff.events.RosterEvent")]
	
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
	 * @param	externalDataProvider (Optional) A reference to an instance of a data provider
	 */
	public class Roster extends ArrayCollection
	{
		private var myConnection:XMPPConnection;
		
		//FIXME: does not support multiple pending requests
		private var pendingSubscriptionRequestJID:UnescapedJID;
		
		//FIXME: maps should not be arrays
		private var _presenceMap:Array = [];
		
		[Bindable]
		public var groups:ArrayCollection = new ArrayCollection();
		
		private static const staticConstructorDependencies:Array = [
			ExtensionClassRegistry,
			RosterExtension
		]
		
		private static var rosterStaticConstructed:Boolean = RosterStaticConstructor();
		
		/**
		 * 
		 * @param	aConnection A reference to an XMPPConnection class instance
		 */
		public function Roster( aConnection:XMPPConnection = null)
		{
			
			if (aConnection != null)
			{
				connection = aConnection;
			}
			var groupSort:Sort = new Sort();
			groupSort.fields = [new SortField("label", true)];
			groups.sort = groupSort;
		}
		
		/**
		 * 
		 * @return
		 */
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
		 * @param	id The JID of the contact to add
		 * @param	displayName A friendly name for use when displaying this contact in the roster
		 * @param	groupName (Optional) The name of the group that this contact should be added to. (Used for
		 * organization in the roster listing.
		 * @param	requestSubscription (Optional) Determines whether a subscription request should be sent
		 * to this user. Most of the time you will want this parameter to be true.
		 * You will be unable to view the contacts presence status until a subscription request is granted.
		 * @example	This example adds a contact to the roster and simultaneously requests a presence subscription
		 * with the new contact.
		 * <pre>myRoster.addContact( "homer@springfield.com", "Homer", "Drinking Buddies", true );</pre>
		 */
		public function addContact( id:UnescapedJID, displayName:String, groupName:String = null, requestSubscription:Boolean=true ):void
		{
			if( displayName == null )
				displayName = id.toString();
				
			var callbackObj:Roster = null;
			var callbackMethod:String = null;
			var subscription:String = RosterExtension.SUBSCRIBE_TYPE_NONE;
			var askType:String = RosterExtension.ASK_TYPE_NONE;
			
			if ( requestSubscription == true )
			{
				callbackObj = this;
				callbackMethod = "addContact_result";
				pendingSubscriptionRequestJID = id;
				subscription = RosterExtension.SUBSCRIBE_TYPE_TO;
				askType = RosterExtension.ASK_TYPE_SUBSCRIBE
			}
				
			var tempIQ:IQ = new IQ (null, IQ.SET_TYPE, XMPPStanza.generateID("add_user_"), callbackMethod, callbackObj );
			var ext:RosterExtension = new RosterExtension( tempIQ.getNode() );
			ext.addItem( id.escaped, null, displayName, groupName ? [groupName] : null );
			tempIQ.addExtension( ext );
			myConnection.send( tempIQ );
	
			
			addRosterItem( id, displayName, RosterExtension.SHOW_PENDING, RosterExtension.SHOW_PENDING, 
				[groupName], subscription, askType );
		}
		
		/**
		 * Requests subscription authorization with a user or service. In the XMPP-world, you cannot receive
		 * notifications on changes to a contact's presence until that contact has authorized you to subscribe
		 * to his/her/its presence.
		 *
		 * @param	id The JID of the user or service that you wish to subscribe to
		 * @see	#subscriptionDenial
		 */
		public function requestSubscription( id:UnescapedJID, isResponse:Boolean=false):void
		{
			// Roster length is 0 if it a response to a user request. we must handle this event.
			var tempPresence:Presence;
			if (isResponse)
			{
				tempPresence = new Presence( id.escaped, null, Presence.SUBSCRIBE_TYPE );
				myConnection.send( tempPresence );
				return;
			}
			// Only request for items in the roster
			if (contains(RosterItemVO.get(id, false)))
			{
				tempPresence = new Presence( id.escaped, null, Presence.SUBSCRIBE_TYPE );
				myConnection.send( tempPresence );
			}
		}
		
		/**
		 * Removes a contact from the roster and revokes all presence subscriptions for that contact.
		 * This method will only attempt action if the contact you are trying to remove is currently on the
		 * roster in the first place.
		 *
		 * @param	rosterItem The value object which is to be removed
		 */
		public function removeContact( rosterItem:RosterItemVO):void
		{
			if(contains(rosterItem))
			{
				var tempIQ:IQ = new IQ( null, IQ.SET_TYPE, XMPPStanza.generateID("remove_user_"), "unsubscribe_result", this );
				var ext:RosterExtension = new RosterExtension( tempIQ.getNode() );
				ext.addItem(new EscapedJID(rosterItem.jid.bareJID), RosterExtension.SUBSCRIBE_TYPE_REMOVE );
				tempIQ.addExtension( ext );
				myConnection.send( tempIQ );
				
				//the roster item is not actually removed from the roster
				//until confirmation comes back from the XMPP server
			}
		}
		
		/**
		 * Fetches the roster data from the server. Once the data has been fetched, the Roster's data
		 * provider is populated appropriately. If the Roster-XMPPConnection class dependency has been
		 * set up before logging in, then this method will be called automatically because the Roster
		 * listens for "login" events from the XMPPConnection.
		 *
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
		 * @param	tojid The JID of the user or service to grant subscription to
		 * @param	requestAfterGrant Whether or not a reciprocal subscription request should be sent
		 * to the grantee, so that you may, in turn, subscribe to his/her/its presence.
		 */
		public function grantSubscription( tojid:UnescapedJID, requestAfterGrant:Boolean = true ):void
		{
			var tempPresence:Presence = new Presence( tojid.escaped, null, Presence.SUBSCRIBED_TYPE );
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
		 * @param	tojid The JID of the user or service that you are denying subscription
		 */
		public function denySubscription( tojid:UnescapedJID ):void
		{
			var tempPresence:Presence = new Presence( tojid.escaped, null, Presence.UNSUBSCRIBED_TYPE );
			myConnection.send( tempPresence );
		}
		
		/**
		 * Updates the information for an existing contact. You can use this method to change the
		 * display name or associated group for a contact in your roster.
		 *
		 * @param	rosterItem The value object of the contact to update
		 * @param	newName The new display name for this contact
		 * @param	newGroups The new groups to associate the contact with
		 */
		private function updateContact( rosterItem:RosterItemVO, newName:String, groupNames:Array ):void
		{
			var tempIQ:IQ = new IQ( null, IQ.SET_TYPE, XMPPStanza.generateID("update_contact_") );
			var ext:RosterExtension = new RosterExtension( tempIQ.getNode() );
			
			ext.addItem( rosterItem.jid.escaped, rosterItem.subscribeType, newName, groupNames );
			tempIQ.addExtension( ext );
			myConnection.send( tempIQ );
		}
		
		/**
		 * Updates the display name for an existing contact.
		 *
		 * @param	rosterItem The value object of the contact to update
		 * @param	newName The new display name for this contact
		 */
		public function updateContactName( rosterItem:RosterItemVO, newName:String ):void
		{
			var groupNames:Array = [];
			for each(var group:RosterGroup in getContainingGroups(rosterItem))
			{
				groupNames.push(group.label);
			}
			updateContact( rosterItem, newName, groupNames);
		}
		
		/**
		 *
		 * @param	item
		 * @return
		 */
		public function getContainingGroups(item:RosterItemVO):Array
		{
			var result:Array = [];
			for each(var group:RosterGroup in groups)
			{
				if(group.contains(item))
					result.push(group);
			}
			return result;
		}
		
		/**
		 * Updates the groups associated with an existing contact.
		 *
		 * @param	rosterItem The value object of the contact to update
		 * @param	newGroups The new groups to associate the contact with
		 */
		public function updateContactGroups( rosterItem:RosterItemVO, newGroupNames:Array ):void
		{
			updateContact( rosterItem, rosterItem.displayName, newGroupNames );
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
		 * @param	show The show type for your presence. This represents what others should see - whether
		 * you are offline, online, away, etc.
		 * @param	status The status message associated with the show value
		 * @param	priority (Optional) A priority number for the presence
		 * @see	org.igniterealtime.xiff.data.Presence
		 */
		public function setPresence( show:String, status:String, priority:Number ):void
		{
			//var tempPresence:Presence = new Presence( null, null, Presence.AVAILABLE_TYPE, show, status, priority );
			var tempPresence:Presence = new Presence( null, null, null, show, status, priority );
			myConnection.send( tempPresence );
		}
		
		/**
		 * 
		 * @param	resultIQ
		 */
		public function fetchRoster_result( resultIQ:IQ ):void
		{
			// Clear out the old roster
			removeAll();
			try
			{
				disableAutoUpdate()
				for each(var ext:RosterExtension in resultIQ.getAllExtensionsByNS( RosterExtension.NS ))
				{
					for each(var item:* in ext.getAllItems())
					{
						//var classInfo:XML = flash.utils.describeType(item);
						if (!item is XMLStanza)
							continue;
						
						var askType:String = item.askType != null ? item.askType.toLowerCase() : RosterExtension.ASK_TYPE_NONE;
						addRosterItem( new UnescapedJID(item.jid), item.name, RosterExtension.SHOW_UNAVAILABLE, 
							"Offline", item.groupNames, item.subscription.toLowerCase(), askType);
					}
				}
				enableAutoUpdate();
				
				// Fire Roster Loaded Event
				var rosterEvent:RosterEvent = new RosterEvent(RosterEvent.ROSTER_LOADED, false, false);
				dispatchEvent(rosterEvent);
			}
			catch (e:Error)
			{
				trace(e.getStackTrace());
			}
		}
	
		/**
		 * 
		 * @param	resultIQ
		 */
		public function addContact_result( resultIQ:IQ ):void
		{
			// Contact was added, request subscription
			requestSubscription( pendingSubscriptionRequestJID );
			pendingSubscriptionRequestJID = null;
		}
		
		/**
		 * 
		 * @param	resultIQ
		 */
		public function unsubscribe_result( resultIQ:IQ ):void
		{
			// Does nothing for now
		}
			
		/**
		 * 
		 * @param	eventObj PresenceEvent, LoginEvent or RosterExtension
		 */
		private function handleEvent( eventObj:* ):void
		{

			switch( eventObj.type )
			{
				// Handle any incoming presence items
				case PresenceEvent.PRESENCE:
					handlePresences( eventObj.data );
					break;
				
				// Fetch the roster immediately after login
				case LoginEvent.LOGIN:
					fetchRoster();
					// Tell the server we are online and available
					//setPresence( Presence.SHOW_NORMAL, "Online", 5 );
					setPresence( null, "Online", 5 );
					break;
					
				case RosterExtension.NS:
					try
					{
						var ext:RosterExtension = (eventObj.iq as IQ).getAllExtensionsByNS( RosterExtension.NS )[0] as RosterExtension;
						for each(var item:* in ext.getAllItems())
						{
							var jid:UnescapedJID = new UnescapedJID(item.jid);
							var rosterItemVO:RosterItemVO = RosterItemVO.get(jid, true);
							var ev: RosterEvent;
							
							if (contains(rosterItemVO))
							{
								switch (item.subscription.toLowerCase())
								{
									case RosterExtension.SUBSCRIBE_TYPE_NONE:
										ev = new RosterEvent(RosterEvent.SUBSCRIPTION_REVOCATION);
										ev.jid = jid;
										dispatchEvent( ev );
										break;
									
									case RosterExtension.SUBSCRIBE_TYPE_REMOVE:
										ev = new RosterEvent(RosterEvent.USER_REMOVED);
										for each(var group:RosterGroup in getContainingGroups(rosterItemVO))
										{
											group.removeItem(rosterItemVO);
										}
										//should be impossible for getItemIndex to return -1, since we just looked it up
										ev.data = removeItemAt(getItemIndex(rosterItemVO));
										ev.jid = jid;
										dispatchEvent(ev);
										break;
														
									default:
										updateRosterItemSubscription(rosterItemVO, item.subscription.toLowerCase(), item.name, item.groupNames);
										break;
								}
							}
							else
							{
								var groups:Array = item.groupNames;
								var askType:String = item.askType != null ? 
									item.askType.toLowerCase() : RosterExtension.ASK_TYPE_NONE;

								if ( item.subscription.toLowerCase() != RosterExtension.SUBSCRIBE_TYPE_REMOVE &&
									item.subscription.toLowerCase() != RosterExtension.SUBSCRIBE_TYPE_NONE)
								{
									// Add this item to the roster if it's not there and if the subscription type is not equal to 'remove' or 'none'
									addRosterItem( jid, item.name, RosterExtension.SHOW_UNAVAILABLE, "Offline",
										groups, item.subscription.toLowerCase(), askType );
								}
								else if ( (item.subscription.toLowerCase() == RosterExtension.SUBSCRIBE_TYPE_NONE || 
									item.subscription.toLowerCase() == RosterExtension.SUBSCRIBE_TYPE_FROM) && 
										item.askType == RosterExtension.ASK_TYPE_SUBSCRIBE )
								{
									// A contact was added to the roster, and its authorization is still pending.
									addRosterItem( jid, item.name, RosterExtension.SHOW_PENDING, "Pending", groups,
										item.subscription.toLowerCase(), askType );
								}
							}
						}
					}
					catch (e:Error)
					{
						trace(e.getStackTrace());
					}
					break;
			}
		}
		
		/**
		 * Dispathing <code>RosterEvent</code> based on the types of the <code>Presence</code>.
		 * @param	presenceArray	A pile of presences received at one time
		 */
		private function handlePresences( presenceArray:Array):void
		{
			for each(var aPresence:Presence in presenceArray)
			{
				var type:String = aPresence.type ? aPresence.type.toLowerCase() : null;
				var rosterEvent:RosterEvent = null;
				
				switch( type )
				{
					case Presence.SUBSCRIBE_TYPE:
						rosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_REQUEST);
						break;
						
					case Presence.UNSUBSCRIBED_TYPE:
						rosterEvent = new RosterEvent(RosterEvent.SUBSCRIPTION_DENIAL);
						break;
					
					case Presence.UNAVAILABLE_TYPE:
						rosterEvent = new RosterEvent(RosterEvent.USER_UNAVAILABLE);
	
						var unavailableItem:RosterItemVO = RosterItemVO.get(aPresence.from.unescaped, false);
						if(!unavailableItem) return;
						updateRosterItemPresence( unavailableItem, aPresence );
						
						break;
					
					// null means available
					default:
						rosterEvent = new RosterEvent(RosterEvent.USER_AVAILABLE);
						rosterEvent.data = aPresence;
						
						// Change the item on the roster
						var availableItem:RosterItemVO;
						if(aPresence.from)
							availableItem = RosterItemVO.get(aPresence.from.unescaped, false);
						
						if(!availableItem) return;
						updateRosterItemPresence( availableItem, aPresence );
						
						break;
				}
				
				if (rosterEvent != null)
				{
					// from can sometimes not be set
					if (aPresence.from)
					{
						rosterEvent.jid = aPresence.from.unescaped;
					}
					dispatchEvent(rosterEvent);
				}
			}
		}
		
		private function addRosterItem( jid:UnescapedJID, displayName:String, show:String, status:String, groupNames:Array, type:String, askType:String="none" ):Boolean
		{
			if(!jid)
				return false;
			
			var rosterItem:RosterItemVO = RosterItemVO.get(jid, true);
			if(!contains(rosterItem))
				addItem( rosterItem );
			if(displayName)
				rosterItem.displayName = displayName;
			rosterItem.subscribeType = type;
			rosterItem.askType = askType;
			rosterItem.status = status;
			rosterItem.show = show;
			setContactGroups(rosterItem, groupNames);
			
			var event:RosterEvent = new RosterEvent(RosterEvent.USER_ADDED);
			event.jid = jid;
			event.data = rosterItem;
			dispatchEvent(event);

			return true;
		}
		
		private function setContactGroups(contact:RosterItemVO, groupNames:Array):void
		{
			groups.disableAutoUpdate();
			if(!groupNames || groupNames.length == 0)
			{
				groupNames = ["General"];
			}
			for each(var name:String in groupNames)
			{
				//if there's no group by this name already, we need to make one
				if(!getGroup(name))
					groups.addItem(new RosterGroup(name));
			}
			for each(var group:RosterGroup in groups)
			{
				if(groupNames.indexOf(group.label) >= 0)
					group.addItem(contact);
				else
					group.removeItem(contact);
			}
			groups.enableAutoUpdate();
		}
		
		private function updateRosterItemSubscription( item:RosterItemVO, type:String, name:String, newGroupNames:Array ):void
		{
			item.subscribeType = type;
			
			setContactGroups(item, newGroupNames);

			if(name)
				item.displayName = name;
			
			var event:RosterEvent = new RosterEvent(RosterEvent.USER_SUBSCRIPTION_UPDATED);
			event.jid = item.jid;
			event.data = item;
			dispatchEvent(event);
		}
		
		private function updateRosterItemPresence( item:RosterItemVO, presence:Presence ):void
		{
			try
			{
				item.status = presence.status;
				item.show = presence.show;
				item.priority = presence.priority;
				if(!presence.type)
					item.online = true;
				else if(presence.type == Presence.UNAVAILABLE_TYPE)
					item.online = false;
				
				var event:RosterEvent = new RosterEvent(RosterEvent.USER_PRESENCE_UPDATED);
				event.jid = item.jid;
				event.data = item;
				_presenceMap[item.jid.toString()] = presence;
				dispatchEvent(event);
			}
			catch (e:Error)
			{
				trace(e.getStackTrace());
			}
		}
		
		public function getPresence(jid:UnescapedJID):String
		{
			return _presenceMap[jid.toString()];
		}
		
		public function getGroup(name:String):RosterGroup
		{
			for each(var group:RosterGroup in groups)
			{
				if(group.label == name)
					return group;
			}
			return null;
		}
		
		/**
		 * The instance of the XMPPConnection class to use for the roster to use for
		 * sending and receiving data.
		 */
		public function get connection():XMPPConnection
		{
			return myConnection;
		}
		public function set connection( aConnection:XMPPConnection ):void
		{
			myConnection = aConnection;
			myConnection.addEventListener(PresenceEvent.PRESENCE, handleEvent);
			myConnection.addEventListener(LoginEvent.LOGIN, handleEvent);
			myConnection.addEventListener( RosterExtension.NS, handleEvent );
		}
		
		public override function set filterFunction(f:Function):void
		{
			throw new Error("Setting the filterFunction on Roster is not allowed; Wrap it in a ListCollectionView and filter that.");
		}
	}
}
