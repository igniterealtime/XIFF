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
package org.igniterealtime.xiff.core
{
	import flash.events.*;

	import org.igniterealtime.xiff.events.*;
	import org.igniterealtime.xiff.data.*;
	import org.igniterealtime.xiff.data.forms.FormExtension;
	import org.igniterealtime.xiff.data.register.RegisterExtension;

	/**
	 * Dispatched when a password change is successful.
	 *
	 * @eventType org.igniterealtime.xiff.events.ChangePasswordSuccessEvent.PASSWORD_SUCCESS
	 */
	[Event( name="changePasswordSuccess", type="org.igniterealtime.xiff.events.ChangePasswordSuccessEvent" )]
	/**
	 * Dispatched on when new user account registration is successful.
	 *
	 * @eventType org.igniterealtime.xiff.events.RegistrationSuccessEvent.REGISTRATION_SUCCESS
	 */
	[Event( name="registrationSuccess", type="org.igniterealtime.xiff.events.RegistrationSuccessEvent" )]
	/**
	 * Dispatched on when new user account registration is successful.
	 *
	 * @eventType org.igniterealtime.xiff.events.RegistrationFieldsEvent.REG_FIELDS
	 */
	[Event( name="registrationFields", type="org.igniterealtime.xiff.events.RegistrationFieldsEvent" )]

	/**
	 * Manager for XEP-0077: In-Band Registration
	 *
	 * <p>Once the connection has been established and the server has provided feature
	 * information, check <code>XMPPConnection.registrationSupported</code> before trying to use
	 * the registration.</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0077.html
	 */
	public class InBandRegistrator extends EventDispatcher
	{
		private var _connection:IXMPPConnection;

		/**
		 * Manage client registration and password changing.
		 *
		 * @param	aConnection A reference to the <code>XMPPConnection</code> instance to use.
		 */
		public function InBandRegistrator( aConnection:IXMPPConnection = null )
		{
			if ( aConnection != null )
			{
				connection = aConnection;
			}
		}




		/**
		 * Changes the user's account password on the server. If the password change is successful,
		 * the class will broadcast a <code>ChangePasswordSuccessEvent.PASSWORD_SUCCESS</code> event.
		 *
		 * @param	newPassword The new password
		 */
		public function changePassword( newPassword:String ):void
		{
			var passwordIQ:IQ = new IQ( new EscapedJID( _connection.domain ), IQ.TYPE_SET,
				IQ.generateID( "pswd_change_" ), changePassword_response );
			var ext:RegisterExtension = new RegisterExtension( passwordIQ.xml );
			ext.username = _connection.jid.escaped.bareJID;
			ext.password = newPassword;

			passwordIQ.addExtension( ext );
			_connection.send( passwordIQ );
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function changePassword_response( iq:IQ ):void
		{
			if ( iq.type == IQ.TYPE_RESULT )
			{
				var event:ChangePasswordSuccessEvent = new ChangePasswordSuccessEvent();
				dispatchEvent( event );
			}
			else
			{
				// We weren't expecting this
				//dispatchError( "unexpected-request", "Unexpected Request", "wait", 400 );
			}
		}

		/**
		 * Issues a request for the information that must be submitted for registration with the server.
		 * When the data returns, a <code>RegistrationFieldsEvent.REG_FIELDS</code> event is dispatched
		 * containing the requested data.
		 */
		public function getRegistrationFields():void
		{
			var regIQ:IQ = new IQ( new EscapedJID( _connection.domain ), IQ.TYPE_GET,
				IQ.generateID( "reg_info_" ), getRegistrationFields_response );
			regIQ.addExtension( new RegisterExtension( regIQ.xml ) );

			_connection.send( regIQ );
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function getRegistrationFields_response( iq:IQ ):void
		{
			var ext:RegisterExtension = iq.getAllExtensionsByNS( RegisterExtension.NS )[ 0 ];

			trace("getRegistrationFields_response. iq: " + iq);

			var event:RegistrationFieldsEvent = new RegistrationFieldsEvent();
			event.fields = ext.getRequiredFieldNames();
			event.data = ext;

			dispatchEvent( event );
		}

		/**
		 * Registers a new account with the server, sending the registration data as specified in the fieldMap@paramter.
		 *
		 * @param	fieldMap An object map containing the data to use for registration. The map should be composed of
		 * 			attribute:value pairs for each registration data item.
		 * @param	key This element is obsolete, but is included here for historical completeness.
		 */
		public function sendRegistrationFields( fieldMap:Object, key:String = null ):void
		{
			var regIQ:IQ = new IQ( new EscapedJID( _connection.domain ), IQ.TYPE_SET,
				IQ.generateID( "reg_attempt_" ), sendRegistrationFields_response );
			var ext:RegisterExtension = new RegisterExtension( regIQ.xml );

			for ( var i:String in fieldMap )
			{
				if (fieldMap.hasOwnProperty(i))
				{
					ext.setField( i, fieldMap[ i ] );
				}
			}

			if ( key != null )
			{
				ext.key = key;
			}

			regIQ.addExtension( ext );
			_connection.send( regIQ );
		}

		/**
		 * @private
		 *
		 * @param	iq
		 */
		protected function sendRegistrationFields_response( iq:IQ ):void
		{
			if ( iq.type == IQ.TYPE_RESULT )
			{
				var event:RegistrationSuccessEvent = new RegistrationSuccessEvent();
				dispatchEvent( event );
			}
			else
			{
				// We weren't expecting any other type than "result"...
				//dispatchError( "unexpected-request", "Unexpected Request", "wait", 400 );
			}
		}

		/**
		 * The instance of the XMPPConnection class to use for sending and
		 * receiving data.
		 */
		public function get connection():IXMPPConnection
		{
			return _connection;
		}
		public function set connection( value:IXMPPConnection ):void
		{
			_connection = value;
			_connection.enableExtensions(
				RegisterExtension,
				FormExtension
			);
		}
	}

}
