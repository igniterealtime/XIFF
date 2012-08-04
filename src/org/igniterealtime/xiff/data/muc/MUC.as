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
package org.igniterealtime.xiff.data.muc
{
	import org.igniterealtime.xiff.data.muc.*;
	
	/**
	 * This class contains a series of static constants that are used throughout the
	 * multi-user conferencing extensions.
	 *
	 * <p>The constants include the following for
	 * conference room affiliations:</p>
	 * <ul>
	 * <li>AFFILIATION_ADMIN</li>
	 * <li>AFFILIATION_MEMBER</li>
	 * <li>AFFILIATION_NONE</li>
	 * <li>AFFILIATION_OUTCAST</li>
	 * <li>AFFILIATION_OWNER</li>
	 * </ul>
	 *
	 * <p>And the following constants for room roles:</p>
	 * <ul>
	 * <li>ROLE_MODERATOR</li>
	 * <li>ROLE_NONE</li>
	 * <li>ROLE_PARTICIPANT</li>
	 * <li>ROLE_VISITOR</li>
	 * </ul>
	 *
	 * <p>Support for the owner affiliation is REQUIRED. Support for the admin, member,
	 * and outcast affiliations is RECOMMENDED. (The "None" affiliation is
	 * the absence of an affiliation.)</p>
	 *
	 * @see http://www.xmpp.org/extensions/xep-0045.html
	 */
	public class MUC
	{
		public static const AFFILIATION_ADMIN:String = "admin";
		public static const AFFILIATION_MEMBER:String = "member";
		public static const AFFILIATION_NONE:String = "none";
		public static const AFFILIATION_OUTCAST:String = "outcast";
		public static const AFFILIATION_OWNER:String = "owner";
	
		public static const ROLE_MODERATOR:String = "moderator";
		public static const ROLE_NONE:String = "none";
		public static const ROLE_PARTICIPANT:String = "participant";
		public static const ROLE_VISITOR:String = "visitor";
	}
}
