/*
 * License
 */
package org.igniterealtime.xiff.bookmark
{
	import flash.xml.XMLNode;

	import org.igniterealtime.xiff.data.ISerializable;

	public class UrlBookmark implements ISerializable
	{
		private var _node:XMLNode;

		/**
		 *
		 * @param	name
		 * @param	url
		 */
		public function UrlBookmark( name:String = null, url:String = null )
		{
			if ( !name && !url )
			{
				return;
			}
			else if ( !name || !url )
			{
				throw new Error( "Name and url cannot be null, they must either both be null or an Object" );
			}

			_node = new XMLNode( 1, "url" );
			_node.attributes.name = name;
			_node.attributes.url = url;
		}

		public function deserialize( node:XMLNode ):Boolean
		{
			_node = node.cloneNode( true );
			return true;
		}

		public function get name():String
		{
			return _node.attributes.name;
		}

		public function serialize( parentNode:XMLNode ):Boolean
		{
			parentNode.appendChild( _node.cloneNode( true ));
			return true;
		}

		public function get url():String
		{
			return _node.attributes.uri;
		}
	}
}
