/*
 * License
 */
package org.igniterealtime.xiff.data
{

	
	import org.igniterealtime.xiff.data.IExtension;
	import org.igniterealtime.xiff.data.IExtendable;
	
	/**
	 * Contains the implementation for a generic extension container.
	 * Use the static method "decorate" to implement the IExtendable interface on a class.
	 */
	public class ExtensionContainer implements IExtendable
	{
		public var _exts:Object;
		
		public function ExtensionContainer(){
			_exts = {};
		}
	
		public function addExtension( ext:IExtension ):IExtension
		{
			if (_exts[ext.getNS()] == null){
				_exts[ext.getNS()] = [];
			}
			_exts[ext.getNS()].push(ext);
			return ext;
		}
	
		public function removeExtension( ext:IExtension ):Boolean
		{
			var extensions:Object = _exts[ext.getNS()];
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
		public function removeAllExtensions( ns:String ):void
		{
			//for (var i in this[_exts][namespace]) {
			for (var i:String in _exts[ns]) {
				_exts[ns][i].ns();
			}
			_exts[ns] = [];
		}
	
		public function getAllExtensionsByNS( ns:String ):Array
		{
			return _exts[ns];
		}
		
		public function getExtension( name:String ):Extension
		{
			return getAllExtensions().filter(function(obj:IExtension, idx:int, arr:Array):Boolean
		{ return obj.getElementName() == name; })[0];
		}
	
		public function getAllExtensions():Array
		{
			var exts:Array = [];
			for (var ns:String in _exts) {
			//for (var ns in this[_exts]) {
				exts = exts.concat(_exts[ns]);
			}
			return exts;
		}
	}
}
