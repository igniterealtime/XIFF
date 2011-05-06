package org.igniterealtime.xiff.vcard
{
	public interface IVCardName
	{
		function get family():String;
		function set family( value:String ):void;
		
		function get given():String;
		function set given( value:String ):void;
		
		function get middle():String;
		function set middle( value:String ):void;
		
		function get prefix():String;
		function set prefix( value:String ):void;
		
		function get suffix():String;
		function set suffix( value:String ):void;
	}
}