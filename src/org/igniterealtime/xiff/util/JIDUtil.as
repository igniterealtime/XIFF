/**
 * Created by kvint on 27.11.14.
 */
package org.igniterealtime.xiff.util {
	import org.igniterealtime.xiff.core.AbstractJID;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;

	public class JIDUtil {

		public static function createJID(name:String, domain:String = null):UnescapedJID {
			var needToAddDomain:Boolean = name.indexOf("@") == -1 && domain != null;
			name += needToAddDomain ? "@" + domain : "";
			return new UnescapedJID(name);
		}

		public static function unescape(jid:AbstractJID):UnescapedJID {
			var unescapedJID:UnescapedJID;
			if(jid is UnescapedJID){
				unescapedJID = jid as UnescapedJID;
			}else if(jid is EscapedJID){
				unescapedJID = (jid as EscapedJID).unescaped;
			}
			return unescapedJID;
		}
		public static function escape(jid:AbstractJID):EscapedJID {
			var escapedJID:EscapedJID;
			if(jid is UnescapedJID){
				escapedJID = (jid as UnescapedJID).escaped;
			}else if(jid is EscapedJID){
				escapedJID = jid as EscapedJID;
			}
			return escapedJID;
		}
	}
}
