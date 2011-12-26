package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	import flash.xml.XMLNode;

	public class DiscoItem extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "item";

		public function DiscoItem( parent:XMLNode=null )
		{
			super();

			getNode().nodeName = ELEMENT_NAME;

			if( exists( parent ) )
			{
				parent.appendChild( getNode() );
			}
		}

		public function serialize( parentNode:XMLNode ):Boolean
		{
			var node:XMLNode = getNode();

			if( parentNode != node.parentNode )
			{
				parentNode.appendChild( node.cloneNode( true ) );
			}

			return true;
		}

		public function deserialize( node:XMLNode ):Boolean
		{
			setNode( node );

			return true;
		}

		public function equals( other:DiscoItem ):Boolean
		{
			return jid == other.jid && name == other.name && node == other.node;
		}

		public function get jid():String
		{
			return getNode().attributes.jid;
		}

		public function set jid( value:String ):void
		{
			getNode().attributes.jid = value;
		}

		public function get name():String
		{
			return getNode().attributes.name;
		}

		public function set name( value:String ):void
		{
			getNode().attributes.name = value;
		}

		public function get node():String
		{
			return getNode().attributes.node;
		}

		public function set node( value:String ):void
		{
			getNode().attributes.node = value;
		}

	}
}