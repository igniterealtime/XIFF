package org.igniterealtime.xiff.logging
{
  import mx.controls.TextArea;
  import mx.core.mx_internal;
  import mx.logging.targets.LineFormattedTarget;

  use namespace mx_internal;
  
  public class TextAreaTarget extends LineFormattedTarget
  {
    private var textArea:TextArea;

    public function TextAreaTarget( textArea:TextArea )
    {
      super();

      this.textArea = textArea;
    }

    override mx_internal function internalLog( message:String ):void
    {
      textArea.text += message + "\n";
    }
  }
}
