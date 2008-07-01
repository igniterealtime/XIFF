package org.jivesoftware.xiff.core
{
	public class UnescapedJID extends AbstractJID
	{
		public function UnescapedJID(inJID:String, validate:Boolean=false)
		{
			super(inJID, validate);			
			if(
				node.indexOf("\\40") >= 0 ||
				node.indexOf("\\20") >= 0 ||
				node.indexOf("\\26")>= 0 ||
				node.indexOf("\\3e") >= 0 ||
				node.indexOf("\\3c") >= 0 ||
				node.indexOf("\\5c") >= 0 ||
				node.indexOf('\\3a') >= 0 ||
				node.indexOf("\\2f") >= 0 ||
				node.indexOf("\\22") >= 0 ||
				node.indexOf("\\27") >= 0)
			{
   				_node = unescapedNode;
   			}
		}
		
		public function get escaped():EscapedJID
		{
			return new EscapedJID(toString());
		}
		
		public function equals(testJID:UnescapedJID, shouldTestBareJID:Boolean):Boolean 
    	{
        	if(shouldTestBareJID)
            	return testJID.bareJID == bareJID;
        	else
            	return testJID.toString() == toString();
    	}
	}
}