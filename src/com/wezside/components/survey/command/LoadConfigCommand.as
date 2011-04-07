package com.wezside.components.survey.command 
{
	import com.wezside.utilities.command.Command;
	import com.wezside.utilities.command.CommandEvent;

	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class LoadConfigCommand extends Command 
	{
		
		[Embed( source="/../resource/xml/survey-config.xml", mimeType="application/octet-stream")]
		public static var ConfigXMLData:Class;			

		override public function execute( event:Event ):void 
		{
			super.execute( event );
			
			// For testing purposes
			var data:ByteArray = new ConfigXMLData();
			var str:String = data.readUTFBytes( data.length );
			var surveyXML:XML = new XML( str );
			dispatchEvent( new CommandEvent( CommandEvent.COMPLETE, false, false, "", false, surveyXML ));	
		}
	}
}
