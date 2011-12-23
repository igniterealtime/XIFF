package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	import flash.xml.XMLNode;

	public class DiscoFeature extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "feature";

		public function DiscoFeature( parent:XMLNode=null )
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

		public function equals( other:DiscoFeature ):Boolean
		{
			return varName == other.varName;
		}

		/**
		 * The var of this feature used by the application or server.
		 *
		 * Note: This serializes to the <code>var</code> attribute on the feature node.
		 * Since <code>var</code> is a reserved word in ActionScript,
		 * this feature uses <code>varName</code> to describe the var of this feature.
		 *
		 */
		public function get varName():String
		{
			return getNode().attributes[ "var" ];
		}

		public function set varName( value:String ):void
		{
			getNode().attributes[ "var" ] = value;
		}

	}
}
