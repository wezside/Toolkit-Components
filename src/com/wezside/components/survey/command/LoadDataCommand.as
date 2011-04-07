package com.wezside.components.survey.command
{
	import com.wezside.components.survey.Survey;
	import com.wezside.components.survey.SurveyDataParser;
	import com.wezside.components.survey.SurveyEvent;
	import com.wezside.utilities.command.Command;
	import com.wezside.utilities.command.CommandEvent;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.state.StateManager;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class LoadDataCommand extends Command {
		
		private var loader : URLLoader;
		private var parser : SurveyDataParser;
		private var locale : String;
		private var data : *;
		protected var configState : StateManager;
		
		
		override public function execute( event : Event ) : void {
			super.execute( event );
			
			data = SurveyEvent( event ).data;
			locale = data ? data.locale : "";
			configState = data ? data.configState : new StateManager();
			purgeLoader();
			
			if ( data && data.url ) {
				loader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, complete );
				loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				loader.load( new URLRequest( data.url ) );
				
			}
			else {
				Tracer.output( true, " Data URL error ", getQualifiedClassName( this ), Tracer.ERROR );
			}
		}
		
		private function complete( event : Event ) : void {
			parser = new SurveyDataParser();
			parser.locale = locale;
			parser.dataprovider = XML( event.target.data );
			purgeLoader();
			
			parser.addEventListener( SurveyEvent.PARSER_COMPLETE, initializationComplete );
			parser.start();
		}
		
		private function initializationComplete( event : SurveyEvent ) : void {
			// iterate over config data
			// based on the data turn on the appropriate state, i.e. switch
			if(configState)
			{
				if(XML(parser.dataprovider).Contents[0].Content[0].Article.(@id=="Configuration").Resource.(@id=="UnitsWeight").text()=="imperialStones")
				{
					configState.stateKey = Survey.UNIT_WEIGHT_IMPERIAL;
				}else{
					configState.stateKey = Survey.UNIT_WEIGHT_METRIC;				
				}
				if(XML(parser.dataprovider).Contents[0].Content[0].Article.(@id=="Configuration").Resource.(@id=="UnitsHeight").text()=="imperial")
				{
					configState.stateKey = Survey.UNIT_HEIGHT_IMPERIAL;
				}else{
					configState.stateKey = Survey.UNIT_HEIGHT_METRIC;				
				}
				if(XML(parser.dataprovider).Contents[0].Content[0].Article.(@id=="Configuration").Resource.(@id=="UnitsCholesterol").text()=="mmol")
				{
					configState.stateKey = Survey.UNIT_CHOLESTEROL_MMOL;
				}else{
					configState.stateKey = Survey.UNIT_CHOLESTEROL_MGDL;				
				}
			}
			// Test the stateManager
			dispatchEvent( new CommandEvent( CommandEvent.COMPLETE, false, false, "", false, parser ));
		}
		
		private function onIOError( event : IOErrorEvent ) : void {
			Tracer.output( true, " onIOError: " + event.text, getQualifiedClassName( this ), Tracer.ERROR );
			purgeLoader();
		}
		
		private function onSecurityError( event : SecurityErrorEvent ) : void {
			Tracer.output( true, " onSecurityError: " + event.text, getQualifiedClassName( this ), Tracer.ERROR );
			purgeLoader();
		}
		
		private function purgeLoader() : void {
			if ( loader ) {
				loader.removeEventListener( Event.COMPLETE, complete );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				try { loader.close(); }
				catch ( error : Error ) {}
				loader = null;
			}
		}
	}
}