/*
 * License
 */
package org.igniterealtime.xiff.privatedata
{
	import flash.events.EventDispatcher;
	
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.privatedata.PrivateDataExtension;
	import org.igniterealtime.xiff.filter.CallbackPacketFilter;
	import org.igniterealtime.xiff.filter.IPacketFilter;
	import org.igniterealtime.xiff.util.Callback;

	public class PrivateDataManager extends EventDispatcher
	{
		private static var privateDataManagerConstructed:Boolean = privateDataManagerStaticConstructor();
		
		private static function privateDataManagerStaticConstructor():Boolean
		{
			ExtensionClassRegistry.register( PrivateDataExtension );
			return true;
		}
		
		private var _connection:XMPPConnection;
		
		/**
		 * 
		 * @param	connection
		 */
		public function PrivateDataManager(connection:XMPPConnection) 
		{
			_connection = connection;
		}
		
		public function getPrivateData(elementName:String, elementNamespace:String, callback:Callback):void 
		{
			var packetFilter:IPacketFilter = new CallbackPacketFilter(callback);
			var privateDataGet:IQ = new IQ(null, IQ.GET_TYPE, null, "accept", packetFilter);
			privateDataGet.addExtension(new PrivateDataExtension(elementName, elementNamespace));
			
			_connection.send(privateDataGet);
		}
		
		public function setPrivateData(elementName:String, elementNamespace:String, payload:IPrivatePayload):void 
		{
			var privateDataSet:IQ = new IQ(null, IQ.SET_TYPE);
			privateDataSet.addExtension(new PrivateDataExtension(elementName, elementNamespace, payload));
			
			_connection.send(privateDataSet);
		}
	}
}