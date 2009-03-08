/*
 * Copyright 2003-2009
 * Sean Voisen <sean@voisen.org>
 * Sean Treadway <seant@oncotype.dk>
 * Nick Velloff <nick.velloff@gmail.com>
 * Derrick Grigg <dgrigg@rogers.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at 
 *
 *   http://www.apache.org/licenses/LICENSE-2.0 
 * 
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and 
 * limitations under the License. 
 */

package org.jivesoftware.xiff.core
{
  /**
   * This class provides access to a JID (Jabber ID) in escaped form.
   */
  public class EscapedJID extends AbstractJID
  {
    /**
     * Creates a new EscapedJID object.
     *
     * @param inJID The JID in String form.
     * @param validate Will validate the JID string if true. Invalid
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
     * @param testJID The JID with which to test equivalency.
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
