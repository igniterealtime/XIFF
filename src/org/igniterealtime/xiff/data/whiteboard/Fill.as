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
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;


	/**
	 * A helper class that abstracts the serialization of fills and
	 * provides an interface to access the properties providing defaults
	 * if no properties were defined in the XML.
	 *
	 */
	public class Fill extends XMLStanza implements INodeProxy
	{
		// TODO: Not checked via any spec
		public static const ELEMENT_NAME:String = "fill";

		/**
		 *
		 * @param	color
		 * @param	opacity
		 */
		public function Fill( color:uint = 0, opacity:Number = 100 )
		{
			xml.setLocalName( Fill.ELEMENT_NAME );

			this.color = color;
			this.opacity = opacity;
		}

		/**
		 * The value of the RGB color.  This is the same color format used by
		 * MovieClip.lineStyle
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Graphics.html
		 */
		public function get color():uint
		{
			var value:String = getAttribute("fill");
			if ( value != null )
			{
				return parseInt("0x" + value.slice(1), 16);
			}
			return null;
		}
		public function set color(value:uint):void
		{
			if (isNaN(value))
			{
				setAttribute("fill", null);
			}
			else
			{
				setAttribute("fill", "#" + value.toString(16));
			}
		}

		/**
		 * The opacity of the fill, in percent. 100 is solid, 0 is transparent.
		 * This property can be used as the alpha parameter of MovieClip.lineStyle
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Graphics.html
		 */
		public function get opacity():Number
		{
			var value:String = getAttribute("fill-opacity");
			if ( value != null )
			{
				return parseFloat(value);
			}
			return NaN;
		}
		public function set opacity(value:Number):void
		{
			if (isNaN(value))
			{
				setAttribute("fill-opacity", null);
			}
			else
			{
				setAttribute("fill-opacity", value.toString());
			}
		}
	}
}
