package com.yourpalmark.chat.data
{
	public class LoginCredentials
	{
		public var username:String;
		public var password:String;
		
		/**
		 * Note that the username should include @ and the server (which might not be the same as the one where the connection is made)
		 *
		 * @param	username
		 * @param	password
		 */
		public function LoginCredentials( username:String=null, password:String=null )
		{
			this.username = username;
			this.password = password;
		}
		
	}
}