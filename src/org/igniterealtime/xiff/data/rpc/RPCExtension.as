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
package org.igniterealtime.xiff.data.rpc
{

	import org.igniterealtime.xiff.data.*;
	
	/**
	 * Implements XEP-0009 for XML-RPC over XMPP.
	 *
	 * <p>The protocol supports all syntax and semantics of XML-RPC except
	 * that it uses XMPP instead of HTTP as the underlying transport.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0009.html
	 */
	public class RPCExtension extends Extension implements IExtension
	{
		public static const NS:String = "jabber:iq:rpc";
		public static const ELEMENT_NAME:String = "query";

	
		private var _result:Array;
		private var _fault:Object;
		
		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function RPCExtension( parent:XML = null )
		{
			super(parent);
		}
		
		/**
		 * Place the remote call.  This method serializes the remote procedure call to XML.
		 * The call will be made on the remote machine when the stanza containing this extension is sent to the server.
		 *
		 * If this extension is being returned, then check the result property instead.
		 *
		 * @param	methodName The name of the remote procedure to call
		 * @param	params	A collection of parameters of any type
		 * @see	#result
		 */
		public function call(methodName:String, params:Array):void
		{
			XMLRPC.toXML(xml, methodName, params);
		}
	
		/**
		 * Interface method, returning the namespace for this extension
		 *
		 * @see	org.igniterealtime.xiff.data.IExtension
		 */
		public function getNS():String
		{
			return RPCExtension.NS;
		}
	
		/**
		 * Interface method, returning the namespace for this extension
		 *
		 * @see	org.igniterealtime.xiff.data.IExtension
		 */
		public function getElementName():String
		{
			return RPCExtension.ELEMENT_NAME;
        }
	
		/**
		 * Interface method, returning the namespace for this extension
		 *
		 * @see	org.igniterealtime.xiff.data.INodeProxy
		 */
		override public function set xml( node:XML ):void
		{
			super.xml = node;
	
			var res:Array = XMLRPC.fromXML(node);
			if (res.isFault)
			{
				_fault = res;
			}
			else
			{
				_result = res[0];
			}
	
		}
	
		/**
		 * The result of this remote procedure call.  It can contain elements of any type.
		 *
		 * @return Array of demarshalled results from the remote procedure
		 */
		public function get result():Array
		{
			return _result;
		}
	
		/**
		 * Check this if property if you wish to determine the remote procedure call produced an error.
		 * If the XMPP stanza never made it to the RPC service, then the error would be on the
		 * stanza object instead of this extension.
		 *
		 * @return True if the remote procedure call produced an error
		 */
		public function get isFault():Boolean
		{
			return _fault.isFault;
		}
	
		/**
		 * The object containing the fault of the remote procedure call.
		 * This object could have any properties, as fault results are only structurally defined.
		 *
		 */
		public function get fault():Object
		{
			return _fault;
		}
	
		/**
		 * A common result from most RPC servers to describe a fault
		 *
		 */
		public function get faultCode():Number
		{
			return _fault.faultCode;
		}
	
		/**
		 * A common result from most RPC servers to describe a fault
		 *
		 */
		public function get faultString():String
		{
			return _fault.faultString;
		}
	}
}
