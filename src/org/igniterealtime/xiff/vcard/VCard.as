/*
 * Copyright (C) 2003-2009 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
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
	import com.hurlant.util.Base64;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.xml.XMLDocument;

	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.XMPPStanza;
	import org.igniterealtime.xiff.data.im.RosterItemVO;
	import org.igniterealtime.xiff.data.vcard.VCardExtension;
	import org.igniterealtime.xiff.events.VCardEvent;
	import org.igniterealtime.xiff.util.DateTimeParser;

	/**
	 * Dispatched when the vCard has loaded.
	 *
	 * @eventType org.igniterealtime.xiff.events.VCardEvent.LOADED
	 */
	[Event( name="loaded", type="org.igniterealtime.xiff.events.VCardEvent" )]

	/**
	 * Dispatched when the vCard has been saved.
	 *
	 * @eventType org.igniterealtime.xiff.events.VCardEvent.SAVED
	 */
	[Event( name="saved", type="org.igniterealtime.xiff.events.VCardEvent" )]

	/**
	 * Dispatched when saving the vCard fails.
	 *
	 * @eventType org.igniterealtime.xiff.events.VCardEvent.SAVE_ERROR
	 */
	[Event( name="saveError", type="org.igniterealtime.xiff.events.VCardEvent" )]

	/**
	 * @see http://tools.ietf.org/html/rfc2426
	 */
	public class VCard extends EventDispatcher
	{
		/**
		 * The interval on which to flush the vCard cache.
		 * The default value is 6 hours.
		 */
		public static var cacheFlushInterval:Number = ( 6 * 60 * 60 * 1000 );

		/**
		 * VCard cache indexed by the UnescapedJID.bareJID of the contact or current user.
		 */
		private static var cache:Object = {};

		/**
		 * Flush the vCard cache every 6 hours by default.
		 */
		private static var cacheFlushTimer:Timer = new Timer( cacheFlushInterval, 0 );

		/**
		 * Queue of the pending requests
		 */
		private static var requestQueue:Array = [];

		/**
		 * Timer to process the queue.
		 */
		private static var requestTimer:Timer;

		/**
		 * Birthday.
		 */
		public var birthDay:Date;

		/**
		 * Organizational name.
		 */
		public var company:String;

		/**
		 * Organizational unit.
		 */
		public var department:String;

		/**
		 * Free-form descriptive text.
		 */
		public var description:String;

		/**
		 * Email address.
		 */
		public var email:String;

		/**
		 * Given name.
		 */
		public var firstName:String;

		/**
		 * Formatted or display name.
		 */
		public var formattedName:String;

		/**
		 * Gender.
		 */
		public var gender:String;

		/**
		 * Home street address.
		 */
		public var homeAddress:String;

		/**
		 * Home cell number.
		 */
		public var homeCellNumber:String;

		/**
		 * Home city.
		 */
		public var homeCity:String;

		/**
		 * Home country.
		 */
		public var homeCountry:String;

		/**
		 * Home fax number.
		 */
		public var homeFaxNumber:String;

		/**
		 * Home pager number.
		 */
		public var homePagerNumber:String;

		/**
		 * Home postal code.
		 */
		public var homePostalCode:String;

		/**
		 * Home state/province.
		 */
		public var homeStateProvince:String;

		/**
		 * Home telephone number.
		 */
		public var homeVoiceNumber:String;

		/**
		 * Jabber ID.
		 */
		public var jid:UnescapedJID;

		/**
		 * Family name.
		 */
		public var lastName:String;

		/**
		 * Marital status.
		 */
		public var maritalStatus:String;

		/**
		 * Middle name.
		 */
		public var middleName:String;

		/**
		 * Name prefix.
		 */
		public var namePrefix:String;

		/**
		 * Name suffix.
		 */
		public var nameSuffix:String;

		/**
		 * Nickname.
		 */
		public var nickname:String;

		/**
		 * Other name.
		 */
		public var otherName:String;

		/**
		 * The byte array of the photo.
		 * To save a photo, either photoBytes or photoURL are required, but not both.
		 */
		public var photoBytes:ByteArray;

		/**
		 * The image type of the photo.
		 * To save a photo, this property is required.
		 */
		public var photoType:String;

		/**
		 * The url of the photo.
		 * To save a photo, either photoBytes or photoURL are required, but not both.
		 */
		public var photoURL:String;

		/**
		 * Role.
		 */
		public var role:String;

		/**
		 * Title.
		 */
		public var title:String;

		/**
		 * Unique identifier.
		 */
		public var uid:String;

		/**
		 * Directory URL.
		 */
		public var url:String;

		/**
		 * Version of the vCard. Usually 2.0 or 3.0.
		 * @see http://xmpp.org/extensions/xep-0054.html#impl
		 */
		public var version:String;

		/**
		 * Work street address.
		 */
		public var workAddress:String;

		/**
		 * Work cell number.
		 */
		public var workCellNumber:String;

		/**
		 * Work city.
		 */
		public var workCity:String;

		/**
		 * Work country.
		 */
		public var workCountry:String;

		/**
		 * Work fax number.
		 */
		public var workFaxNumber:String;

		/**
		 * Work pager number.
		 */
		public var workPagerNumber:String;

		/**
		 * Work postal code.
		 */
		public var workPostalCode:String;

		/**
		 * Work state/province.
		 */
		public var workStateProvince:String;

		/**
		 * Work telephone number.
		 */
		public var workVoiceNumber:String;

		/**
		 * @private
		 */
		private var contact:RosterItemVO;

		/**
		 * @private
		 */
		private var _loaded:Boolean;

		/**
		 * Don't call directly, use the static method getVCard() and add a callback.
		 */
		public function VCard()
		{
		}

		/**
		 * The way a vCard is requested and then later referred to.
		 * <code>var vCard:VCard = VCard.getVCard( connection );<br />
		 * vCard.addEventListener( VCardEvent.LOADED, onVCardLoaded );</code>
		 * @param connection
		 * @param contact (if null, will get current user's vCard)
		 * @return Reference to the vCard which will be filled once the loaded event occurs.
		 */
		public static function getVCard( connection:XMPPConnection, contact:RosterItemVO=null ):VCard
		{
			if ( !cacheFlushTimer.running )
			{
				cacheFlushTimer.reset();
				cacheFlushTimer.delay = cacheFlushInterval;
				cacheFlushTimer.start();
				cacheFlushTimer.addEventListener( TimerEvent.TIMER, function( event:TimerEvent ):void
				{
					for each ( var card:VCard in cache )
					{
						pushRequest( connection, card );
					}
					cache = {};
				} );
			}

			var bareJID:String = contact ? contact.jid.bareJID : connection.jid.bareJID;

			var cachedCard:VCard = cache[ bareJID ] as VCard;
			if ( cachedCard )
			{
				return cachedCard;
			}

			var vCard:VCard = new VCard();
			if( contact )
			{
				vCard.contact = contact;
				vCard.jid = contact.jid;
			}
			cache[ bareJID ] = vCard;

			pushRequest( connection, vCard );

			return vCard;
		}

		/**
		 * Immediately expires the vCard cache.
		 */
		public static function expireCache():void
		{
			if ( cacheFlushTimer.running )
			{
				cacheFlushTimer.stop();
			}
		}

		/**
		 * Add the request to the stack of requests
		 * @param connection
		 * @param vCard
		 */
		private static function pushRequest( connection:XMPPConnection, vCard:VCard ):void
		{
			if ( !requestTimer )
			{
				requestTimer = new Timer( 1, 1 );
				requestTimer.addEventListener( TimerEvent.TIMER_COMPLETE, sendRequest );
			}
			requestQueue.push( { connection: connection, card: vCard } );
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
			{
				return;
			}
			var req:Object = requestQueue.pop();
			var connection:XMPPConnection = req.connection;
			var vCard:VCard = req.card;
			var contact:RosterItemVO = vCard.contact;

			var recipient:EscapedJID = contact ? contact.jid.escaped : null;
			var iq:IQ = new IQ( recipient, IQ.TYPE_GET );
			vCard.jid = contact ? contact.jid : connection.jid;

			iq.callback = vCard.handleVCard;
			iq.addExtension( new VCardExtension() );

			connection.send( iq );
			requestTimer.reset();
			requestTimer.start();
		}

		/**
		 * Deserializes the incoming IQ to fill the values of this vCard.
		 * @param iq
		 */
		public function handleVCard( iq:IQ ):void
		{
			namespace ns = "vcard-temp";
			use namespace ns;

			var node:XML = XML( iq.getNode() );
			var vCardNode:XML = node.children()[ 0 ];

			if ( !vCardNode )
			{
				return;
			}

			version = vCardNode.@version;

			var nodes:XMLList = vCardNode.children();

			for each ( var child:XML in nodes )
			{
				switch ( child.localName() )
				{
					case "PHOTO":
						for each ( var photo:XML in child.children() )
						{
							var value:String = photo.text();

							if ( photo.localName() == "TYPE" && value.length > 0 )
							{
								photoType = value;
							}

							if ( photo.localName() == "BINVAL" && value.length > 0 )
							{
								photoBytes = Base64.decodeToByteArrayB( value );
							}
							else if ( photo.localName() == "EXTVAL" && value.length > 0 )
							{
								photoURL = value;
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
						formattedName = child.text();
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
						else if ( child.HOME.length() == 1 )
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
						description = child.text();
						break;

					case "GENDER":
						gender = child.text();
						break;

					case "BDAY":
						var bday:String = child.children()[ 0 ];
						if ( bday != null && bday.length > 8 )
						{
							birthDay = DateTimeParser.string2date( bday );
						}
						break;

					case "JABBERID":
						var jabberid:String = child.text();
						if ( jabberid != null && jabberid.length > 0 )
						{
							jid = new UnescapedJID( jabberid );
						}
						break;

					case "UID":
						uid = child.text();
						break;

					case "ROLE":
						role = child.text();
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

					//there is some ambiguity surrounding how vCard versions are handled
					//so we need to check it here as well as looking for the attribute
					//as above.  SEE:  http://xmpp.org/extensions/xep-0054.html#impl
					case "VERSION":
						version = child.text();
						break;

					default:
						trace( "handleVCard. unhandled case child.name(): " + child.name() );
						break;
				}
			}

			_loaded = true;
			dispatchEvent( new VCardEvent( VCardEvent.LOADED, this, true, false ) );
		}

		/**
		 * Saves a vCard.
		 * @param connection
		 */
		public function saveVCard( connection:XMPPConnection ):void
		{
			var id:String = XMPPStanza.generateID( "save_vcard_" );
			var iq:IQ = new IQ( null, IQ.TYPE_SET, id, saveVCard_result );
			var vcardExt:VCardExtension = new VCardExtension();
			var vcardExtNode:XML = new XML( vcardExt.getNode().toString() );

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

			if ( formattedName )
			{
				vcardExtNode.FN = formattedName;
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
				vcardExtNode.BDAY = DateTimeParser.date2string( birthDay );
			}

			if ( description )
			{
				vcardExtNode.DESC = description;
			}

			if ( gender )
			{
				vcardExtNode.GENDER = gender;
			}

			if ( role )
			{
				vcardExtNode.ROLE = role;
			}

			if ( maritalStatus )
			{
				vcardExtNode.MARITALSTATUS = maritalStatus;
			}
			
			if ( jid )
			{
				vcardExtNode.JABBERID = jid.toString();
			}
			
			if ( uid )
			{
				vcardExtNode.UID = uid;
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

			if ( photoType != null && ( photoBytes != null || photoURL != null ) )
			{
				var photoNode:XML = <PHOTO/>;
				
				if ( photoBytes )
				{
					var photoBase64:String;
	
					try
					{
						photoBase64 = Base64.encodeByteArray(photoBytes);
					}
					catch(error:Error)
					{
						throw new Error( "VCard:saveVCard Error encoding bytes " + error.getStackTrace() );
					}
	
					try
					{
						var binaryNode:XML = <BINVAL/>;
						binaryNode.appendChild( photoBase64 );
						photoNode.appendChild( binaryNode );
					}
					catch(error:Error)
					{
						throw new Error( "VCard:saveVCard Error converting bytes to string " + error.message );
					}
				}
				else
				{
					var extNode:XML = <EXTVAL/>;
					extNode.appendChild( photoURL );
					photoNode.appendChild( extNode );
				}

				var typeNode:XML = <TYPE/>;
				typeNode.appendChild( photoType );
				photoNode.appendChild( typeNode );

				vcardExtNode.appendChild( photoNode );
			}

			var xmlDoc:XMLDocument = new XMLDocument( vcardExtNode.toString() );
			vcardExt.setNode( xmlDoc.firstChild );

			iq.addExtension( vcardExt );
			connection.send( iq );
		}

		/**
		 *
		 * @param resultIQ
		 */
		public function saveVCard_result( resultIQ:IQ ):void
		{
			var bareJID:String = resultIQ.to.unescaped.bareJID;
			if ( resultIQ.type == IQ.TYPE_ERROR )
			{
				dispatchEvent( new VCardEvent( VCardEvent.SAVE_ERROR, cache[ bareJID ],
					true, true ) );
			}
			else
			{
				delete cache[ bareJID ]; // Force profile refresh on next view
				
				dispatchEvent( new VCardEvent( VCardEvent.SAVED, this, true, false ) );
			}
		}

		/**
		 * Indicates whether the vCard has been loaded.
		 */
		public function get loaded():Boolean
		{
			return _loaded;
		}
	}
}
