package org.jivesoftware.xiff.logging
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
  import mx.logging.targets.LineFormattedTarget;
  import mx.controls.TextArea;
	
	public final class LoggerFactory
	{
		static public function configureDefault( filters:Array, level:int ):void
		{
			configureTarget( new TraceTarget(), filters, level );
		}

    static public function configureTextAreaTarget( textArea:TextArea, filters:Array, level:int ):void
    {
      configureTarget( new TextAreaTarget( textArea ), filters, level );
    }

    static private function configureTarget( logTarget:LineFormattedTarget, filters:Array, level:int ):void
    {
      logTarget.filters = new Array(["org.jivesoftware.*"]).concat(filters);
			logTarget.level = level;
			logTarget.includeTime = true;
			logTarget.includeLevel = true;

			Log.addTarget(logTarget);
    }
		
		static public function getLogger(category:String):ILogger
		{
			return Log.getLogger(category);
		}
	}
}
