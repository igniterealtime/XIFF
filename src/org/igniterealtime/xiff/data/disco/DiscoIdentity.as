package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	

	public class DiscoIdentity extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "identity";

		public function DiscoIdentity( parent:XML=null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if( parent != null )
			{
				parent.appendChild( xml );
			}
		}

		public function equals( other:DiscoIdentity ):Boolean
		{
			return category == other.category && type == other.type && name == other.name && lang == other.lang;
		}

		public function get category():String
		{
			return xml.@category;
		}

		public function set category( value:String ):void
		{
			xml.@category = value;
		}

		public function get type():String
		{
			return xml.@type;
		}

		public function set type( value:String ):void
		{
			xml.@type = value;
		}

		public function get name():String
		{
			return xml.@name;
		}

		public function set name( value:String ):void
		{
			xml.@name = value;
		}

		public function get lang():String
		{
			return xml.attributes[ "xml:lang" ];
		}

		public function set lang( value:String ):void
		{
			xml.attributes[ "xml:lang" ] = value;
		}

	}
}