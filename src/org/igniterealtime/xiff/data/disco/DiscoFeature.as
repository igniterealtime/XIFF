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
	import org.igniterealtime.xiff.data.INodeProxy;
	import org.igniterealtime.xiff.data.XMLStanza;

	
	/**
	 * @see http://xmpp.org/extensions/xep-0030.html
	 */
	public class DiscoFeature extends XMLStanza implements INodeProxy
	{
		public static const ELEMENT_NAME:String = "feature";

		/**
		 *
		 * @param	parent
		 */
		public function DiscoFeature( parent:XML=null )
		{
			super();

			xml.setLocalName( ELEMENT_NAME );

			if( parent != null )
			{
				parent.appendChild( xml );
			}
		}

		public function equals( other:DiscoFeature ):Boolean
		{
			return varName == other.varName;
		}

		/**
                 * The var of this feature used by the application or server.
                 * In most cases this is the namespace of the given feature/extension.
		 *
                 * <p>Note: This serializes to the <code>var</code> attribute on the feature node.</p>
                 *
                 * <p>Since <code>var</code> is a reserved word in ActionScript,
                 * this feature uses <code>varName</code> to describe the var of this feature.</p>
		 *
		 */
		public function get varName():String
		{
			return getAttribute("var");
		}
		public function set varName( value:String ):void
		{
			setAttribute("var", value);
		}

	}
}
