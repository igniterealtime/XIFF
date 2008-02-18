package org.jivesoftware.xiff.auth
{
	import flash.xml.XMLNode;
	
	import mx.utils.Base64Encoder;
	
	import org.jivesoftware.xiff.core.JID;
	import org.jivesoftware.xiff.core.XMPPConnection;
	
	public class Plain extends SASLAuth
	{
		public function Plain(connection:XMPPConnection):void
		{
			var jid:JID = connection.jid;
			var authContent:String = jid.toBareJID();
		    authContent += '\u0000';
		    authContent += jid.node;
		    authContent += '\u0000';
		    authContent += connection.password;
		
			var b64coder:Base64Encoder = new Base64Encoder();
			b64coder.insertNewLines = false;
			b64coder.encode(authContent);
			authContent = b64coder.flush();

		    var attrs:Object = {
		        mechanism: "PLAIN",
		        xmlns: "urn:ietf:params:xml:ns:xmpp-sasl"
		    };
		
		    req = new XMLNode(1, "auth");
		    req.appendChild(new XMLNode(3, authContent));
		    req.attributes = attrs;
		
		    stage = 0;
		}
		
		public override function handleResponse(stage:int, response:XMLNode):Object {
        	var success:Boolean = response.nodeName == "success";
       		return {
        		authComplete: true,
            	authSuccess: success,
           		authStage: stage++
        	};
    	}
	}
}