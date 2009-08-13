/*
 * License
 */
package org.igniterealtime.xiff.core
{
	/**
	 * This class provides access to a JID (Jabber ID) in unescaped form.
	 */
	public class UnescapedJID extends AbstractJID
	{
		/**
		 * Creates a new UnescapedJID object.
		 *
		 * @param	inJID The JID in String form.
		 * @param	validate Will validate the JID string if true. Invalid
		 * JIDs will throw an error.
		 */
		public function UnescapedJID(inJID:String, validate:Boolean=false)
		{
			super(inJID, validate);			

			if(node) {
				_node = unescapedNode(node);
			}
		}

		/**
		 * The unescaped JID in escaped form.
		 */
		public function get escaped():EscapedJID
		{
			return new EscapedJID(toString());
		}

		/**
		 * Determines if two unescaped JIDs are equivalent.
		 *
		 * @param	testJID The JID with which to test equivalency.
		 *
		 * @return True if the JIDs are equivalent.
		 */
		public function equals(testJID:UnescapedJID, shouldTestBareJID:Boolean):Boolean 
		{
			if(shouldTestBareJID)
				return testJID.bareJID == bareJID;
			else
				return testJID.toString() == toString();
		}
	}
}
