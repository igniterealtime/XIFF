package org.jivesoftware.xiff.events
{
	import flash.events.*;

	import org.jivesoftware.xiff.vcard.VCard;
		
	public class VCardEvent extends Event
	{
	
		static public const LOADED:String = "vcardLoaded";
		static public const AVATAR_LOADED:String = "vcardAvatarLoaded";
		static public const ERROR:String = "vcardError";
		private var _vcard:VCard;

		public function VCardEvent( type:String, vcard:VCard, bubbles:Boolean, cancelable:Boolean )
		{
			super( type, bubbles, cancelable )
			_vcard = vcard;
		}
		override public function clone():Event
		{
			return new VCardEvent( type, _vcard, bubbles, cancelable );
		}
		override public function toString():String
		{
			return '[VCardEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
		public function get vcard():VCard
		{
			return _vcard;
		}
	}
}
