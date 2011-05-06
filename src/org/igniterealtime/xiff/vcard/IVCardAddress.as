package org.igniterealtime.xiff.vcard
{
	public interface IVCardAddress
	{
		function get country():String;
		function set country( value:String ):void;
		
		function get extendedAddress():String;
		function set extendedAddress( value:String ):void;
		
		function get locality():String;
		function set locality( value:String ):void;
		
		function get poBox():String;
		function set poBox( value:String ):void;
		
		function get postalCode():String;
		function set postalCode( value:String ):void;
		
		function get region():String;
		function set region( value:String ):void;
		
		function get street():String;
		function set street( value:String ):void;
	}
}