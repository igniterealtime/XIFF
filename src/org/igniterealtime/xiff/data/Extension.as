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
package org.igniterealtime.xiff.data
{

	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.XMLStanza;


	/**
	 * This is a base class for all data extensions.
	 * @see http://xmpp.org/registrar/namespaces.html
	 * @see http://xmpp.org/extensions/
	 */
	public class Extension extends XMLStanza
	{
		/**
		 *
		 * @param	parent The parent node that this extension should be appended to
		 */
		public function Extension( parent:XML = null )
		{
			super();
			
			var ns:Namespace = new Namespace(null, IExtension(this).getNS());

			xml.setLocalName( IExtension(this).getElementName() );
			xml.setNamespace( ns );

			if (parent != null)
			{
				parent.appendChild(xml);
			}
		}

		/**
		 * Removes the extension from its parent.
		 */
		public function remove():void
		{
			var parent:XML = xml.parent();
			if (parent != null)
			{
				var index:int = parent.child(this).childIndex();
				delete parent[index];
			}
		}

		/**
		 * Override in order to take care of setting the Namespace and
		 * checking for containing extensions.
		 */
		override public function set xml( value:XML ):void
		{
			super.xml = value;

			xml.setNamespace( IExtension(this).getNS() );

			// Since many of the extensions operate in a way that they contain some other extensions, check for that..
			for each (var child:XML in value.children())
			{
				var ns:Namespace = child.namespace();
				if (ns != null)
				{
					var extClass:Class = ExtensionClassRegistry.lookup(ns.uri, child.localName());
					if (extClass != null)
					{
						var ext:IExtension = new extClass() as IExtension;
						ext.xml = child;
						addExtension(ext);
					}

				}
			}
		}
	}
}
