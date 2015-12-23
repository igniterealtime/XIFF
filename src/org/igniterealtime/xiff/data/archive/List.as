/**
 * Created by AlexanderSla on 05.11.2014.
 */
package org.igniterealtime.xiff.data.archive {
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.data.Extension;

	/**
	  <xs:element name='list'>
		<xs:complexType>
			<xs:sequence>
				<xs:element ref='chat' minOccurs='0' maxOccurs='unbounded'/>
				<xs:any processContents='lax' namespace='##other' minOccurs='0' maxOccurs='unbounded'/>
			</xs:sequence>
			<xs:attribute name='end' type='xs:dateTime' use='optional'/>
			<xs:attribute name='exactmatch' type='xs:boolean' use='optional'/>
			<xs:attribute name='start' type='xs:dateTime' use='optional'/>
			<xs:attribute name='with' type='xs:string' use='optional'/>
		</xs:complexType>
	</xs:element>
	*/

	public class List extends Extension implements IArchveExtention {

		public static const ELEMENT_NAME:String = "list";

		public static const END:String = "end";
		public static const EXACTMATCH:String = "exactmatch";
		public static const START:String = "start";
		public static const WITH:String = "with";

		public function getNS():String {
			return archive_internal;
		}

		public function getElementName():String {
			return ELEMENT_NAME;
		}
		public function get chats():Vector.<ChatStanza>
		{
			var list:Vector.<ChatStanza> = new Vector.<ChatStanza>();
			for each( var child:XML in xml.children() )
			{
				if ( child.localName() == ChatStanza.ELEMENT_NAME )
				{
					var item:ChatStanza = new ChatStanza();
					item.xml = child;
					list.push( item );
				}
			}
			return list;
		}
		public function set chats( value:Vector.<ChatStanza> ):void
		{
			removeFields(ChatStanza.ELEMENT_NAME);

			if ( value != null )
			{
				var len:uint = value.length;
				for (var i:uint = 0; i < len; ++i)
				{
					var item:ChatStanza = value[i];
					xml.appendChild( item.xml );
				}
			}
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
	}
}
