/*
 * License
 */
package org.igniterealtime.xiff.data
{

	/**
	 * An interface for objects that abstract XML data by providing accessors
	 * to the original XML data stored within.
	 */
	import flash.xml.XMLNode;

	public interface INodeProxy
	{
		/**
		 * Gets the XML node that is being abstracted.
		 *
		 */
		function getNode():XMLNode;
		
		/**
		 * Sets the XML node that will be abstracted.
		 *
		 */
		function setNode( node:XMLNode ):Boolean;
	}
}