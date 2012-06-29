package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	
	/**
	 * 
	 */
	public class DiscoItem extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "item";

		/**
		 * 
		 * @param	parent
		 */
		public function DiscoItem( parent:XML=null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if( exists( parent ) )
			{
				parent.appendChild( xml );
			}
		}

		public function equals( other:DiscoItem ):Boolean
		{
			return jid == other.jid && name == other.name && node == other.node;
		}

		/**
		 * 
		 */
		public function get jid():String
		{
			return xml.@jid;
		}
		public function set jid( value:String ):void
		{
			xml.@jid = value;
		}

		/**
		 * 
		 */
		public function get name():String
		{
			return xml.@name;
		}
		public function set name( value:String ):void
		{
			xml.@name = value;
		}

		/**
		 * 
		 */
		public function get node():String
		{
			return xml.@node;
		}
		public function set node( value:String ):void
		{
			xml.@node = value;
		}

	}
}