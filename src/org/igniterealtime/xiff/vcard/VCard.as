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
package org.igniterealtime.xiff.vcard
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.IXMPPConnection;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.core.IXMPPConnection;
	import org.igniterealtime.xiff.data.IIQ;
	import org.igniterealtime.xiff.data.IQ;
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
	 * VCard updates in 2010:
	 *
	 * <p>New vCard data classes to encompass similar properties:</p>
	 * <ul>
	 * <li>VCardAddress (country, extendedAddress, locality, poBox, postalCode, region, street)</li>
	 * <li>VCardGeographicalPosition (latitude, longitude)</li>
	 * <li>VCardName (family, given, middle, prefix, suffix)</li>
	 * <li>VCardOrganization (name, unit)</li>
	 * <li>VCardPhoto (binaryValue, bytes, externalValue, type)</li>
	 * <li>VCardSound (binaryValue, bytes, externalValue, phonetic)</li>
	 * <li>VCardTelephone (cell, fax, msg, pager, video, voice)</li>
	 * </ul>
	 *
	 * <p>TODO: The only properties not yet implemented from the spec: agent, categories, key</p>
	 *
	 * @see http://tools.ietf.org/html/rfc2426
	 */
	public class VCard extends EventDispatcher implements IVCard
	{
		/**
		 * The interval on which to flush the vCard cache.
		 * The default value is 6 hours.
		 */
		public static var cacheFlushInterval:Number = ( 6 * 60 * 60 * 1000 );

		/**
		 * VCard cache indexed by the UnescapedJID.bareJID of the user.
		 */
		private static var cache:Dictionary = new Dictionary();

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
		 * @private
		 */
		private var _extensionNames:Array = [];

		/**
		 * @private
		 */
		private var _birthday:Date;

		/**
		 * @private
		 */
		private var _description:String;

		/**
		 * @private
		 */
		private var _email:String;

		/**
		 * @private
		 */
		private var _extensions:Dictionary = new Dictionary();

		/**
		 * @private
		 */
		private var _formattedName:String;

		/**
		 * @private
		 */
		private var _geographicalPosition:IVCardGeographicalPosition;

		/**
		 * @private
		 */
		private var _homeAddress:IVCardAddress;

		/**
		 * @private
		 */
		private var _homeAddressLabel:String;

		/**
		 * @private
		 */
		private var _homeTelephone:IVCardTelephone;

		/**
		 * @private
		 */
		private var _jid:UnescapedJID;

		/**
		 * @private
		 */
		private var _loaded:Boolean;

		/**
		 * @private
		 */
		private var _logo:IVCardPhoto;

		/**
		 * @private
		 */
		private var _mailer:String;

		/**
		 * @private
		 */
		private var _name:IVCardName;

		/**
		 * @private
		 */
		private var _nickname:String;

		/**
		 * @private
		 */
		private var _note:String;

		/**
		 * @private
		 */
		private var _organization:IVCardOrganization;

		/**
		 * @private
		 */
		private var _photo:IVCardPhoto;

		/**
		 * @private
		 */
		private var _privacyClass:String;

		/**
		 * @private
		 */
		private var _productID:String;

		/**
		 * @private
		 */
		private var _revision:Date;

		/**
		 * @private
		 */
		private var _role:String;

		/**
		 * @private
		 */
		private var _sortString:String;

		/**
		 * @private
		 */
		private var _sound:IVCardSound;

		/**
		 * @private
		 */
		private var _timezone:Date;

		/**
		 * @private
		 */
		private var _title:String;

		/**
		 * @private
		 */
		private var _uid:String;

		/**
		 * @private
		 */
		private var _url:String;

		/**
		 * @private
		 */
		private var _version:String;

		/**
		 * @private
		 */
		private var _workAddress:IVCardAddress;

		/**
		 * @private
		 */
		private var _workAddressLabel:String;

		/**
		 * @private
		 */
		private var _workTelephone:IVCardTelephone;

		/**
		 * Don't call directly, use the static method getVCard() and add a callback.
		 */
		public function VCard()
		{
		}

		/**
		 * The way a vCard is requested and then later referred to.
		 * <code>var vCard:VCard = VCard.getVCard( connection, jid );<br />
		 * vCard.addEventListener( VCardEvent.LOADED, onVCardLoaded );</code>
		 * @param connection
		 * @param jid
		 * @return Reference to the vCard which will be filled once the loaded event occurs.
		 */
		public static function getVCard( connection:IXMPPConnection, jid:UnescapedJID ):VCard
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
					clearCache();
				} );
			}

			var cachedCard:VCard = cache[ jid.bareJID ] as VCard;
			if ( cachedCard )
			{
				return cachedCard;
			}

			var vCard:VCard = new VCard();
			vCard.jid = jid;

			cache[ jid.bareJID ] = vCard;

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
		 * Immediately clears the vCard cache.
		 */
		public static function clearCache():void
		{
			cache = new Dictionary();
		}

		/**
		 * Add the request to the stack of requests
		 * @param connection
		 * @param vCard
		 */
		private static function pushRequest( connection:IXMPPConnection, vCard:VCard ):void
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
			var connection:IXMPPConnection = req.connection;
			var vCard:VCard = req.card;
			var jid:UnescapedJID = vCard.jid;

			var recipient:EscapedJID = jid.equals( connection.jid, true ) ? null : jid.escaped;
			var iq:IQ = new IQ( recipient, IQ.TYPE_GET );

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
		public function handleVCard( iq:IIQ ):void
		{
			namespace ns = "vcard-temp";
			use namespace ns;

			var node:XML = XML( iq.xml );
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
					//There is some ambiguity surrounding how vCard versions are handled so
					//we need to check it here as well as looking for the attribute as above.
					//SEE:  http://xmpp.org/extensions/xep-0054.html#impl
					case "VERSION":
						version = child.text();
						break;

					case "FN":
						formattedName = child.text();
						break;

					case "N":
						name = new VCardName( child.GIVEN, child.MIDDLE, child.FAMILY, child.PREFIX, child.SUFFIX );
						break;

					case "NICKNAME":
						nickname = child.text();
						break;

					case "PHOTO":
						photo = new VCardPhoto();
						for each ( var photoData:XML in child.children() )
						{
							var photoValue:String = photoData.text();

							if ( photoData.localName() == "TYPE" && photoValue.length > 0 )
							{
								photo.type = photoValue;
							}
							else if ( photoData.localName() == "BINVAL" && photoValue.length > 0 )
							{
								photo.binaryValue = photoValue;
							}
							else if ( photoData.localName() == "EXTVAL" && photoValue.length > 0 )
							{
								photo.externalValue = photoValue;
							}
						}
						break;

					case "BDAY":
						var bday:String = child.children()[ 0 ];
						if ( bday != null && bday.length > 8 )
						{
							birthday = DateTimeParser.string2date( bday );
						}
						break;

					case "ADR":
						if ( child.WORK.length() == 1 )
						{
							workAddress = new VCardAddress( child.STREET, child.LOCALITY, child.REGION, child.PCODE, child.CTRY, child.EXTADD, child.POBOX );
						}
						else if ( child.HOME.length() == 1 )
						{
							homeAddress = new VCardAddress( child.STREET, child.LOCALITY, child.REGION, child.PCODE, child.CTRY, child.EXTADD, child.POBOX );
						}
						break;

					case "LABEL":
						if ( child.WORK.length() == 1 )
						{
							workAddressLabel = child.LINE;
						}
						else if ( child.HOME.length() == 1 )
						{
							homeAddressLabel = child.LINE;
						}
						break;

					case "TEL":
						if ( child.WORK.length() == 1 )
						{
							workTelephone = new VCardTelephone();
							if ( child.VOICE.length() == 1 )
								workTelephone.voice = child.NUMBER;
							else if ( child.FAX.length() == 1 )
								workTelephone.fax = child.NUMBER;
							else if ( child.PAGER.length() == 1 )
								workTelephone.pager = child.NUMBER;
							else if ( child.MSG.length() == 1 )
								workTelephone.msg = child.NUMBER;
							else if ( child.CELL.length() == 1 )
								workTelephone.cell = child.NUMBER;
							else if ( child.VIDEO.length() == 1 )
								workTelephone.video = child.NUMBER;
						}
						else if ( child.HOME.length() == 1 )
						{
							homeTelephone = new VCardTelephone();
							if ( child.VOICE.length() == 1 )
								homeTelephone.voice = child.NUMBER;
							else if ( child.FAX.length() == 1 )
								homeTelephone.fax = child.NUMBER;
							else if ( child.PAGER.length() == 1 )
								homeTelephone.pager = child.NUMBER;
							else if ( child.MSG.length() == 1 )
								homeTelephone.msg = child.NUMBER;
							else if ( child.CELL.length() == 1 )
								homeTelephone.cell = child.NUMBER;
							else if ( child.VIDEO.length() == 1 )
								homeTelephone.video = child.NUMBER;
						}
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

					case "JABBERID":
						var jabberid:String = child.text();
						if ( jabberid != null && jabberid.length > 0 )
						{
							jid = new UnescapedJID( jabberid );
						}
						break;

					case "MAILER":
						mailer = child.text();
						break;

					case "TZ":
						var tz:String = child.children()[ 0 ];
						if ( tz != null && tz.length > 8 )
						{
							timezone = DateTimeParser.string2date( tz );
						}
						break;

					case "GEO":
						geographicalPosition = new VCardGeographicalPosition( child.LAT, child.LON );
						break;

					case "TITLE":
						title = child.text();
						break;

					case "ROLE":
						role = child.text();
						break;

					case "LOGO":
						logo = new VCardPhoto();
						for each ( var logoData:XML in child.children() )
						{
							var logoValue:String = logoData.text();

							if ( logoData.localName() == "TYPE" && logoValue.length > 0 )
							{
								logo.type = logoValue;
							}
							else if ( logoData.localName() == "BINVAL" && logoValue.length > 0 )
							{
								logo.binaryValue = logoValue;
							}
							else if ( logoData.localName() == "EXTVAL" && logoValue.length > 0 )
							{
								logo.externalValue = logoValue;
							}
						}
						break;

					case "AGENT":
						break;

					case "ORG":
						organization = new VCardOrganization( child.ORGNAME, child.ORGUNIT );
						break;

					case "CATEGORIES":
						break;

					case "NOTE":
						note = child.text();
						break;

					case "PRODID":
						productID = child.text();
						break;

					case "REV":
						var rev:String = child.children()[ 0 ];
						if ( rev != null && rev.length > 8 )
						{
							revision = DateTimeParser.string2date( rev );
						}
						break;

					case "SORT-STRING":
						sortString = child.text();
						break;

					case "SOUND":
						sound = new VCardSound();
						if ( child.PHONETIC.length() == 1 )
						{
							sound.phonetic = child.PHONETIC;
						}
						else if ( child.BINVAL.length() == 1 )
						{
							sound.binaryValue = child.BINVAL;
						}
						else if ( child.EXTVAL.length() == 1 )
						{
							sound.externalValue = child.EXTVAL;
						}
						break;

					case "UID":
						uid = child.text();
						break;

					case "URL":
						url = child.text();
						break;

					case "CLASS":
						if ( child.PUBLIC.length() == 1 )
						{
							privacyClass = "public";
						}
						else if ( child.PRIVATE.length() == 1 )
						{
							privacyClass = "private";
						}
						else if ( child.CONFIDENTIAL.length() == 1 )
						{
							privacyClass = "confidential";
						}
						break;

					case "KEY":
						break;

					case "DESC":
						description = child.text();
						break;

					default:
						trace( "handleVCard. Private extension: " + child.name() );
						_extensionNames.push( child.localName() );
						extensions[ child.localName() ] = child.text().toString();
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
		public function saveVCard( connection:IXMPPConnection ):void
		{
			var id:String = IQ.generateID( "save_vcard_" );
			var iq:IQ = new IQ( null, IQ.TYPE_SET, id, saveVCard_result );

			var vcardExt:VCardExtension = createExtension();

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
		 * Create the XML needed to send the VCard within the Extension.
		 * @return
		 */
		public function createExtension():VCardExtension
		{
			var vcardExt:VCardExtension = new VCardExtension();
			var vcardXml:XML = vcardExt.xml;

			//FN
			if ( formattedName )
			{
				vcardXml.FN = formattedName;
			}

			//N
			if ( name )
			{
				var nameNode:XML = <N/>;

				if ( name.family )
				{
					nameNode.FAMILY = name.family;
				}

				if ( name.given )
				{
					nameNode.GIVEN = name.given;
				}

				if ( name.middle )
				{
					nameNode.MIDDLE = name.middle;
				}

				if ( name.prefix )
				{
					nameNode.PREFIX = name.prefix;
				}

				if ( name.suffix )
				{
					nameNode.SUFFIX = name.suffix;
				}

				vcardXml.appendChild( nameNode );
			}

			//NICKNAME
			if ( nickname )
			{
				vcardXml.NICKNAME = nickname;
			}

			//PHOTO
			if ( photo && ( ( photo.type && photo.binaryValue ) || photo.externalValue ) )
			{
				var photoNode:XML = <PHOTO/>;

				if ( photo.binaryValue )
				{
					try
					{
						var photoBinaryNode:XML = <BINVAL/>;
						photoBinaryNode.appendChild( photo.binaryValue );
						photoNode.appendChild( photoBinaryNode );
					}
					catch( error:Error )
					{
						throw new Error( "VCard:saveVCard Error converting bytes to string " + error.message );
					}

					var photoTypeNode:XML = <TYPE/>;
					photoTypeNode.appendChild( photo.type );
					photoNode.appendChild( photoTypeNode );
				}
				else
				{
					var photoExtNode:XML = <EXTVAL/>;
					photoExtNode.appendChild( photo.externalValue );
					photoNode.appendChild( photoExtNode );
				}

				vcardXml.appendChild( photoNode );
			}

			//BDAY
			if ( birthday )
			{
				vcardXml.BDAY = DateTimeParser.date2string( birthday );
			}

			//ADR
			if ( workAddress )
			{
				var workAddressNode:XML = <ADR/>;
				workAddressNode.appendChild( <WORK/> );

				if ( workAddress.poBox )
				{
					workAddressNode.POBOX = workAddress.poBox;
				}

				if ( workAddress.extendedAddress )
				{
					workAddressNode.EXTADD = workAddress.extendedAddress;
				}

				if ( workAddress.street )
				{
					workAddressNode.STREET = workAddress.street;
				}

				if ( workAddress.locality )
				{
					workAddressNode.LOCALITY = workAddress.locality;
				}

				if ( workAddress.region )
				{
					workAddressNode.REGION = workAddress.region;
				}

				if ( workAddress.postalCode )
				{
					workAddressNode.PCODE = workAddress.postalCode;
				}

				if ( workAddress.country )
				{
					workAddressNode.CTRY = workAddress.country;
				}

				vcardXml.appendChild( workAddressNode );
			}

			if ( homeAddress )
			{
				var homeAddressNode:XML = <ADR/>;
				homeAddressNode.appendChild( <HOME/> );

				if ( homeAddress.poBox )
				{
					homeAddressNode.POBOX = homeAddress.poBox;
				}

				if ( homeAddress.extendedAddress )
				{
					homeAddressNode.EXTADD = homeAddress.extendedAddress;
				}

				if ( homeAddress.street )
				{
					homeAddressNode.STREET = homeAddress.street;
				}

				if ( homeAddress.locality )
				{
					homeAddressNode.LOCALITY = homeAddress.locality;
				}

				if ( homeAddress.region )
				{
					homeAddressNode.REGION = homeAddress.region;
				}

				if ( homeAddress.postalCode )
				{
					homeAddressNode.PCODE = homeAddress.postalCode;
				}

				if ( homeAddress.country )
				{
					homeAddressNode.CTRY = homeAddress.country;
				}

				vcardXml.appendChild( homeAddressNode );
			}

			//LABEL
			if ( workAddressLabel )
			{
				var workAddressLabelNode:XML = <LABEL/>;
				workAddressLabelNode.appendChild( <WORK/> );
				workAddressLabelNode.LINE = workAddressLabel;
				vcardXml.appendChild( workAddressLabelNode );
			}

			if ( homeAddressLabel )
			{
				var homeAddressLabelNode:XML = <LABEL/>;
				homeAddressLabelNode.appendChild( <HOME/> );
				homeAddressLabelNode.LINE = homeAddressLabel;
				vcardXml.appendChild( homeAddressLabelNode );
			}

			//TEL
			var phoneNode:XML = <TEL/>;
			if ( workTelephone )
			{
				phoneNode.setChildren( <WORK/> );

				if ( workTelephone.voice )
				{
					var workVoiceNode:XML = phoneNode.copy();
					workVoiceNode.appendChild( <VOICE/> );
					workVoiceNode.NUMBER = workTelephone.voice;
					vcardXml.appendChild( workVoiceNode );
				}

				if ( workTelephone.fax )
				{
					var workFaxNode:XML = phoneNode.copy();
					workFaxNode.appendChild( <FAX/> );
					workFaxNode.NUMBER = workTelephone.fax;
					vcardXml.appendChild( workFaxNode );
				}

				if ( workTelephone.pager )
				{
					var workPagerNode:XML = phoneNode.copy();
					workPagerNode.appendChild( <PAGER/> );
					workPagerNode.NUMBER = workTelephone.pager;
					vcardXml.appendChild( workPagerNode );
				}

				if ( workTelephone.msg )
				{
					var workMsgNode:XML = phoneNode.copy();
					workMsgNode.appendChild( <MSG/> );
					workMsgNode.NUMBER = workTelephone.msg;
					vcardXml.appendChild( workMsgNode );
				}

				if ( workTelephone.cell )
				{
					var workCellNode:XML = phoneNode.copy();
					workCellNode.appendChild( <CELL/> );
					workCellNode.NUMBER = workTelephone.cell;
					vcardXml.appendChild( workCellNode );
				}

				if ( workTelephone.video )
				{
					var workVideoNode:XML = phoneNode.copy();
					workVideoNode.appendChild( <VIDEO/> );
					workVideoNode.NUMBER = workTelephone.video;
					vcardXml.appendChild( workVideoNode );
				}
			}
			if ( homeTelephone )
			{
				phoneNode.setChildren( <HOME/> );

				if ( homeTelephone.voice )
				{
					var homeVoiceNode:XML = phoneNode.copy();
					homeVoiceNode.appendChild( <VOICE/> );
					homeVoiceNode.NUMBER = homeTelephone.voice;
					vcardXml.appendChild( homeVoiceNode );
				}

				if ( homeTelephone.fax )
				{
					var homeFaxNode:XML = phoneNode.copy();
					homeFaxNode.appendChild( <FAX/> );
					homeFaxNode.NUMBER = homeTelephone.fax;
					vcardXml.appendChild( homeFaxNode );
				}

				if ( homeTelephone.pager )
				{
					var homePagerNode:XML = phoneNode.copy();
					homePagerNode.appendChild( <PAGER/> );
					homePagerNode.NUMBER = homeTelephone.pager;
					vcardXml.appendChild( homePagerNode );
				}

				if ( homeTelephone.msg )
				{
					var homeMsgNode:XML = phoneNode.copy();
					homeMsgNode.appendChild( <MSG/> );
					homeMsgNode.NUMBER = homeTelephone.msg;
					vcardXml.appendChild( homeMsgNode );
				}

				if ( homeTelephone.cell )
				{
					var homeCellNode:XML = phoneNode.copy();
					homeCellNode.appendChild( <CELL/> );
					homeCellNode.NUMBER = homeTelephone.cell;
					vcardXml.appendChild( homeCellNode );
				}

				if ( homeTelephone.video )
				{
					var homeVideoNode:XML = phoneNode.copy();
					homeVideoNode.appendChild( <VIDEO/> );
					homeVideoNode.NUMBER = homeTelephone.video;
					vcardXml.appendChild( homeVideoNode );
				}
			}

			//EMAIL
			if ( email )
			{
				var emailNode:XML = <EMAIL/>;
				emailNode.appendChild( <INTERNET/> );
				emailNode.appendChild( <PREF/> );
				emailNode.USERID = email;
				vcardXml.appendChild( emailNode );
			}

			//JABBERID
			if ( jid )
			{
				vcardXml.JABBERID = jid.toString();
			}

			//MAILER
			if ( mailer )
			{
				vcardXml.MAILER = mailer;
			}

			//TZ
			if ( timezone )
			{
				vcardXml.TZ = DateTimeParser.date2string( timezone );
			}

			//GEO
			if( geographicalPosition )
			{
				var geoNode:XML = <GEO/>;

				if ( geographicalPosition.latitude )
				{
					geoNode.LAT = geographicalPosition.latitude;
				}

				if ( geographicalPosition.longitude )
				{
					geoNode.LON = geographicalPosition.longitude;
				}

				vcardXml.appendChild( geoNode );
			}

			//TITLE
			if ( title )
			{
				vcardXml.TITLE = title;
			}

			//ROLE
			if ( role )
			{
				vcardXml.ROLE = role;
			}

			//LOGO
			if ( logo && ( ( logo.type && logo.binaryValue ) || logo.externalValue ) )
			{
				var logoNode:XML = <LOGO/>;

				if ( logo.binaryValue )
				{
					try
					{
						var logoBinaryNode:XML = <BINVAL/>;
						logoBinaryNode.appendChild( logo.binaryValue );
						logoNode.appendChild( logoBinaryNode );
					}
					catch( error:Error )
					{
						throw new Error( "VCard:saveVCard Error converting bytes to string " + error.message );
					}

					var logoTypeNode:XML = <TYPE/>;
					logoTypeNode.appendChild( logo.type );
					logoNode.appendChild( logoTypeNode );
				}
				else
				{
					var logoExtNode:XML = <EXTVAL/>;
					logoExtNode.appendChild( logo.externalValue );
					logoNode.appendChild( logoExtNode );
				}

				vcardXml.appendChild( logoNode );
			}

			//AGENT

			//ORG
			if ( organization )
			{
				var organizationNode:XML = <ORG/>;

				if ( organization.name )
				{
					organizationNode.ORGNAME = organization.name;
				}

				if ( organization.unit )
				{
					organizationNode.ORGUNIT = organization.unit;
				}

				vcardXml.appendChild( organizationNode );
			}

			//CATEGORIES

			//NOTE
			if ( note )
			{
				vcardXml.NOTE = note;
			}

			//PRODID
			if ( productID )
			{
				vcardXml.PRODID = productID;
			}

			//REV
			if ( revision )
			{
				vcardXml.REV = DateTimeParser.date2string( revision );
			}

			//SORT-STRING
			if ( sortString )
			{
				var sortStringNode:XML = <SORT-STRING/>;
				sortStringNode.appendChild( sortString );
				vcardXml.appendChild( sortStringNode );
			}

			//SOUND
			if ( sound && ( sound.phonetic || sound.binaryValue || sound.externalValue ) )
			{
				var soundNode:XML = <SOUND/>;

				if ( sound.phonetic )
				{
					var phoneticNode:XML = <PHONETIC/>;
					phoneticNode.appendChild( sound.phonetic );
					soundNode.appendChild( phoneticNode );
				}
				else if ( sound.binaryValue )
				{
					try
					{
						var soundBinaryNode:XML = <BINVAL/>;
						soundBinaryNode.appendChild( sound.binaryValue );
						soundNode.appendChild( soundBinaryNode );
					}
					catch( error:Error )
					{
						throw new Error( "VCard:saveVCard Error converting bytes to string " + error.message );
					}
				}
				else
				{
					var soundExtNode:XML = <EXTVAL/>;
					soundExtNode.appendChild( sound.externalValue );
					soundNode.appendChild( soundExtNode );
				}

				vcardXml.appendChild( soundNode );
			}

			//UID
			if ( uid )
			{
				vcardXml.UID = uid;
			}

			//URL
			if ( url )
			{
				vcardXml.URL = url;
			}

			//CLASS
			if( privacyClass && ( privacyClass == "public" || privacyClass == "private" || privacyClass == "confidential" ) )
			{
				var classNode:XML = <CLASS/>;
				classNode.appendChild( <{ privacyClass.toUpperCase() }/> );

				vcardXml.appendChild( classNode );
			}

			//KEY

			//DESC
			if ( description )
			{
				vcardXml.DESC = description;
			}

			//X
						if ( _extensionNames.length > 0 )
			{
								for each( var xName:String in _extensionNames )
				{
					vcardXml[ xName ] = _extensions[ xName ];
				}
			}

			vcardExt.xml = vcardXml;

			return vcardExt;
		}

		/**
		 * Birthday.
		 */
		public function get birthday():Date
		{
			return _birthday;
		}
		public function set birthday( value:Date ):void
		{
			_birthday = value;
		}

		/**
		 * Free-form descriptive text.
		 */
		public function get description():String
		{
			return _description;
		}
		public function set description( value:String ):void
		{
			_description = value;
		}

		/**
		 * Email address.
		 */
		public function get email():String
		{
			return _email;
		}
		public function set email( value:String ):void
		{
			_email = value;
		}

		/**
		 * Map of the vCard's private extensions.
		 */
		public function get extensions():Dictionary
		{
			return _extensions;
		}

		/**
		 * Formatted or display name.
		 */
		public function get formattedName():String
		{
			return _formattedName;
		}
		public function set formattedName( value:String ):void
		{
			_formattedName = value;
		}

		/**
		 * Geographical position.
		 */
		public function get geographicalPosition():IVCardGeographicalPosition
		{
			return _geographicalPosition;
		}
		public function set geographicalPosition( value:IVCardGeographicalPosition ):void
		{
			_geographicalPosition = value;
		}

		/**
		 * Structured home address.
		 */
		public function get homeAddress():IVCardAddress
		{
			return _homeAddress;
		}
		public function set homeAddress( value:IVCardAddress ):void
		{
			_homeAddress = value;
		}

		/**
		 * Home address label.
		 */
		public function get homeAddressLabel():String
		{
			return _homeAddressLabel;
		}
		public function set homeAddressLabel( value:String ):void
		{
			_homeAddressLabel = value;
		}

		/**
		 * Home telephone number.
		 */
		public function get homeTelephone():IVCardTelephone
		{
			return _homeTelephone;
		}
		public function set homeTelephone( value:IVCardTelephone ):void
		{
			_homeTelephone = value;
		}

		/**
		 * Jabber ID.
		 */
		public function get jid():UnescapedJID
		{
			return _jid;
		}
		public function set jid( value:UnescapedJID ):void
		{
			_jid = value;
		}

		/**
		 * Indicates whether the vCard has been loaded.
		 */
		public function get loaded():Boolean
		{
			return _loaded;
		}

		/**
		 * Organization logo.
		 */
		public function get logo():IVCardPhoto
		{
			return _logo;
		}
		public function set logo( value:IVCardPhoto ):void
		{
			_logo = value;
		}

		/**
		 * Mailer (e.g., Mail User Agent Type).
		 */
		public function get mailer():String
		{
			return _mailer;
		}
		public function set mailer( value:String ):void
		{
			_mailer = value;
		}

		/**
		 * Structured name.
		 */
		public function get name():IVCardName
		{
			return _name;
		}
		public function set name( value:IVCardName ):void
		{
			_name = value;
		}

		/**
		 * Nickname.
		 */
		public function get nickname():String
		{
			return _nickname;
		}
		public function set nickname( value:String ):void
		{
			_nickname = value;
		}

		/**
		 * Commentary note.
		 */
		public function get note():String
		{
			return _note;
		}
		public function set note( value:String ):void
		{
			_note = value;
		}

		/**
		 * Organizational name and unit.
		 */
		public function get organization():IVCardOrganization
		{
			return _organization;
		}
		public function set organization( value:IVCardOrganization ):void
		{
			_organization = value;
		}

		/**
		 * Photograph.
		 */
		public function get photo():IVCardPhoto
		{
			return _photo;
		}
		public function set photo( value:IVCardPhoto ):void
		{
			_photo = value;
		}

		/**
		 * Privacy classification.
		 */
		public function get privacyClass():String
		{
			return _privacyClass;
		}
		public function set privacyClass( value:String ):void
		{
			_privacyClass = value;
		}

		/**
		 * Identifier of product that generated the vCard.
		 */
		public function get productID():String
		{
			return _productID;
		}
		public function set productID( value:String ):void
		{
			_productID = value;
		}

		/**
		 * Last revised.
		 */
		public function get revision():Date
		{
			return _revision;
		}
		public function set revision( value:Date ):void
		{
			_revision = value;
		}

		/**
		 * Role.
		 */
		public function get role():String
		{
			return _role;
		}
		public function set role( value:String ):void
		{
			_role = value;
		}

		/**
		 * Sort string.
		 */
		public function get sortString():String
		{
			return _sortString;
		}
		public function set sortString( value:String ):void
		{
			_sortString = value;
		}

		/**
		 * Formatted name pronunciation.
		 */
		public function get sound():IVCardSound
		{
			return _sound;
		}
		public function set sound( value:IVCardSound ):void
		{
			_sound = value;
		}

		/**
		 * Time zone's Standard Time UTC offset.
		 */
		public function get timezone():Date
		{
			return _timezone;
		}
		public function set timezone( value:Date ):void
		{
			_timezone = value;
		}

		/**
		 * Title.
		 */
		public function get title():String
		{
			return _title;
		}
		public function set title( value:String ):void
		{
			_title = value;
		}

		/**
		 * Unique identifier.
		 */
		public function get uid():String
		{
			return _uid;
		}
		public function set uid( value:String ):void
		{
			_uid = value;
		}

		/**
		 * Directory URL.
		 */
		public function get url():String
		{
			return _url;
		}
		public function set url( value:String ):void
		{
			_url = value;
		}

		/**
		 * Version of the vCard. Usually 2.0 or 3.0.
		 * @see http://xmpp.org/extensions/xep-0054.html#impl
		 */
		public function get version():String
		{
			return _version;
		}
		public function set version( value:String ):void
		{
			_version = value;
		}

		/**
		 * Structured work address.
		 */
		public function get workAddress():IVCardAddress
		{
			return _workAddress;
		}
		public function set workAddress( value:IVCardAddress ):void
		{
			_workAddress = value;
		}

		/**
		 * Work address label.
		 */
		public function get workAddressLabel():String
		{
			return _workAddressLabel;
		}
		public function set workAddressLabel( value:String ):void
		{
			_workAddressLabel = value;
		}

		/**
		 * Work telephone number.
		 */
		public function get workTelephone():IVCardTelephone
		{
			return _workTelephone;
		}
		public function set workTelephone( value:IVCardTelephone ):void
		{
			_workTelephone = value;
		}
	}
}
