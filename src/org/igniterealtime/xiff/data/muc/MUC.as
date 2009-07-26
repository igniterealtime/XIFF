/*
 * License
 */
package org.igniterealtime.xiff.data.muc{

	
	/**
	 * This class contains a series of static constants that are used throughout the
	 * multi-user conferencing extensions. The constants include the following for
	 * conference room affiliations:
	 * <ul>
	 * <li>ADMIN_AFFILIATION</li>
	 * <li>MEMBER_AFFILIATION</li>
	 * <li>NO_AFFILIATION</li>
	 * <li>OUTCAST_AFFILIATION</li>
	 * <li>OWNER_AFFILIATION</li>
	 * </ul>
	 *
	 * And the following constants for room roles:
	 * <ul>
	 * <li>MODERATOR_ROLE</li>
	 * <li>NO_ROLE</li>
	 * <li>PARTICIPANT_ROLE</li>
	 * <li>VISITOR_ROLE</li>
	 * </ul>
	 */
	
	import org.igniterealtime.xiff.data.ExtensionClassRegistry;
	import org.igniterealtime.xiff.data.muc.MUCExtension;
	import org.igniterealtime.xiff.data.muc.MUCUserExtension;
	import org.igniterealtime.xiff.data.muc.MUCOwnerExtension;
	import org.igniterealtime.xiff.data.muc.MUCAdminExtension;
	
	public class MUC
	{
		public static const ADMIN_AFFILIATION:String = "admin";
		public static const MEMBER_AFFILIATION:String = "member";
		public static const NO_AFFILIATION:String = "none";
		public static const OUTCAST_AFFILIATION:String = "outcast";
		public static const OWNER_AFFILIATION:String = "owner";
	
		public static const MODERATOR_ROLE:String = "moderator";
		public static const NO_ROLE:String = "none";
		public static const PARTICIPANT_ROLE:String = "participant";
		public static const VISITOR_ROLE:String = "visitor";
	
		private static var staticDependencies:Array = [ ExtensionClassRegistry, MUCExtension, MUCUserExtension, MUCOwnerExtension, MUCAdminExtension ];
	
	    /** 
	     * Register the multi-user chat extension capabilities with this method
	     * availability Flash Player 7
	     */
	    public static function enable():void
	    {
	        ExtensionClassRegistry.register( MUCExtension );
	        ExtensionClassRegistry.register( MUCUserExtension );
	        ExtensionClassRegistry.register( MUCOwnerExtension );
	        ExtensionClassRegistry.register( MUCAdminExtension );
	    }
	}
}