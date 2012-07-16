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
package org.igniterealtime.xiff.data
{
	import org.igniterealtime.xiff.core.EscapedJID;
	
	/**
	 * Interface for base XMPP stanza
	 */
	public interface IXMPPStanza extends IXMLStanza, IExtendable
	{
		function get to():EscapedJID;
		function set to( value:EscapedJID ):void;
		
		function get from():EscapedJID;
		function set from( value:EscapedJID ):void;
		
		function get type():String;
		function set type( value:String ):void;
		
		function get id():String;
		function set id( value:String ):void;
		
		function get errorMessage():String;
		function set errorMessage( value:String ):void;
		
		function get errorCondition():String;
		function set errorCondition( value:String ):void;
		
		function get errorType():String;
		function set errorType( value:String ):void;
		
		function get errorCode():int;
		function set errorCode( value:int ):void;
	}
}
