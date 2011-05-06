package org.igniterealtime.xiff.vcard
{
	public interface IVCardTelephone
	{
		function get cell():String;
		function set cell( value:String ):void;
		
		function get fax():String;
		function set fax( value:String ):void;
		
		function get msg():String;
		function set msg( value:String ):void;
		
		function get pager():String;
		function set pager( value:String ):void;
		
		function get video():String;
		function set video( value:String ):void;
		
		function get voice():String;
		function set voice( value:String ):void;
	}
}