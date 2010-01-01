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
package org.igniterealtime.xiff.data
{
	import org.igniterealtime.xiff.data.*;

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

			node = <{ IExtension( this ).getElementName() }/>;
			node.setNamespace( IExtension( this ).getNS() );

			if ( exists( parent ))
			{
				parent.appendChild( node );
			}
		}

		/**
		 * Removes the extension from its parent.
		 */
		public function remove():void
		{
			if (node.parent() != undefined)
			{
				delete node.parent().child(node.name())[0];
			}
		}

		/**
		 * Converts the extension stanza XML to a string.
		 *
		 * @return The extension XML in string form
		 */
		public function toString():String
		{
			return node.toString();
		}
	}
}
