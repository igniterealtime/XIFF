/*
 * Copyright (C) 2003-2012 Igniterealtime Community Contributors
 *   
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
 *     Michael McCarthy <mikeycmccarthy@gmail.com>
 * 
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.igniterealtime.xiff.data.whiteboard
{
	
	import org.igniterealtime.xiff.data.ISerializable;
	import org.igniterealtime.xiff.data.XMLStanza;
	
	
	/**
	 * A helper class that abstracts the serialization of strokes and
	 * provides an interface to access the properties
	 *
	*/
	public class Stroke implements ISerializable
	{
	
	    private var _xml:XML;
		
		/**
		 * 
		 */
		public function Stroke() 
		{ 
			
		}
	

		/**
		 * The XML node that should be used for this stanza's internal XML representation,
		 * 
		 * <p>Simply by setting this will take care of the required parsing and deserialisation.</p>
		 * 
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/XML.html
		 * @see http://www.w3.org/TR/xml/
		 */
		public function get xml():XML 
		{
			return _xml;
		}
		public function set xml( elem:XML ):void 
		{
			var parent:XML = _xml.parent();
			if (parent != null)
			{
				parent.appendChild(elem);
			}
			
			_xml = elem;
		}
	
	    /**
	     * The value of the RGB color.  This is the same color format used by
	     * MovieClip.lineStyle
		 * 
	     * <p>XML attribute "stroke"</p>
	     */
		public function get color():uint 
		{ 
			// new Number('0x' + _xml.attributes["stroke"].slice(1));
			return 0; 
		}
		public function set color(value:uint):void 
		{
			_xml.attribute["stroke"] = "#" + value.toString(16); 
		}
	
	    /**
	     * The width of the stroke in pixels.  This is in a format used by
	     * MovieClip.lineStyle
		 * 
	     * <p>XML attribute "stroke-width"</p>
	     */
	    public function get width():Number
		{ 
			//new Number(_xml.attributes["stroke-width"]);
			return 1; 
		}
	    public function set width(value:Number):void 
		{
			_xml.attribute["stroke-width"] = value.toString(); 
		}
	
	    /**
	     * The opacity of the stroke, in percent. 100 is solid, 0 is transparent.
	     * This property can be used as the alpha parameter of MovieClip.lineStyle
		 * 
	     * <p>XML attribute "stroke-opacity"</p>
	     */
	    public function get opacity():Number
		{ 
			//new Number(_xml.attributes["stroke-opacity"]);
			return 100; 
		}
	    public function set opacity(value:Number):void 
		{
			_xml.attribute["stroke-opacity"] = value.toString(); 
		}
	}
}