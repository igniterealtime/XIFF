/*
 * License
 */
package org.igniterealtime.xiff.core
{
  /**
   * This class provides access to a JID (Jabber ID) in escaped form.
   * @see http://xmpp.org/extensions/xep-0106.html
   */
  public class EscapedJID extends AbstractJID
  {
    /**
     * Creates a new EscapedJID object.
     *
     * @param	inJID The JID in String form.
     * @param	validate Will validate the JID string if true. Invalid
     * JIDs will throw an error.
     */
    public function EscapedJID(inJID:String, validate:Boolean=false)
    {
      super(inJID, validate);

      if(node) {
        _node = escapedNode(node);
      }
    }

    /**
     * The escaped JID in unescaped form.
     */
    public function get unescaped():UnescapedJID
    {
      return new UnescapedJID(toString());
    }

    /**
     * Determines if two escaped JIDs are equivalent.
     *
     * @param	testJID The JID with which to test equivalency.
     *
     * @return True if the JIDs are equivalent.
     */
    public function equals(testJID:EscapedJID, shouldTestBareJID:Boolean):Boolean 
    {
      if(shouldTestBareJID)
        return testJID.bareJID == bareJID;
      else
        return testJID.toString() == toString();
    }
  }
}
