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
	import org.igniterealtime.xiff.data.*;
	
	/**
	 * A message extension for whitboard exchange. This class is the base class
	 * for other extension classes such as Path.
	 *
	 * All child whiteboard objects are contained and serialized by this class
	 *
	 * @see http://xmpp.org/extensions/xep-0113.html
	 */
	public class WhiteboardExtension extends Extension implements IExtension
	{
		public static const ELEMENT_NAME:String = "x";
		public static const NS:String = "xiff:wb";

		
		/**
		 *
		 * @param	parent
		 */
		public function WhiteboardExtension( parent:XML = null )
		{
			super( parent );
		}
	
		/**
		 * Gets the namespace associated with this extension.
		 * The namespace for the WhiteboardExtension is "xiff:wb".
		 *
		 * @return The namespace
		 */
		public function getNS():String
		{
			return WhiteboardExtension.NS;
		}
	
		/**
		 * Gets the element name associated with this extension.
		 * The element for this extension is "x".
		 *
		 * @return The element name
		 */
		public function getElementName():String
		{
			return WhiteboardExtension.ELEMENT_NAME;
                }
		
	    /**
	     * The paths available in this whiteboard message
	     */
	    public function get paths():Array
		{
			var list:Array = [];
			var paths:XMLList = xml.path;
			for each (var p:XML in paths)
			{
				var path:Path = new Path();
				path.xml = p;
				list.push(path);
			}
			return list;
		}
	
	}
}
