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
package org.igniterealtime.xiff.data.pubsub
{
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.util.DateTimeParser;

	/**
	 * XEP-0080: User Location
	 *
	 * <p>The format defined herein was designed to address the following
	 * requirements:</p>
	 * <ul>
	 *   <li>It shall be possible to encapsulate location in terms of Global
	 *   Positioning System (GPS) coordinates as well as civil location
	 *  (city, street, building, etc.).</li>
	 *   <li>The GPS encoding mechanism shall have a single set of units,
	 *   so that receivers do not need to use heuristics to determine an
	 *   entity's position.</li>
	 *   <li>It shall be possible to specify the known amount of error in
	 *   the GPS coordinates.</li>
	 *   <li>It shall be possible to include a natural-language description
	 *   of the location.</li>
	 * </ul>
	 *
	 * @see http://xmpp.org/extensions/xep-0080.html
	 */
	public class UserLocationExtension extends Extension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/geoloc";
		public static const ELEMENT_NAME:String = "geoloc";

		/**
		 * Location information about human users SHOULD be communicated and
		 * transported by means of Publish-Subscribe or the subset thereof
		 * specified in Personal Eventing Protocol (the examples below
		 * assume that the user's XMPP server supports PEP, thus the publish
		 * request lacks a 'to' address and the notification message has
		 * a 'from' address of the user's bare JID).
		 *
		 * <p>Although the XMPP publish-subscribe extension is the preferred
		 * means for transporting location information about human users,
		 * applications that do not involve human users (e.g., device tracking)
		 * MAY use other transport methods; however, because location
		 * information is not pure presence information and can change
		 * independently of network availability, it SHOULD NOT be provided
		 * as an extension to 'presence'.</p>
		 *
		 * @param	parent
		 */
		public function UserLocationExtension( parent:XML = null )
		{
			super(parent);
		}

		public function getNS():String
		{
			return UserLocationExtension.NS;
		}

		public function getElementName():String
		{
			return UserLocationExtension.ELEMENT_NAME;
		}

		/**
		 * Horizontal GPS error in meters; this element obsoletes the 'error' element
		 * @exampleText 10
		 */
		public function get accuracy():Number
		{
			return parseFloat(getField("accuracy"));
		}
		public function set accuracy(value:Number):void
		{
			if (isNaN(value))
			{
				setField("accuracy", null);
			}
			else
			{
				setField("accuracy", value.toString());
			}
		}

		/**
		 * Altitude in meters above or below sea level
		 * @exampleText 1609
		 */
		public function get alt():Number
		{
			return parseFloat(getField("alt"));
		}
		public function set alt(value:Number):void
		{
			if (isNaN(value))
			{
				setField("alt", null);
			}
			else
			{
				setField("alt", value.toString());
			}
		}

		/**
		 * A named area such as a campus or neighborhood
		 * @exampleText Central Park
		 */
		public function get area():String
		{
			return getField("area");
		}
		public function set area(value:String):void
		{
			setField("area", value);
		}

		/**
		 * GPS bearing (direction in which the entity is heading to reach
		 * its next waypoint), measured in decimal degrees relative to
		 * true north. It is the responsibility of the receiver to translate
		 * bearing into decimal degrees relative to magnetic north, if desired.
		 * @exampleText
		 */
		public function get bearing():Number
		{
			return parseFloat(getField("bearing"));
		}
		public function set bearing(value:Number):void
		{
			if (isNaN(value))
			{
				setField("bearing", null);
			}
			else
			{
				setField("bearing", value.toString());
			}
		}

		/**
		 * A specific building on a street or in an area
		 * @exampleText The Empire State Building
		 */
		public function get building():String
		{
			return getField("building");
		}
		public function set building(value:String):void
		{
			setField("building", value);
		}

		/**
		 * The nation where the user is located
		 * @exampleText United States
		 */
		public function get country():String
		{
			return getField("country");
		}
		public function set country(value:String):void
		{
			setField("country", value);
		}

		/**
		 * The ISO 3166 two-letter country code
		 * @exampleText US
		 */
		public function get countrycode():String
		{
			return getField("countrycode");
		}
		public function set countrycode(value:String):void
		{
			setField("countrycode", value);
		}

		/**
		 * GPS datum. If datum is not included, receiver MUST assume WGS84;
		 * receivers MUST implement WGS84; senders MAY use another datum,
		 * but it is not recommended.
		 * @exampleText
		 */
		public function get datum():String
		{
			return getField("datum");
		}
		public function set datum(value:String):void
		{
			setField("datum", value);
		}

		/**
		 * A natural-language name for or description of the location
		 * @exampleText Bill's house
		 */
		public function get description():String
		{
			return getField("description");
		}
		public function set description(value:String):void
		{
			setField("description", value);
		}

		/**
		 * Horizontal GPS error in arc minutes; this element is deprecated in
		 * favor of 'accuracy'
		 * @exampleText 290.8882087
		 */
		public function get error():Number
		{
			return parseFloat(getField("error"));
		}
		public function set error(value:Number):void
		{
			if (isNaN(value))
			{
				setField("error", null);
			}
			else
			{
				setField("error", value.toString());
			}
		}

		/**
		 * A particular floor in a building
		 * @exampleText 102
		 */
		public function get floor():String
		{
			return getField("floor");
		}
		public function set floor(value:String):void
		{
			setField("floor", value);
		}

		/**
		 * Latitude in decimal degrees North
		 * @exampleText 39.75
		 */
		public function get lat():Number
		{
			return parseFloat(getField("lat"));
		}
		public function set lat(value:Number):void
		{
			if (isNaN(value))
			{
				setField("lat", null);
			}
			else
			{
				setField("lat", value.toString());
			}
		}

		/**
		 * A locality within the administrative region, such as a town or city
		 * @exampleText New York City
		 */
		public function get locality():String
		{
			return getField("locality");
		}
		public function set locality(value:String):void
		{
			setField("locality", value);
		}

		/**
		 * Longitude in decimal degrees East
		 * @exampleText -104.99
		 */
		public function get lon():Number
		{
			return parseFloat(getField("lon"));
		}
		public function set lon(value:Number):void
		{
			if (isNaN(value))
			{
				setField("lon", null);
			}
			else
			{
				setField("lon", value.toString());
			}
		}

		/**
		 * A code used for postal delivery
		 * @exampleText 10118
		 */
		public function get postalcode():String
		{
			return getField("postalcode");
		}
		public function set postalcode(value:String):void
		{
			setField("postalcode", value);
		}

		/**
		 * An administrative region of the nation, such as a state or province
		 * @exampleText New York
		 */
		public function get region():String
		{
			return getField("region");
		}
		public function set region(value:String):void
		{
			setField("region", value);
		}

		/**
		 * A particular room in a building
		 * @exampleText Observatory
		 */
		public function get room():String
		{
			return getField("room");
		}
		public function set room(value:String):void
		{
			setField("room", value);
		}

		/**
		 * The speed at which the entity is moving, in meters per second
		 * @exampleText 52.69
		 */
		public function get speed():Number
		{
			return parseFloat(getField("speed"));
		}
		public function set speed(value:Number):void
		{
			if (isNaN(value))
			{
				setField("speed", null);
			}
			else
			{
				setField("speed", value.toString());
			}
		}

		/**
		 * A thoroughfare within the locality, or a crossing of two thoroughfares
		 * @exampleText 350 Fifth Avenue / 34th and Broadway
		 */
		public function get street():String
		{
			return getField("street");
		}
		public function set street(value:String):void
		{
			setField("street", value);
		}

		/**
		 * A catch-all element that captures any other information about the location
		 * @exampleText Northwest corner of the lobby
		 */
		public function get text():String
		{
			return getField("text");
		}
		public function set text(value:String):void
		{
			setField("text", value);
		}

		/**
		 * UTC timestamp specifying the moment when the reading was taken
		 *
		 * @see http://xmpp.org/extensions/xep-0082.html
		 * @exampleText 2004-02-19T21:12Z
		 */
		public function get timestamp():Date
		{
			var value:String = getField("timestamp");
			if (value != null)
			{
				return DateTimeParser.string2dateTime(value);
			}
			return null;
		}
		public function set timestamp(value:Date):void
		{
			if (value == null)
			{
				setField("timestamp", null);
			}
			else
			{
				setField("timestamp", DateTimeParser.dateTime2string(value));
			}
		}

		/**
		 * A URI or URL pointing to information about the location
		 * @exampleText http://www.esbnyc.com/
		 */
		public function get uri():String
		{
			return getField("uri");
		}
		public function set uri(value:String):void
		{
			setField("uri", value);
		}

	}
}
