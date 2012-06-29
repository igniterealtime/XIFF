package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;

	
	/**
	 * 
	 */
	public class DiscoFeature extends XMLStanza implements ISerializable
	{
		public static const ELEMENT_NAME:String = "feature";

		/**
		 * 
		 * @param	parent
		 */
		public function DiscoFeature( parent:XML=null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if( exists( parent ) )
			{
				parent.appendChild( xml );
			}
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
			return xml.attributes[ "var" ];
		}
		public function set varName( value:String ):void
		{
			xml.attributes[ "var" ] = value;
		}

	}
}
