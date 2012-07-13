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
package org.igniterealtime.xiff.data.forms.enum
{
	/**
	 * Four different types of form that can exist according to XEP-0004.
	 *
	 * @see http://xmpp.org/extensions/xep-0004.html#protocol-formtypes
	 */
	public class FormType
	{
		/**
		 * The form-processing entity is asking the form-submitting entity to complete a form.
		 */
		public static const FORM:String = "form";
		
		/**
		 * The form-submitting entity is submitting data to the form-processing entity.
		 * The submission MAY include fields that were not provided in the empty form,
		 * but the form-processing entity MUST ignore any fields that it does not understand.
		 */
		public static const SUBMIT:String = "submit";
		
		/**
		 * The form-submitting entity has cancelled submission of data
		 * to the form-processing entity.
		 */
		public static const CANCEL:String = "cancel";
		
		/**
		 * The form-processing entity is returning data (e.g., search results) to
		 * the form-submitting entity, or the data is a generic data set.
		 */
		public static const RESULT:String = "result";

	}
}
