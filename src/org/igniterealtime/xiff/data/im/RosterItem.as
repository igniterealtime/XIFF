/*
 * License
 */
package org.igniterealtime.xiff.data.im{

	 
	import flash.xml.XMLNode;
	
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;
	
	/**
	 * This class is used internally by the RosterExtension class for managing items
	 * received and sent as roster data. Usually, each item in the roster represents a single
	 * contact, and this class is used to represent, abstract, and serialize/deserialize
	 * this data.
	 *
	 * @see	org.igniterealtime.xiff.data.im.RosterExtension
	 * @param	parent The parent XMLNode
	 */
	public class RosterItem extends XMLStanza implements ISerializable
	{
		public static var ELEMENT:String = "item";
		
		private var myGroupNodes:Array;
		
		public function RosterItem( parent:XMLNode=null )
		{
			//<query xmlns="jabber:iq:roster"><item jid="herbvaio.lymabean.com" subscription="both"><group>Buddies</group></item><item jid="alexvaio.lymabean.com" subscription="both"><group>Co-workers</group></item><item jid="jackvaio.lymabean.com" subscription="both"><group>Buddies</group></item></query>

			super();
			
			getNode().nodeName = ELEMENT;
			myGroupNodes = [];
			
			if( exists( parent ) ) {
				parent.appendChild( getNode() );
			}
		}
		
		/**
		 * Serializes the RosterItem data to XML for sending.
		 *
		 * @param	parent The parent node that this item should be serialized into
		 * @return An indicator as to whether serialization was successful
		 */
		public function serialize( parent:XMLNode ):Boolean
		{
			if (!exists(jid)) {
				trace("Warning: required roster item attributes 'jid' missing");
				return false;
			}
			
			if( parent != getNode().parentNode ) {
				parent.appendChild( getNode().cloneNode( true ) );
			}
	
			return true;
		}
		
		/**
		 * Deserializes the RosterItem data.
		 *
		 * @param	node The XML node associated this data
		 * @return An indicator as to whether deserialization was successful
		 */
		public function deserialize( node:XMLNode ):Boolean
		{
			setNode( node );
			
	
			var children:Array = node.childNodes;
			for( var i:String in children ) {
				switch( children[i].nodeName ) {
					case "group":
						myGroupNodes.push( children[i] );
						break;
				}
			}
			
			return true;
		}
		
		/**
		 * Adds a group to the roster item. Contacts in the roster can be associated
		 * with multiple groups.
		 *
		 * @param	groupName The name of the group to add
		 */
		public function addGroupNamed( groupName:String ):void
		{
			var node:XMLNode = addTextNode( getNode(), "group", groupName );
			
			myGroupNodes.push( node );
		}
		
		/**
		 * Gets a list of all the groups associated with this roster item.
		 *
		 * @return An array of strings containing the name of each group
		 */
		public function get groupNames():Array
		{
			var returnArr:Array = [];

			for( var i:String in myGroupNodes ) {
				var node:XMLNode = myGroupNodes[i].firstChild;
				if(node != null){
					returnArr.push(node.nodeValue);
				}
				//returnArr.push(myGroupNodes[i].firstChild.nodeValue);

			}
			return returnArr;
		}
		
		public function get groupCount():Number
		{
			return myGroupNodes.length;
		}
		
		public function removeAllGroups():void
		{
			for( var i:String in myGroupNodes ) {
				myGroupNodes[i].removeNode();
			}
			
			myGroupNodes = [];
		}
		
		public function removeGroupByName( groupName:String ):Boolean
		{
			for( var i:String in myGroupNodes )
			{
				if( myGroupNodes[i].nodeValue == groupName ) {
					myGroupNodes[i].removeNode();
					myGroupNodes.splice( Number(i), 1 );
					return true;
				}
			}
			
			return false;
		}	
		
		/**
		 * The JID for this roster item.
		 *
		 */
		public function get jid():EscapedJID
		{
			return new EscapedJID(getNode().attributes.jid);
		}
		
		public function set jid( newJID:EscapedJID ):void
		{
			getNode().attributes.jid = newJID.toString();
		}
		
		/**
		 * The display name for this roster item.
		 *
		 */
		public function get name():String
		{
			return getNode().attributes.name;
		}
		
		public function set name( newName:String ):void
		{
			getNode().attributes.name = newName;
		}
		
		/**
		 * The subscription type for this roster item. Subscription types
		 * have been enumerated by static variables in the RosterExtension:
		 * <ul>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_NONE</li>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_TO</li>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_FROM</li>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_BOTH</li>
		 * <li>RosterExtension.SUBSCRIBE_TYPE_REMOVE</li>
		 * </ul>
		 *
		 */
		public function get subscription():String
		{
			return getNode().attributes.subscription;
		}
		
		public function set subscription( newSubscription:String ):void
		{
			getNode().attributes.subscription = newSubscription;
		}
		
		/**
		 * The ask type for this roster item.  Ask types have
		 * been enumerated by static variables in the RosterExtension:
		 * <ul>
		 * <li>RosterExtension.ASK_TYPE_NONE</li>
		 * <li>RosterExtension.ASK_TYPE_SUBSCRIBE</li>
		 * <li>RosterExtension.ASK_TYPE_UNSUBSCRIBE</li>
		 * </ul>
		 * 
		 */
		 public function get askType():String
		 {
		 	return getNode().attributes.ask;
		 }
		 
		 public function set askType( newAskType:String ):void
		 {
		 	getNode().attributes.ask = newAskType;
		 }
		 
		 /**
		 * Convenience routine to determine if a roster item is considered "pending" or not.
		 */
		 public function get pending():Boolean
		 {
		 	if (askType == RosterExtension.ASK_TYPE_SUBSCRIBE && (subscription == RosterExtension.SUBSCRIBE_TYPE_NONE || subscription == RosterExtension.SUBSCRIBE_TYPE_FROM)) {
		 		return true;
		 	}
		 	else {
		 		return false;
		 	}
		 }
	}
	
}