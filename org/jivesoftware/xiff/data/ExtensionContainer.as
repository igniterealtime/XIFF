package org.jivesoftware.xiff.data{
	/*
	 * Copyright (C) 2003-2004 
	 * Sean Voisen <sean@mediainsites.com>
	 * Sean Treadway <seant@oncotype.dk>
	 * Media Insites, Inc.
	 *
	 * This library is free software; you can redistribute it and/or
	 * modify it under the terms of the GNU Lesser General Public
	 * License as published by the Free Software Foundation; either
	 * version 2.1 of the License, or (at your option) any later version.
	 * 
	 * This library is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	 * Lesser General Public License for more details.
	 * 
	 * You should have received a copy of the GNU Lesser General Public
	 * License along with this library; if not, write to the Free Software
	 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
	 *
	 */
	
	import org.jivesoftware.xiff.data.IExtension;
	import org.jivesoftware.xiff.data.IExtendable;
	 
	/**
	 * Contains the implementation for a generic extension container.  Use the static method "decorate" to implement the IExtendable interface on a class.
	 *
	 * @author Sean Treadway
	 * @since 2.0.0
	 * @availability Flash Player 7
	 * @toc-path Data
	 * @toc-sort 1
	 */
	//public class ExtensionContainer implements IExtendable
	public class ExtensionContainer
	{
		//public static var _fExtensionContainer:ExtensionContainer = undefined;
		//public static var _exts:String = "__e_";
		
		public static var _exts:Object;
		/*
		public static function decorate(proto:Object):void
		{
			if (_fExtensionContainer == null) {
			//if (_fExtensionContainer == undefined) {
				_fExtensionContainer = new ExtensionContainer();
			}
			proto.addExtension = _fExtensionContainer.addExtension;
			proto.getAllExtensionsByNS = _fExtensionContainer.getAllExtensionsByNS;
			proto.getAllExtensions = _fExtensionContainer.getAllExtensions;
			proto.removeExtension = _fExtensionContainer.removeExtension;
			proto.removeAllExtensions = _fExtensionContainer.removeAllExtensions;
		}
		*/
		 
		public static function addExtension( ext:IExtension ):IExtension
		{
			
			if (_exts == null) {
				_exts = new Object();
				//this["setPropertyIsEnumerable"]("_exts",false);
				//_global.ASSetPropFlags(this, _exts, 1);
			}
			if ([_exts][ext.getNS()] == null) {
				_exts[ext.getNS()] = new Array();
			}
	
			_exts[ext.getNS()].push(ext);
			return ext;
		}
	
		public static function removeExtension( ext:IExtension ):Boolean
		{	
			var extensions:Array = _exts[ext.getNS()];
			for (var i:String in extensions) {
			//for (var i in extensions) { untyped var throws compiler warning
				if (extensions[i] === ext) {
					extensions[i].remove();
					extensions.splice(Number(i), 1);
					return true;
				}
			}
			return false;
		}
		public static function removeAllExtensions( ns:String ):void
		{
			for (var i:String in _exts[ns]) {
				_exts[ns][i].remove();
			}
			_exts[ns] = new Array();
		}
	
		public static function getAllExtensionsByNS( ns:String ):Array
		{
			return _exts[ns];
		}
	
		public static function getAllExtensions():Array
		{
			var exts:Array = new Array();
			for (var ns:String in _exts) {
			//for (var ns in this[_exts]) {
				exts = exts.concat(_exts[ns]);
			}
			return exts;
		}
	}
}