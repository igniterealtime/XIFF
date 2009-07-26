/*
 * License
 */
package org.igniterealtime.xiff.logging
{
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	import mx.logging.targets.LineFormattedTarget;

	use namespace mx_internal;
  
	public class TextAreaTarget extends LineFormattedTarget
	{
		private var _textArea:TextArea;

		public function TextAreaTarget( textArea:TextArea )
		{
			super();
			_textArea = textArea;
		}

		override mx_internal function internalLog( message:String ):void
		{
			_textArea.text += message + "\n";
		}
	}
}
