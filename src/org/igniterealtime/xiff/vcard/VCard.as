/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
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
package org.igniterealtime.xiff.vcard
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	import mx.utils.Base64Decoder;

	//import com.hurlant.util.Base64;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.XMPPStanza;
	import org.igniterealtime.xiff.data.im.RosterItemVO;
	import org.igniterealtime.xiff.data.vcard.VCardExtension;
	import org.igniterealtime.xiff.events.VCardEvent;

	/**
	 * @eventType org.igniterealtime.xiff.events.VCardEvent.AVATAR_LOADED
	 */
	[Event(name="vcardAvatarLoaded", type="org.igniterealtime.xiff.events.VCardEvent")]

	/**
	 * @eventType org.igniterealtime.xiff.events.VCardEvent.LOADED
	 */
	[Event(name="vcardLoaded", type="org.igniterealtime.xiff.events.VCardEvent")]

	/**
	 * @eventType org.igniterealtime.xiff.events.VCardEvent.ERROR
	 */
	[Event(name="vcardError", type="org.igniterealtime.xiff.events.VCardEvent")]
	
	/**
	 * @see http://tools.ietf.org/html/rfc2426
	 */
	public class VCard extends EventDispatcher
	{
		/**
		 *
		 * @default
		 */
		private static var cache:Object = {};

		/**
		 * Flush the vcard cache every 6 hours
		 * @default
		 */
		private static var cacheFlushTimer:Timer = new Timer( 6 * 60 * 60 * 1000, 0 );

		/**
		 *
		 * @default
		 */
		private static var requestQueue:Array = [];

		/**
		 *
		 * @default
		 */
		private static var requestTimer:Timer;

		/**
		 *
		 * @default
		 */
		public var birthDay:Date;

		/**
		 *
		 * @default
		 */
		public var company:String;

		/**
		 *
		 * @default
		 */
		public var department:String;

		/**
		 *
		 * @default
		 */
		public var email:String;

		/**
		 *
		 * @default
		 */
		public var firstName:String;

		/**
		 *
		 * @default
		 */
		public var fullName:String;

		/**
		 *
		 * @default
		 */
		public var gender:String;

		/**
		 *
		 * @default
		 */
		public var homeAddress:String;

		/**
		 *
		 * @default
		 */
		public var homeCellNumber:String;

		/**
		 *
		 * @default
		 */
		public var homeCity:String;

		/**
		 *
		 * @default
		 */
		public var homeCountry:String;

		/**
		 *
		 * @default
		 */
		public var homeFaxNumber:String;

		/**
		 *
		 * @default
		 */
		public var homePagerNumber:String;

		/**
		 *
		 * @default
		 */
		public var homePostalCode:String;

		/**
		 *
		 * @default
		 */
		public var homeStateProvince:String;

		/**
		 *
		 * @default
		 */
		public var homeVoiceNumber:String;

		/**
		 *
		 * @default
		 */
		public var jid:UnescapedJID;

		/**
		 *
		 * @default
		 */
		public var lastName:String;

		/**
		 *
		 * @default
		 */
		public var loaded:Boolean = false;

		/**
		 *
		 * @default
		 */
		public var maritalStatus:String;

		/**
		 *
		 * @default
		 */
		public var middleName:String;

		/**
		 *
		 * @default
		 */
		public var namePrefix:String;

		/**
		 *
		 * @default
		 */
		public var nameSuffix:String;

		/**
		 *
		 * @default
		 */
		public var nickname:String;

		/**
		 *
		 * @default
		 */
		public var otherName:String;

		/**
		 *
		 * @default
		 */
		public var title:String;

		/**
		 *
		 * @default
		 */
		public var url:String;

		/**
		 * Version of the VCard. Usually 2.0 or 3.0.
		 */
		public var version:Number;

		/**
		 *
		 * @default
		 */
		public var workAddress:String;

		/**
		 *
		 * @default
		 */
		public var workCellNumber:String;

		/**
		 *
		 * @default
		 */
		public var workCity:String;

		/**
		 *
		 * @default
		 */
		public var workCountry:String;

		/**
		 *
		 * @default
		 */
		public var workFaxNumber:String;

		/**
		 *
		 * @default
		 */
		public var workPagerNumber:String;

		/**
		 *
		 * @default
		 */
		public var workPostalCode:String;

		/**
		 *
		 * @default
		 */
		public var workStateProvince:String;

		/**
		 *
		 * @default
		 */
		public var workVoiceNumber:String;

		/**
		 *
		 * @default
		 */
		private var _avatar:DisplayObject;

		/**
		 *
		 * @default
		 */
		private var _imageBytes:ByteArray;

		/**
		 *
		 * @default
		 */
		private var contact:RosterItemVO;

		/**
		 * Don't call directly VCard, use a static method and add a callback.
		 */
		public function VCard()
		{

		}

		/**
		 * Seems to be the way a vcard is requested and then later referred to:
		 * <code>var vCard:VCard = VCard.getVCard(_connection, item);<br />
		 * vCard.addEventListener(VCardEvent.LOADED, onVCard);</code>
		 * @param con
		 * @param user
		 * @return Reference to the VCard which will be filled once the loaded event occurs.
		 */
		public static function getVCard( con:XMPPConnection, user:RosterItemVO ):VCard
		{
			if ( !cacheFlushTimer.running )
			{
				cacheFlushTimer.start();
				cacheFlushTimer.addEventListener( TimerEvent.TIMER, function( event:TimerEvent ):void
					{
						var tempCache:Object = cache;
						cache = {};
						for each ( var cachedCard:VCard in tempCache )
						{
							pushRequest( con, vcard );
						}
					} );
			}

			var jidString:String = user.jid.toString();

			var cachedCard:VCard = cache[ jidString ];
			if ( cachedCard )
				return cachedCard;

			var vcard:VCard = new VCard();
			vcard.contact = user;
			cache[ jidString ] = vcard;

			pushRequest( con, vcard );

			return vcard;
		}

		/**
		 * Add the request to the stack of requests
		 * @param con
		 * @param vcard
		 */
		private static function pushRequest( con:XMPPConnection, vcard:VCard ):void
		{
			if ( !requestTimer )
			{
				requestTimer = new Timer( 1, 1 );
				requestTimer.addEventListener( TimerEvent.TIMER_COMPLETE, sendRequest );
			}
			requestQueue.push( { connection: con, card: vcard } );
			requestTimer.reset();
			requestTimer.start();
		}

		/**
		 * Send a request
		 * @param event
		 */
		private static function sendRequest( event:TimerEvent ):void
		{
			if ( requestQueue.length == 0 )
				return;
			var req:Object = requestQueue.pop();
			var con:XMPPConnection = req.connection;
			var vcard:VCard = req.card;
			var user:RosterItemVO = vcard.contact;

			var iq:IQ = new IQ( user.jid.escaped, IQ.TYPE_GET );
			vcard.jid = user.jid;

			iq.callbackName = "handleVCard";
			iq.callbackScope = vcard;
			iq.addExtension( new VCardExtension() );

			con.send( iq );
			requestTimer.reset();
			requestTimer.start();
		}

		/**
		 *
		 * @param resultIQ
		 */
		public function _vCardSent( resultIQ:IQ ):void
		{
			if ( resultIQ.type == IQ.TYPE_ERROR )
			{
				dispatchEvent( new VCardEvent( VCardEvent.ERROR, cache[ resultIQ.to.unescaped.toString() ],
											   true, true ) );
			}
			else
			{
				delete cache[ resultIQ.to.unescaped.toString() ]; // Force profile refresh on next view
			}
		}

		/**
		 * Get the byte array to be used with a Loader.loadBytes or similar.
		 * @return Avatar bytes if any
		 */
		public function get avatar():ByteArray
		{
			return _imageBytes;
		}

		/**
		 * Deserializes the incoming IQ to fill the values of this vcard.
		 * @param iq
		 */
		public function handleVCard( iq:IQ ):void
		{
			namespace ns = "vcard-temp";
			use namespace ns;
			
			var node:XML = XML(iq.getNode());
			var vCardNode:XML = node.children()[ 0 ];

			//var vCardNode:XML = iq.node.children()[ 0 ];
			if ( !vCardNode )
				return;

			version = Number( vCardNode.@version );

			var nodes:XMLList = vCardNode.children();

			for each ( var child:XML in nodes )
			{
				switch ( child.localName() )
				{
					case "PHOTO":
						for each ( var photo:XML in child.children() )
						{
							var value:String = photo.text();

							if (photo.localName() == "BINVAL" && value.length > 0 )
							{
								var decoder:Base64Decoder = new Base64Decoder();
								decoder.decode( value );
								_imageBytes = decoder.flush();

								//_imageBytes = Base64.decodeToByteArray( value );
								dispatchEvent( new VCardEvent( VCardEvent.AVATAR_LOADED,
															   this, true, false ) );
							}
						}
						break;

					case "N":
						firstName = child.GIVEN;
						middleName = child.MIDDLE;
						lastName = child.FAMILY;
						otherName = child.OTHER;
						namePrefix = child.PREFIX;
						nameSuffix = child.SUFFIX;
						break;

					case "FN":
						fullName = child.text();
						break;

					case "NICKNAME":
						nickname = child.text();
						break;

					case "EMAIL":
						for each ( var emailChild:XML in child.children() )
						{
							if ( emailChild.localName() == "USERID" )
							{
								email = emailChild.children()[ 0 ];
							}
						}
						break;

					case "ORG":
						company = child.ORGNAME;
						department = child.ORGUNIT;
						break;

					case "TITLE":
						title = child.text();
						break;

					case "URL":
						url = child.text();
						break;

					case "ADR":
						if ( child.WORK.length() == 1 )
						{
							workPostalCode = child.PCODE;
							workStateProvince = child.REGION;
							workAddress = child.STREET;
							workCountry = child.CTRY;
							workCity = child.LOCALITY;
						}
						else if ( child.WORK.length() == 1 )
						{
							homePostalCode = child.PCODE;
							homeStateProvince = child.REGION;
							homeAddress = child.STREET;
							homeCountry = child.CTRY;
							homeCity = child.LOCALITY;
						}
						break;

					case "TEL":
						if ( child.WORK.length() == 1 )
						{
							if ( child.VOICE.length() == 1 )
								workVoiceNumber = child.NUMBER;
							else if ( child.FAX.length() == 1 )
								workFaxNumber = child.NUMBER;
							else if ( child.PAGER.length() == 1 )
								workPagerNumber = child.NUMBER;
							else if ( child.CELL.length() == 1 )
								workCellNumber = child.NUMBER;
						}
						else if ( child.HOME.length() == 1 )
						{
							if ( child.VOICE.length() == 1 )
								homeVoiceNumber = child.NUMBER;
							else if ( child.FAX.length() == 1 )
								homeFaxNumber = child.NUMBER;
							else if ( child.PAGER.length() == 1 )
								homePagerNumber = child.NUMBER;
							else if ( child.CELL.length() == 1 )
								homeCellNumber = child.NUMBER;
						}
						break;

					case "DESC":
						break;

					case "GENDER":
						gender = child.text();
						break;

					case "BDAY":
						var bday:String = child.children()[ 0 ];
						if ( bday != null && bday.length > 8 )
						{
							var dateParts:Array = bday.split( "-" );
							birthDay = new Date( dateParts[ 0 ], int( dateParts[ 1 ] ) -
												 1, dateParts[ 2 ] );
						}
						break;

					case "JABBERID":
						var jabberid:String = child.text();
						if ( jabberid != null && jabberid.length > 0 )
						{
							jid = new UnescapedJID( jabberid );
						}
						break;

					case "ROLE":
						break;

					case "HOMECELL":
						break;

					case "WORKCELL":
						break;

					case "LOCATION":
						break;

					case "MARITALSTATUS":
						maritalStatus = child.text();
						break;

					case "AGE":
						break;

					default:
						trace( "handleVCard. unhandled case child.name(): " + child.name() );
						break;
				}
			}

			loaded = true;
			dispatchEvent( new VCardEvent( VCardEvent.LOADED, this, true, false ) );
		}

		/**
		 *
		 * @param con
		 * @param user
		 */
		public function saveVCard( con:XMPPConnection, user:RosterItemVO ):void
		{
			var iq:IQ = new IQ( null, IQ.TYPE_SET, XMPPStanza.generateID( "save_vcard_" ),
								null, this, _vCardSent );
			var vcardExt:VCardExtension = new VCardExtension();
			var vcardExtNode:XML = vcardExt.getNode() as XML;
			//var vcardExtNode:XML = vcardExt.node;

			if ( firstName || middleName || lastName )
			{
				var nameNode:XML = <N/>;
				if ( firstName )
				{
					nameNode.GIVEN = firstName;
				}

				if ( middleName )
				{
					nameNode.MIDDLE = middleName;
				}

				if ( lastName )
				{
					nameNode.FAMILY = lastName;
				}

				if ( otherName )
				{
					nameNode.OTHER = otherName;
				}

				if ( namePrefix )
				{
					nameNode.PREFIX = namePrefix;
				}

				if ( nameSuffix )
				{
					nameNode.SUFFIX = nameSuffix;
				}

				vcardExtNode.appendChild( nameNode );
			}

			if ( fullName )
			{
				vcardExtNode.FN = fullName;
			}

			if ( nickname )
			{
				vcardExtNode.NICKNAME = nickname;
			}

			if ( email )
			{
				var emailNode:XML = <EMAIL/>;
				emailNode.appendChild( <INTERNET/> );
				emailNode.appendChild( <PREF/> );
				emailNode.USERID = email;
				vcardExtNode.appendChild( emailNode );
			}

			if ( company || department )
			{
				var organizationNode:XML = <ORG/>;

				if ( company )
				{
					organizationNode.ORGNAME = company;
				}

				if ( department )
				{
					organizationNode.ORGUNIT = department;
				}

				vcardExtNode.appendChild( organizationNode );
			}

			if ( title )
			{
				vcardExtNode.TITLE = title;
			}

			if ( url )
			{
				vcardExtNode.URL = url;
			}

			if ( birthDay )
			{
				var month:uint = ( birthDay.getMonth() + 1 );
				vcardExtNode.BDAY = birthDay.getFullYear() + "-"
					+ ( month < 10 ? "0" + month : month ) + "-"
					+ birthDay.getDate();
			}

			if ( gender )
			{
				vcardExtNode.GENDER = gender;
			}

			if ( maritalStatus )
			{
				vcardExtNode.MARITALSTATUS = maritalStatus;
			}

			if ( workAddress || workCity || workCountry || workPostalCode || workStateProvince )
			{
				var workAddressNode:XML = <ADR/>;
				workAddressNode.appendChild( <WORK/> );

				if ( workAddress )
				{
					workAddressNode.STREET = workAddress;
				}

				if ( workCity )
				{
					workAddressNode.LOCALITY = workCity;
				}

				if ( workCountry )
				{
					workAddressNode.CTRY = workCountry;
				}

				if ( workPostalCode )
				{
					workAddressNode.PCODE = workPostalCode;
				}

				if ( workStateProvince )
				{
					workAddressNode.REGION = workStateProvince;
				}

				vcardExtNode.appendChild( workAddressNode );
			}

			if ( homeAddress || homeCity || homeCountry || homePostalCode || homeStateProvince )
			{
				var homeAddressNode:XML = <ADR/>;
				homeAddressNode.appendChild( <HOME/> );

				if ( homeAddress )
				{
					homeAddressNode.STREET = homeAddress;
				}

				if ( homeCity )
				{
					homeAddressNode.LOCALITY = homeCity;
				}

				if ( homeCountry )
				{
					homeAddressNode.CTRY = homeCountry;
				}

				if ( homePostalCode )
				{
					homeAddressNode.PCODE = homePostalCode;
				}

				if ( homeStateProvince )
				{
					homeAddressNode.REGION = homeStateProvince;
				}

				vcardExtNode.appendChild( homeAddressNode );
			}
			

			var phoneNode:XML = <TEL/>;
			phoneNode.setChildren( <WORK/> );

			if ( workCellNumber )
			{
				var workCellNode:XML = phoneNode.copy();
				workCellNode.appendChild( <CELL/> );
				workCellNode.NUMBER = workCellNumber;
				vcardExtNode.appendChild( workCellNode );
			}

			if ( workFaxNumber )
			{
				var workFaxNode:XML = phoneNode.copy();
				workFaxNode.appendChild( <FAX/> );
				workFaxNode.NUMBER = workFaxNumber;
				vcardExtNode.appendChild( workFaxNode );
			}

			if ( workPagerNumber )
			{
				var workPagerNode:XML = phoneNode.copy();
				workPagerNode.appendChild( <PAGER/> );
				workPagerNode.NUMBER = workPagerNumber;
				vcardExtNode.appendChild( workPagerNode );
			}

			if ( workVoiceNumber )
			{
				var workVoiceNode:XML = phoneNode.copy();
				workVoiceNode.appendChild( <VOICE/> );
				workVoiceNode.NUMBER = workVoiceNumber;
				vcardExtNode.appendChild( workVoiceNode );
			}

			phoneNode.setChildren( <HOME/> );
			
			if ( homeCellNumber )
			{
				var homeCellNode:XML = phoneNode.copy();
				homeCellNode.appendChild( <CELL/> );
				homeCellNode.NUMBER = homeCellNumber;
				vcardExtNode.appendChild( homeCellNode );
			}

			if ( homeFaxNumber )
			{
				var homeFaxNode:XML = phoneNode.copy();
				homeFaxNode.appendChild( <FAX/> );
				homeFaxNode.NUMBER = homeFaxNumber;
				vcardExtNode.appendChild( homeFaxNode );
			}

			if ( homePagerNumber )
			{
				var homePagerNode:XML = phoneNode.copy();
				homePagerNode.appendChild( <PAGER/> );
				homePagerNode.NUMBER = homePagerNumber;
				vcardExtNode.appendChild( homePagerNode );
			}

			if ( homeVoiceNumber )
			{
				var homeVoiceNode:XML = phoneNode.copy();
				homeVoiceNode.appendChild( <VOICE/> );
				homeVoiceNode.NUMBER = homeVoiceNumber;
				vcardExtNode.appendChild( homeVoiceNode );
			}

			iq.addExtension( vcardExt );
			con.send( iq );
		}
	}
}
