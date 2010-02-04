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

	//import mx.utils.Base64Decoder;
	import com.hurlant.util.Base64;

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
		 * VCard cache indexed by the jid or the user
		 */
		private static var cache:Object = {};

		/**
		 * Flush the vcard cache every 6 hours
		 */
		private static var cacheFlushTimer:Timer = new Timer( 6 * 60 * 60 * 1000, 0 );

		/**
		 * Queue of the pending requests
		 */
		private static var requestQueue:Array = [];

		/**
		 * Timer to prosess the queue
		 */
		private static var requestTimer:Timer;

		/**
		 *
		 */
		public var birthDay:Date;

		/**
		 *
		 */
		public var company:String;

		/**
		 *
		 */
		public var department:String;

		/**
		 *
		 */
		public var email:String;

		/**
		 *
		 */
		public var firstName:String;

		/**
		 *
		 */
		public var fullName:String;

		/**
		 *
		 */
		public var gender:String;

		/**
		 *
		 */
		public var homeAddress:String;

		/**
		 *
		 */
		public var homeCellNumber:String;

		/**
		 *
		 */
		public var homeCity:String;

		/**
		 *
		 */
		public var homeCountry:String;

		/**
		 *
		 */
		public var homeFaxNumber:String;

		/**
		 *
		 */
		public var homePagerNumber:String;

		/**
		 *
		 */
		public var homePostalCode:String;

		/**
		 *
		 */
		public var homeStateProvince:String;

		/**
		 *
		 */
		public var homeVoiceNumber:String;

		/**
		 *
		 */
		public var jid:UnescapedJID;

		/**
		 *
		 */
		public var lastName:String;

		/**
		 *
		 */
		public var loaded:Boolean = false;

		/**
		 *
		 */
		public var maritalStatus:String;

		/**
		 *
		 */
		public var middleName:String;

		/**
		 *
		 */
		public var namePrefix:String;

		/**
		 *
		 */
		public var nameSuffix:String;

		/**
		 *
		 */
		public var nickname:String;

		/**
		 *
		 */
		public var otherName:String;

		/**
		 *
		 */
		public var title:String;

		/**
		 *
		 */
		public var url:String;

		/**
		 * Version of the VCard. Usually 2.0 or 3.0.
		 * @see http://xmpp.org/extensions/xep-0054.html#impl
		 */
		public var version:Number;

		/**
		 *
		 */
		public var workAddress:String;

		/**
		 *
		 */
		public var workCellNumber:String;

		/**
		 *
		 */
		public var workCity:String;

		/**
		 *
		 */
		public var workCountry:String;

		/**
		 *
		 */
		public var workFaxNumber:String;

		/**
		 *
		 */
		public var workPagerNumber:String;

		/**
		 *
		 */
		public var workPostalCode:String;

		/**
		 *
		 */
		public var workStateProvince:String;

		/**
		 *
		 */
		public var workVoiceNumber:String;

		/**
		 *
		 */
		private var _avatar:DisplayObject;
		
		/**
		 *
		 * @hint for saving avatar
		 */
		private var _avatarType:String;

		/**
		 *
		 */
		private var _imageBytes:ByteArray;

		/**
		 *
		 */
		private var contact:RosterItemVO;

		/**
		 * Don't call directly VCard, use a static method (getVCard) and add a callback.
		 */
		public function VCard()
		{

		}

		/**
		 * Seems to be the way a vcard is requested and then later referred to:
		 * <code>var vCard:VCard = VCard.getVCard(_connection, item);<br />
		 * vCard.addEventListener(VCardEvent.LOADED, onVCard);</code>
		 * @param connection
		 * @param user
		 * @return Reference to the VCard which will be filled once the loaded event occurs.
		 */
		public static function getVCard( connection:XMPPConnection, user:RosterItemVO ):VCard
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
						pushRequest( connection, vcard );
					}
				} );
			}

			var jidString:String = user.jid.toString();

			var cachedCard:VCard = cache[ jidString ];
			if ( cachedCard )
			{
				return cachedCard;
			}

			var vcard:VCard = new VCard();
			vcard.contact = user;
			vcard.jid = user.jid;
			cache[ jidString ] = vcard;

			pushRequest( connection, vcard );

			return vcard;
		}

		/**
		 * Add the request to the stack of requests
		 * @param connection
		 * @param vcard
		 */
		private static function pushRequest( connection:XMPPConnection, vcard:VCard ):void
		{
			if ( !requestTimer )
			{
				requestTimer = new Timer( 1, 1 );
				requestTimer.addEventListener( TimerEvent.TIMER_COMPLETE, sendRequest );
			}
			requestQueue.push( { connection: connection, card: vcard } );
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
			var vcard:VCard = req.card;
			var user:RosterItemVO = vcard.contact;

			var iq:IQ = new IQ( user.jid.escaped, IQ.TYPE_GET );
			vcard.jid = user.jid;

			iq.callbackName = "handleVCard";
			iq.callbackScope = vcard;
			iq.addExtension( new VCardExtension() );

			connection.send( iq );
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
		 * The byte array to be used with a Loader.loadBytes or similar.
		 */
		public function get avatar():ByteArray
		{
			return _imageBytes;
		}
		public function set avatar( value:ByteArray ) : void
		{
			_imageBytes = value;
		}
		
		/**
		 * The image type of the avatar. Used for saving the image.
		 * If this is blank, the avatar will not be saved.
		 */
		public function set avatarType( value:String ) : void
		{
			_avatarType = value;
		}
		
		/**
		 * Deserializes the incoming IQ to fill the values of this vcard.
		 * @param iq
		 */
		public function handleVCard( iq:IQ ):void
		{
			namespace ns = "vcard-temp";
			use namespace ns;
			
			var node:XML = XML( iq.getNode() );
			var vCardNode:XML = node.children()[ 0 ];

			//var vCardNode:XML = iq.node.children()[ 0 ];
			if ( !vCardNode )
			{
				return;
			}

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
								/*
								var decoder:Base64Decoder = new Base64Decoder();
								decoder.decode( value );
								_imageBytes = decoder.flush();
								*/

								_imageBytes = Base64.decodeToByteArray( value );
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
					
					//there is some ambiguity surrounding how vCard versions are handled
					//so we need to check it here as well as looking for the attribute
					//as above.  SEE:  http://xmpp.org/extensions/xep-0054.html#impl
					case "VERSION":
						version = Number(child.text());
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
		 * @param connection
		 * @param user
		 */
		public function saveVCard( connection:XMPPConnection, user:RosterItemVO ):void
		{
			var id:String = XMPPStanza.generateID( "save_vcard_" );
			var iq:IQ = new IQ( null, IQ.TYPE_SET, id, null, this, _vCardSent );
			var vcardExt:VCardExtension = new VCardExtension();
			var vcardExtNode:XML = new XML(vcardExt.getNode().toString());
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
			
			if ( avatar != null && _avatarType != null)
			{
				var avatarNode:XML = <PHOTO/>
				var avatarBase64:String;

				try
				{
					avatarBase64 = Base64.encodeByteArray(avatar);
				}
				catch(err:Error)
				{
					throw new Error("VCard:saveVCard Error encoding bytes " + err.getStackTrace());
				}
				
				try
				{
					var binaryNode:XML = <BINVAL/>;
					binaryNode.appendChild(avatarBase64);
					avatarNode.appendChild(binaryNode);
				}
				catch(err:Error)
				{
					throw new Error("VCard:saveVCard Error converting bytes to string " + err.message);
				}

				var typeNode:XML = <TYPE/>;
				typeNode.appendChild(_avatarType);
				avatarNode.appendChild(typeNode);
					
				vcardExtNode.appendChild( avatarNode );
			}

			iq.addExtension( vcardExt );
			connection.send( iq );
		}
	}
}
