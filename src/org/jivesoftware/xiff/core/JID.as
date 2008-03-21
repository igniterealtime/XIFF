package org.jivesoftware.xiff.core
{
	public class JID
	{
		//TODO: this doesn't actually validate properly in some cases; need separate nodePrep, etc...
		private	var jidNodeValidator:RegExp = /^([\x29\x23-\x25\x28-\x2E\x30-\x39\x3B\x3D\x3F\x41-\x7E\xA0 \u1680\u202F\u205F\u3000\u2000-\u2009\u200A-\u200B\u06DD \u070F\u180E\u200C-\u200D\u2028-\u2029\u0080-\u009F \u2060-\u2063\u206A-\u206F\uFFF9-\uFFFC\uE000-\uF8FF\uFDD0-\uFDEF \uFFFE-\uFFFF\uD800-\uDFFF\uFFF9-\uFFFD\u2FF0-\u2FFB]{1,1023})/;
		private var jid:String;
		private var bareJID:String;
		
		public function JID(inJID:String, validate:Boolean=false):void {
			if(validate)
			{
    			if(!jidNodeValidator.test(inJID) || inJID.indexOf(" ") > -1) 
    			{
        			trace("Invalid JID: %s", inJID);
        			throw "Invalid JID";
    			}
   			}
    		jid = inJID ? inJID : "";
		}
		
    	public function toString():String {
        	return jid;
    	}
    	
    	public function toBareJID():String 
    	{
        	if (!bareJID) 
        	{
            	var i:int = jid.indexOf("/");
            	if (i < 0)
                	bareJID = jid;
            	else
                	bareJID = jid.slice(0, i);
        	}
        	return bareJID;
    	}
    	
    	public function get bareJid():JID {
        	return new JID(this.toBareJID());
    	}
    	
    	public function get resource():String 
    	{
        	var i:int = this.jid.indexOf("/");
        	if (i < 0)
            	return null;
        	else
            	return jid.slice(i + 1);
    	}
    	
    	public function get node():String 
    	{
        	var i:int = jid.indexOf("@");
        	if (i < 0)
            	return null;
        	else 
           		return jid.slice(0, i);
    	}
    	
    	public function get domain():String 
    	{
        	var i:int = jid.indexOf("@");
        	var j:int = jid.indexOf("/");
        	if (i < 0)
            	i = -1;
        	
            if (j < 0)
                return jid.slice(i + 1);
            else
                return jid.slice(i + 1, j);
    	}
    	
    	public function equals(testJID:JID, shouldTestBareJID:Boolean):Boolean 
    	{
        	if(shouldTestBareJID)
            	return testJID.toBareJID() == toBareJID();
        	else
            	return testJID.jid == jid;
    	}
	}
}