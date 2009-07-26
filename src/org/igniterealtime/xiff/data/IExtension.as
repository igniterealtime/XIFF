/*
 * License
 */
package org.igniterealtime.xiff.data
{
	/**
	 * The interface describing an extension.  All extensions must implement this interface.
	 */
	public interface IExtension
	{
		function getNS():String;
		function getElementName():String;
	}
}