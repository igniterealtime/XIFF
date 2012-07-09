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
package org.igniterealtime.xiff.data.disco
{
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.IExtension;

	

	/**
	 * Implements <a href="http://xmpp.org/extensions/xep-0030.html">XEP-0030: Service Discovery</a>
	 * for service info discovery.
	 * Also, take a look at <a href="http://xmpp.org/extensions/xep-0020.html">XEP-0020</a> and
	 * <a href="http://xmpp.org/extensions/xep-0060.html">XEP-0060</a>.
	 *
	 * @see http://xmpp.org/extensions/xep-0030.html
	 */
	public class InfoDiscoExtension extends DiscoExtension implements IExtension
	{
		public static const NS:String = "http://jabber.org/protocol/disco#info";

		private var _identities:Array = [];
		private var _features:Array = [];

		/**
		 *
		 * @param	parent
		 */
		public function InfoDiscoExtension( parent:XML=null )
		{
			super( parent );
		}

		public function getElementName():String
		{
			return DiscoExtension.ELEMENT_NAME;
		}

		public function getNS():String
		{
			return InfoDiscoExtension.NS;
		}

		/**
	     * Registers this extension with the extension registry for it to be used,
		 * in case incoming data matches the ELEMENT_NAME and NS.
	     */
		public static function enable():void
		{
			ExtensionClassRegistry.register( InfoDiscoExtension );
		}

		/**
		 * An array of objects that represent the identities of a resource discovered. For more information on
		 * categories, see <a href="http://www.jabber.org/registrar/disco-categories.html">
		 * http://www.jabber.org/registrar/disco-categories.html</a>
		 *
		 * The objects in the array have the following possible attributes:
		 * <ul>
		 * <li><code>category</code> - a category of the kind of identity</li>
		 * <li><code>type</code> - a path to a resource that can be discovered without a JID</li>
		 * <li><code>name</code> - the friendly name of the identity</li>
		 * </ul>
		 *
		 */
		public function get identities():Array
		{
			return _identities;
		}
		public function set identities( value:Array ):void
		{
			_identities = value;
		}

		/**
		 * An array of namespaces this service supports for feature negotiation.
		 */
		public function get features():Array
		{
			return _features;
		}
		public function set features( value:Array ):void
		{
			_features = value;
		}

		override public function set xml( node:XML ):void
		{
			super.xml = node;
			

			_identities = [];
			_features = [];

			for each( var child:XML in xml.children() )
			{
				switch( child.localName() )
				{
					case "identity":
						var identity:DiscoIdentity = new DiscoIdentity( xml );
						identity..xml = child;
						_identities.push( identity );
						break;

					case "feature":
						var feature:DiscoFeature = new DiscoFeature( xml );
						feature.xml = child;
						_features.push( feature );
						break;
				}
			}
		}

		public function addIdentity( identity:DiscoIdentity ):DiscoIdentity
		{
			_identities.push( identity );
			return identity;
		}

		public function addFeature( feature:DiscoFeature ):DiscoFeature
		{
			_features.push( feature );
			return feature;
		}

		public function addFeatures( varNames:Array ):Array
		{
			var features:Array = [];
			for each( var varName:String in varNames )
			{
				var feature:DiscoFeature = new DiscoFeature();
				feature.varName = varName;
				features.push( feature );
			}
			_features = _features.concat( features );
			return features;
		}

	}
}
