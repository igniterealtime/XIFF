/**
 * Created by kvint on 06.11.14.
 */
package org.igniterealtime.xiff.data.archive {
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;

	/**
	 <xs:element name='chat'>
		 <xs:complexType>
			 <xs:choice minOccurs='0' maxOccurs='unbounded'>
				 <xs:element name='from' type='messageType'/>
				 <xs:element name='next' type='linkType'/>
				 <xs:element ref='note'/>
				 <xs:element name='previous' type='linkType'/>
				 <xs:element name='to' type='messageType'/>
				 <xs:any processContents='lax' namespace='##other'/>
		 	 </xs:choice>
			 <xs:attribute name='start' type='xs:dateTime' use='required'/>
			 <xs:attribute name='subject' type='xs:string' use='optional'/>
			 <xs:attribute name='thread' use='optional' type='xs:string'/>
			 <xs:attribute name='version' use='optional' type='xs:nonNegativeInteger'/>
			 <xs:attribute name='with' type='xs:string' use='required'/>
		 </xs:complexType>
	 </xs:element>
	 */
	public class ChatStanza extends Extension implements IArchveExtention {

		public static const ELEMENT_NAME:String = "chat";

		public static const START:String = "start";
		public static const SUBJECT:String = "subject";
		public static const THREAD:String = "thread";
		public static const WITH:String = "with";

		public function ChatStanza(parent:XML = null) {
			super(parent);
		}
		public function get start():String {
			return getAttribute(START);
		}
		public function set start(value:String):void {
			setAttribute(START, value);
		}
		public function get thread():String {
			return getAttribute(THREAD);
		}
		public function set thread(value:String):void {
			setAttribute(THREAD, value);
		}
		public function get withJID():EscapedJID {
			var value:String = getAttribute(WITH);
			if ( value != null )
			{
				return new EscapedJID(value);
			}
			return null;
		}

		public function set withJID(value:EscapedJID):void {
			setAttribute(WITH, value.toString());
		}

		override public function set xml(elem:XML):void {
			super.xml = elem;
		}

		public function getElementName():String {
			return ELEMENT_NAME;
		}

		public function getNS():String {
			return archive_internal;
		}
	}
}
