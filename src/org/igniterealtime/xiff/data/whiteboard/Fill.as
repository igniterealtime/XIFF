/*
 * License
 */
package org.igniterealtime.xiff.data.whiteboard
{

	
	import org.igniterealtime.xiff.data.ISerializable;
	import flash.xml.XMLNode;
	
	/**
	 * A helper class that abstracts the serialization of fills and
	 * provides an interface to access the properties providing defaults
	 * if no properties were defined in the XML.
	 *
	*/
	public class Fill implements ISerializable
	{
	    private var myColor:Number;
	    private var myOpacity:Number;
	
	    public function Fill() { }
	
		/**
		 * Serializes the Fill into the parent node.  Because the fill
	     * serializes into the attributes of the XML node, it will directly modify
	     * the parent node passed.
		 *
		 * @param	parent The parent node that this extension should be serialized into
		 * @return An indicator as to whether serialization was successful
		 */
		public function serialize( parent:XMLNode ):Boolean
		{
	        if (myColor) { parent.attributes['fill'] = "#" + myColor.toString(16); }
	        if (myOpacity) { parent.attributes['fill-opacity'] = myOpacity.toString(); }
	
	        return true;
	    }
	
		/**
		 * Extracts the known fill attributes from the node
		 *
		 * @param	parent The parent node that this extension should be serialized into
		 * @return An indicator as to whether serialization was successful
		 */
		public function deserialize( node:XMLNode ):Boolean
		{
	        if (node.attributes['fill']) {
	            myColor = new Number('0x' + node.attributes['fill'].slice(1));
	        }
	        if (node.attributes['fill-opacity']) {
	            myOpacity = new Number(node.attributes['fill-opacity']);
	        }
	
	        return true;
	    }
	
	    /**
	     * The value of the RGB color.  This is the same color format used by
	     * MovieClip.lineStyle
	     *
	     */
		public function get color():Number 
		{
			return myColor ? myColor : 0; 
		}
		public function set color(c:Number):void
		{
			//myColor = Number(c.valueOf());
			myColor = c;
		}
	
	    /**
	     * The opacity of the fill, in percent. 100 is solid, 0 is transparent.
	     * This property can be used as the alpha parameter of MovieClip.lineStyle
	     *
	     */
	    public function get opacity():Number { return myOpacity ? myOpacity : 100; }
	    public function set opacity(v:Number):void 
		{ myOpacity = v; }
	}
}