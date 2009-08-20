/*
 * License
 */
package org.igniterealtime.xiff.data.im
{
	import org.igniterealtime.xiff.core.UnescapedJID;
	
	public interface Contact
	{
		function get jid():UnescapedJID;
		function set jid(value:UnescapedJID):void;
		
		function get displayName():String;
		function set displayName(value:String):void;
		
		function get show():String;
		function set show(value:String):void;
		
		function get online():Boolean;
		function set online(value:Boolean):void;
	}
}
