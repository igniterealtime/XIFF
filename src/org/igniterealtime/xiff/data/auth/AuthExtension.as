/*
 * License
 */
package org.igniterealtime.xiff.data.auth
{	
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.ISerializable;
	
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.auth.SHA1;
	
	import flash.xml.XMLNode;
	import org.igniterealtime.xiff.data.XMLStanza;
	
	/**
	 * Implements <a href="http://xmpp.org/extensions/xep-0078.html">XEP-0078<a> 
	 * for non SASL authentication.
	 * @see	http://xmpp.org/extensions/xep-0078.html
	 */
	public class AuthExtension extends Extension implements IExtension, ISerializable
	{
		// Static class variables to be overridden in subclasses;
		public static var NS:String = "jabber:iq:auth";
		public static var ELEMENT:String = "query";
	
		private var myUsernameNode:XMLNode;
		private var myPasswordNode:XMLNode;
		private var myDigestNode:XMLNode;
		private var myResourceNode:XMLNode;
		
		public function AuthExtension( parent:XMLNode = null)
		{
			super(parent);
		}
	
		/**
		 * Gets the namespace associated with this extension.
		 * The namespace for the AuthExtension is "jabber:iq:auth".
		 *
		 * @return The namespace
		 */
		public function getNS():String
		{
			return AuthExtension.NS;
		}
	
		/**
		 * Gets the element name associated with this extension.
		 * The element for this extension is "query".
		 *
		 * @return The element name
		 */
		public function getElementName():String
		{
			return AuthExtension.ELEMENT;
		}
	
	    /**
	     * Registers this extension with the extension registry.  
	     */
	    public static function enable():void
	    {
	        ExtensionClassRegistry.register(AuthExtension);
	    }
		
		public function serialize( parent:XMLNode ):Boolean
		{
			if (!exists(getNode().parentNode)) {
				parent.appendChild(getNode().cloneNode(true));
			}
			return true;
		}
	
		public function deserialize( node:XMLNode ):Boolean
		{
			
			setNode(node);
			var children:Array = node.childNodes;
			for( var i:String in children ) {
				switch( children[i].nodeName )
				{
					case "username":
						myUsernameNode = children[i];
						break;
						
					case "password":
						myPasswordNode = children[i];
						break;
						
					case "digest":
						myDigestNode = children[i];
						break;
	
					case "resource":
						myResourceNode = children[i];
						break;
				}
			}
			return true;
		}
	
		/**
		 * Computes the SHA1 digest of the password and session ID for use when 
		 * authenticating with the server.
		 *
		 * @param	sessionID The session ID provided by the server
		 * @param	password The user's password
		 */
		public static function computeDigest( sessionID:String, password:String ):String
		{
			return SHA1.calcSHA1( sessionID + password ).toLowerCase();
		}
	
		/**
		 * Determines whether this is a digest (SHA1) authentication.
		 *
		 * @return It is a digest (true); it is not a digest (false)
		 */
		public function isDigest():Boolean 
		{ 
			return exists(myDigestNode); 
		}
	
		/**
		 * Determines whether this is a plain-text password authentication.
		 *
		 * @return It is plain-text password (true); it is not plain-text 
		 * password (false)
		 */
		public function isPassword():Boolean 
		{ 
			return exists(myPasswordNode); 
		}
	
		/**
		 * The username to use for authentication.
		 */
		public function get username():String 
		{
			if(myUsernameNode && myUsernameNode.firstChild)
				return myUsernameNode.firstChild.nodeValue;
			
			return null; 
		}
	
		/**
		 * @private
		 */
		public function set username(val:String):void 
		{ 
			myUsernameNode = replaceTextNode(getNode(), myUsernameNode, "username", val);
		}
	
		/**
		 * The password to use for authentication.
		 */
		public function get password():String 
		{
			if(myPasswordNode && myPasswordNode.firstChild)
				return myPasswordNode.firstChild.nodeValue;
			
			return null;
		}
	
		/**
		 * @private
		 */
		public function set password(val:String):void
		{
			// Either or for digest or password
			myDigestNode = (myDigestNode==null)?(XMLStanza.XMLFactory.createElement('')):(myDigestNode);
			myDigestNode.removeNode();
			myDigestNode = null;
			//delete myDigestNode;
	
			myPasswordNode = replaceTextNode(getNode(), myPasswordNode, "password", val);
		}
	
		/**
		 * The SHA1 digest to use for authentication.
		 */
		public function get digest():String 
		{
			if(myDigestNode && myDigestNode.firstChild)
				return myDigestNode.firstChild.nodeValue;
			
			return null;
		}
	
		/**
		 * @private
		 */
		public function set digest(val:String):void
		{
			// Either or for digest or password
			myPasswordNode.removeNode();
			myPasswordNode = null;
			//delete myPasswordNode;
	
			myDigestNode = replaceTextNode(getNode(), myDigestNode, "digest", val);
		}
	
		/**
		 * The resource to use for authentication.
		 *
		 * @see	org.igniterealtime.xiff.core.XMPPConnection#resource
		 */
		public function get resource():String
		{
			if(myResourceNode && myResourceNode.firstChild)
				return myResourceNode.firstChild.nodeValue;
			
			return null;
		}
	
		/**
		 * @private
		 */
		public function set resource(val:String):void
		{
			myResourceNode = replaceTextNode(getNode(), myResourceNode, "resource", val);
		}
	
	}
}
