package org.jivesoftware.xiff.core
{
	public class JID
	{
		private	var jidNodeValidator:RegExp = /^([\x29\x23-\x25\x28-\x2E\x30-\x39\x3B\x3D\x3F\x41-\x7E\xA0 \u1680\u202F\u205F\u3000\u2000-\u2009\u200A-\u200B\u06DD \u070F\u180E\u200C-\u200D\u2028-\u2029\u0080-\u009F \u2060-\u2063\u206A-\u206F\uFFF9-\uFFFC\uE000-\uF8FF\uFDD0-\uFDEF \uFFFE-\uFFFF\uD800-\uDFFF\uFFF9-\uFFFD\u2FF0-\u2FFB]{1,1023})/;
		private var jid:String;
		private var bareJID:String;
		
		public function JID(jid:String):void {
    		if(!jidNodeValidator.test(jid) || jid.indexOf(" ") > -1) {
        		trace("Invalid JID: %s", jid);
        		throw "Invalid JID";
    		}
    		this.jid = jid.toLowerCase();
		}
		
    	public function toString():String {
        	return this.jid;
    	}
    	
    	public function toBareJID():String {
        	if (!this.bareJID) {
            	var i:int = this.jid.indexOf("/");
            	if (i < 0) {
                	this.bareJID = this.jid;
            	}
            	else {
                	this.bareJID = this.jid.slice(0, i);
            	}
        	}
        	return this.bareJID;
    	}
    	
    	public function get bareJid():JID {
        	return new JID(this.toBareJID());
    	}
    	
    	public function get resource():String {
        	var i:int = this.jid.indexOf("/");
        	if (i < 0) {
            	return null;
        	}
        	else {
            	return this.jid.slice(i + 1);
        	}
    	}
    	
    	public function get node():String {
        	var i:int = this.jid.indexOf("@");
        	if (i < 0) {
            	return null;
        	}
        	else {
           		return this.jid.slice(0, i);
        	}
    	}
    	
    	public function get domain():String {
        	var i:int = this.jid.indexOf("@");
        	var j:int = this.jid.indexOf("/");
        	if (i < 0) {
            	return null;
        	}
        	else {
            	if (j < 0) {
                	return this.jid.slice(i + 1);
                }
            	else {
                	return this.jid.slice(i + 1, j);
            	}
        	}
    	}
    	
    	public function equals(jid:JID, shouldTestBareJID:Boolean):Boolean {
        	if(shouldTestBareJID) {
            	return jid.toBareJID() == this.toBareJID();
        	}
        	else {
            	return jid.jid == this.jid;
        	}
    	}
	}
}