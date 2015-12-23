/**
 * Created by kvint on 06.11.14.
 */
package org.igniterealtime.xiff.data.archive {
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;


	/**
	 *
	 <xs:element name='retrieve'>
		 <xs:complexType>
			 <xs:sequence>
			 	<xs:any processContents='lax' namespace='##other' minOccurs='0' maxOccurs='unbounded'/>
			 </xs:sequence>
		 	 <xs:attribute name='start' type='xs:dateTime' use='required'/>
			 <xs:attribute name='with' type='xs:string' use='required'/>
		 </xs:complexType>
	 </xs:element>

	 */
	public class Retrieve extends Extension implements IArchveExtention {

		public static const ELEMENT_NAME:String = "retrieve";

		public static const START:String = "start";
		public static const WITH:String = "with";

		public function Retrieve(parent:XML = null) {
			super(parent);
		}
		public function get start():String {
			return getAttribute(START);
		}
		public function set start(value:String):void {
			setAttribute(START, value);
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

		public function getElementName():String {
			return ELEMENT_NAME;
		}

		public function getNS():String {
			return archive_internal;
		}
	}
}
