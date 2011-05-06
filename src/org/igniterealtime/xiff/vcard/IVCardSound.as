package org.igniterealtime.xiff.vcard
{
	import flash.utils.ByteArray;
	
	public interface IVCardSound
	{
		function get binaryValue():String;
		function set binaryValue( value:String ):void;
		
		function get bytes():ByteArray;
		function set bytes( value:ByteArray ):void;
		
		function get externalValue():String;
		function set externalValue( value:String ):void;
		
		function get phonetic():String;
		function set phonetic( value:String ):void;
	}
}