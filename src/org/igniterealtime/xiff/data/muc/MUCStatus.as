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
package org.igniterealtime.xiff.data.muc
{
	
	
	import org.igniterealtime.xiff.data.XMLStanza;
	
	public class MUCStatus
	{
		public static const ELEMENT_NAME:String = "status";
		
		private var _parent:XMLStanza;
		
		/**
		 * Please note that the xmlNode is not used.
		 * @param	xmlNode
		 * @param	parentStanza
		 */
		public function MUCStatus(xmlNode:XML, parentStanza:XMLStanza)
		{
			super();
			
			var elem:XML = <{ ELEMENT_NAME }/>;
			
			_parent = parentStanza;
		}

		/**
		 * Property used to add or retrieve a status code describing the condition that occurs.
		 */
		public function get code():Number
		{
			return _parent.xml.status.@code as Number;
		}
		
		public function set code(value:Number):void
		{
			_parent.xml.status.@code = value.toString();
		}
		
		/**
		 * Property that contains some text with a description of a condition.
		 */
		public function get message():String
		{
			return _parent.xml.status.toString();
		}
	
		public function set message(value:String):void
		{
			_parent.xml.status = value;
			if ( value == null )
			{
				delete _parent.xml.status;
			}
		}
	}
}
