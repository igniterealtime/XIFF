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

			if( parent != null )
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
			return getAttribute("jid");
		}
		public function set jid( value:String ):void
		{
			setAttribute("jid", value);
		}

		/**
		 *
		 */
		public function get name():String
		{
			return getAttribute("name");
		}
		public function set name( value:String ):void
		{
			setAttribute("name", value);
		}

		/**
		 *
		 */
		public function get node():String
		{
			return getAttribute("node");
		}
		public function set node( value:String ):void
		{
			setAttribute("node", value);
		}

	}
}
