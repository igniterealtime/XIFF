package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	import flash.xml.XMLNode;

	public class DiscoIdentity extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "identity";

		public function DiscoIdentity( parent:XMLNode=null )
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

			if( !exists( node.parentNode ) )
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

		public function equals( other:DiscoIdentity ):Boolean
		{
			return category == other.category && type == other.type && name == other.name && lang == other.lang;
		}

		public function get category():String
		{
			return getNode().attributes.category;
		}

		public function set category( value:String ):void
		{
			getNode().attributes.category = value;
		}

		public function get type():String
		{
			return getNode().attributes.type;
		}

		public function set type( value:String ):void
		{
			getNode().attributes.type = value;
		}

		public function get name():String
		{
			return getNode().attributes.name;
		}

		public function set name( value:String ):void
		{
			getNode().attributes.name = value;
		}

		public function get lang():String
		{
			return getNode().attributes[ "xml:lang" ];
		}

		public function set lang( value:String ):void
		{
			getNode().attributes[ "xml:lang" ] = value;
		}

	}
}