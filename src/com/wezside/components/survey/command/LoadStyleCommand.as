package com.wezside.components.survey.command
{
	import com.wezside.components.survey.Survey;
	import com.wezside.components.survey.SurveyEvent;
	import com.wezside.components.survey.data.IFormData;
	import com.wezside.components.survey.data.IFormGroupData;
	import com.wezside.components.survey.data.IFormItemData;
	import com.wezside.components.survey.data.IFormMetaData;
	import com.wezside.components.survey.data.ISurveyData;
	import com.wezside.components.survey.data.config.CSSData;
	import com.wezside.components.survey.data.config.LayoutData;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.data.mapping.XMLDataMapper;
	import com.wezside.utilities.command.Command;
	import com.wezside.utilities.command.CommandEvent;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.style.IStyleManager;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class LoadStyleCommand extends Command 
	{
		private static const DEBUG : Boolean =false;
		private var data:*;
		private var surveyCSSData:ICollection;
		private var layoutData:ICollection;
		private var styleNS:Namespace;
		private var styleID:String;
		private var ignoreMapper : XMLDataMapper;
		private var loader : Loader;
		private var locale : String;
		private var styleSuffix : String;

		override public function execute( event:Event ):void 
		{
			super.execute( event );
			data = SurveyEvent( event ).data;
			loadStyle();
			
		}

		private function loadStyle() : void {
			surveyCSSData = data.surveyCSSData as ICollection;
			layoutData =  data.layoutData as ICollection;
			ignoreMapper =  data.ignoreMapper as XMLDataMapper;
			styleNS = data.styleNS as Namespace;
			styleID = String( data.styleID );			
			if(!locale)locale=String(data.locale);
			styleSuffix=String(data.styleURLSuffix);
			if(data.url!=Survey.DEFAULT_STYLE)data.url+=locale+styleSuffix;
			
			purgeLoader();
			if ( data.url ) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, complete );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				debug(data.url);
//				trace();
				loader.load( new URLRequest( data.url) );
			}
			else {
				
				error();
			}
		}
		private function debug(value:String):void{
			if(DEBUG)
			{
				if (ExternalInterface.available) 
				{
				ExternalInterface.call("debug",value);
				}
			}
		}
		private function purgeLoader() : void {
			if ( loader ) {
				if ( loader.contentLoaderInfo ) {
					loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, complete );
					loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
					loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				}
				try { loader.close(); }
				catch ( error : Error ) {}
				loader = null;
			}
		}
		
		private function complete( event:Event ):void 
		{
			debug(" complete: "+data.styleNS );
			var qName:String = Namespace( data.styleNS ).uri + "." + styleID;  
			var Styles:Class = event.target.applicationDomain.getDefinition( qName ) as Class;
			debug(" styleManager.ready" );
			var styleManager : IStyleManager = new Styles() as IStyleManager;
			if ( styleManager.ready ) {
				debug(" styleManager.ready" );
				setupStyleManaqer( styleManager );
			}
			else {
				debug(" styleManager.not ready" );
				styleManager.addEventListener( Event.COMPLETE, styleInitComplete );
			}
		}
		
		private function onIOError( event : IOErrorEvent ):void 
		{
			Tracer.output( Tracer.DEBUG, " onIOError: " + event.text, getQualifiedClassName(this), Tracer.ERROR );
			debug(" onIOError: " );
			
			if(locale==Survey.DEFAULT_LOCALE)
			{
				error();
			}else{
				locale=Survey.DEFAULT_LOCALE;
				loadStyle();
			}
			
		}
		
		private function onSecurityError( event : SecurityErrorEvent ):void 
		{
			Tracer.output( Tracer.DEBUG, " onSecurityError: " + event.text, getQualifiedClassName(this), Tracer.ERROR );
			debug(" onIOError: " );
			error();
		}
		
		private function error():void 
		{
			purgeLoader();
			
			var stlyeClass:Class = getDefinitionByName( styleNS + "::" + styleID ) as Class;
			var styleManager:IStyleManager = new stlyeClass();
			if ( styleManager.ready ) {
				setupStyleManaqer( styleManager );
			}
			else {
				styleManager.addEventListener( Event.COMPLETE, styleInitComplete );
			}
		}
		
		private function styleInitComplete( event : Event ): void {
			debug(" styleInitComplete: " );
			setupStyleManaqer( IStyleManager( event.target ) );
		}
		
		private function setupStyleManaqer( styleManager : IStyleManager ) : void {
			
			// Assign styles to all data objects
			var surveyData:ISurveyData = data.parser.data;
			var surveyIterator:IIterator = surveyData.iterator;
			
			// Loop through Form Data and inject style names and set any layout decorators defined in config
			while ( surveyIterator.hasNext() )
			{
				var formData:IFormData = surveyIterator.next() as IFormData;
				var layoutdata:LayoutData = layoutData.find( "id", formData.id ) as LayoutData;
				var formCSSData:CSSData = surveyCSSData.find( "id", formData.id ) as CSSData;
				formData.styleManager = styleManager;				
				formData.styleNameCollection = formCSSData ? formCSSData.css : null;
				formData.layoutDecorators = layoutdata ? layoutdata.decorators : null;
				
				// Loop through Group Data and inject style names
				var formIterator:IIterator = formData.iterator;
				while ( formIterator.hasNext() )
				{
					var groupData:IFormGroupData = formIterator.next() as IFormGroupData;
					var groupCSSData:CSSData = surveyCSSData.find( "id", groupData.id ) as CSSData;
					groupData.styleManager = styleManager;
					groupData.styleNameCollection = groupCSSData ? groupCSSData.css : null;
					layoutdata = layoutData.find( "id", groupData.id ) as LayoutData;
					groupData.layoutDecorators = layoutdata ? layoutdata.decorators : formData.layoutDecorators ? formData.layoutDecorators : null;
					
					// Loop through Form Items and inject style names
					var groupIterator:IIterator = groupData.iterator;					
					while ( groupIterator.hasNext() )
					{						
						var formItemData:IFormItemData = groupIterator.next() as IFormItemData;
						var formItemCSSData:CSSData = surveyCSSData.find( "id", formItemData.id ) as CSSData;
						formItemData.styleManager = styleManager;
						formItemData.styleNameCollection = formItemCSSData ? formItemCSSData.css : groupCSSData ? groupCSSData.css : formCSSData ? formCSSData.css: null;						
					}
					groupIterator.purge();
				}
				formIterator.purge();
				
				// Loop through Meta data and inject style names
				var metaIterator:IIterator = formData.metaIterator;
				while ( metaIterator.hasNext() )
				{
					var metaData:IFormMetaData = metaIterator.next() as IFormMetaData;
					var metaCSSData:CSSData = surveyCSSData.find( "id", metaData.id ) as CSSData;
					metaData.styleManager = styleManager;
					metaData.styleNameCollection = metaCSSData ? metaCSSData.css : groupCSSData ? groupCSSData.css : formCSSData ? formCSSData.css: null;							
				}
				metaIterator.purge();
			}			
			surveyIterator.purge();			
			
			Tracer.output( Tracer.DEBUG, " styleInitComplete(event)", getQualifiedClassName(this), Tracer.INFO );
			
			purgeLoader();
			
			dispatchEvent( new CommandEvent( CommandEvent.COMPLETE, false, false, "", false, { styleManager: styleManager, ignoreMapper: ignoreMapper }));	
		}
	}
}
