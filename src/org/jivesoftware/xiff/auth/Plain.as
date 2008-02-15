package org.jivesoftware.xiff.auth
{
	import flash.xml.XMLNode;
	import mx.utils.Base64Encoder;
	
	public class Plain extends SASLAuth
	{
		public function Plain(username:String, password:String, domain:String):void
		{
			var authContent:String = username + "@" + domain;
		    authContent += '\u0000';
		    authContent += username;
		    authContent += '\u0000';
		    authContent += password;
		
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