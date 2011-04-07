package com.wezside.components.survey
{
	import com.wezside.components.UIElement;
	import com.wezside.components.survey.command.CustomDataCommand;
	import com.wezside.components.survey.command.LoadConfigCommand;
	import com.wezside.components.survey.command.LoadDataCommand;
	import com.wezside.components.survey.command.LoadStyleCommand;
	import com.wezside.components.survey.command.ParseIgnoreCommand;
	import com.wezside.components.survey.data.IFormMetaData;
	import com.wezside.components.survey.data.ISurveyData;
	import com.wezside.components.survey.data.SurveyData;
	import com.wezside.components.survey.data.config.CSSData;
	import com.wezside.components.survey.data.config.CSSDataItem;
	import com.wezside.components.survey.data.config.CustomFormCollectionData;
	import com.wezside.components.survey.data.config.CustomFormData;
	import com.wezside.components.survey.data.config.IgnoreData;
	import com.wezside.components.survey.data.config.ItemData;
	import com.wezside.components.survey.data.config.LayoutData;
	import com.wezside.components.survey.data.config.LayoutDecoratorData;
	import com.wezside.components.survey.data.config.MetaData;
	import com.wezside.components.survey.data.config.MetaSetting;
	import com.wezside.components.survey.data.config.ProgressBarData;
	import com.wezside.components.survey.data.config.ProgressBarItem;
	import com.wezside.components.survey.data.config.grouping.ResponseData;
	import com.wezside.components.survey.data.config.grouping.ResponseGroupData;
	import com.wezside.components.survey.data.config.grouping.ResponseGroupingData;
	import com.wezside.components.survey.data.router.SurveyRouter;
	import com.wezside.components.survey.data.ui.UIData;
	import com.wezside.components.survey.data.ui.UIItemData;
	import com.wezside.components.survey.form.FormEvent;
	import com.wezside.components.survey.form.item.CallToAction;
	import com.wezside.components.survey.form.item.CheckBox;
	import com.wezside.components.survey.form.item.CustomInputField;
	import com.wezside.components.survey.form.item.FormLabel;
	import com.wezside.components.survey.form.item.RadioButton;
	import com.wezside.components.survey.form.item.Slider;
	import com.wezside.components.survey.ui.ISurveyMeta;
	import com.wezside.components.survey.ui.ISurveyNavigation;
	import com.wezside.components.survey.ui.ISurveyUIElement;
	import com.wezside.components.survey.ui.Meta;
	import com.wezside.components.survey.ui.Navigation;
	import com.wezside.components.survey.validate.ValidateInputField;
	import com.wezside.components.survey.validate.ValidateLinkedItems;
	import com.wezside.components.survey.validate.ValidateRadioButton;
	import com.wezside.data.collection.DictionaryCollection;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.collection.IDictionaryCollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.data.mapping.XMLDataMapper;
	import com.wezside.utilities.command.CommandEvent;
	import com.wezside.utilities.command.CommandMapper;
	import com.wezside.utilities.flashvars.FlashVars;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.state.StateManager;
	import com.wezside.utilities.manager.style.IStyleManager;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class Survey extends UIElement
	{
		public static const DEFAULT_LOCALE:String = "en-MS";
		private static const COMMAND_LOAD_CONFIG:String = "LoadConfigCommand";
		private static const DEFAULT_DATA_URL:String = "./resources-en-MS/xml/survey-data.xml";
		public static const DEFAULT_STYLE : String = "./resources-en-MS/swf/style.swf";
		public static const UNIT_WEIGHT_METRIC : String = "UNIT_WEIGHT_METRIC";
		public static const UNIT_WEIGHT_IMPERIAL : String = "UNIT_WEIGHT_IMPERIAL";
		public static const UNIT_HEIGHT_METRIC : String = "UNIT_HEIGHT_METRIC";
		public static const UNIT_HEIGHT_IMPERIAL : String = "UNIT_HEIGHT_IMPERIAL";
		public static const UNIT_CHOLESTEROL_MMOL : String = "UNIT_CHOLESTEROL_MMOL";
		public static const UNIT_CHOLESTEROL_MGDL : String = "UNIT_CHOLESTEROL_MGDL";
		protected var dataClass:Class;
		protected var controller:SurveyController;
		protected var commands:CommandMapper;
		protected var flashVars:FlashVars;
		protected var parser:SurveyDataParser;
		protected var navigation:ISurveyNavigation;
		protected var meta:ISurveyMeta;
		protected var namespaceCollection:IDictionaryCollection;
		protected var configState : StateManager;
		private var commandNS:Namespace = new Namespace( "", "com.wezside.components.survey.command" );
		private var styleNS:Namespace;
		private var uiNS:Namespace;
		private var formNS:Namespace;
		private var customCommandNS:Namespace;
		protected var locale:String;
		private var configURL:String;
		protected var dataURL:String;
		private var styleURL:String;
		private var configXML:XML;
		private var ignoreCollection:ICollection;
		private var customUICollection:ICollection;
		private var cssCollection:ICollection;
		private var customFormCollection:ICollection;
		private var metadataSettingsCollection:ICollection;
		private var _navigationDepth:int;
		private var _formDepth:int;
		private var _metaDepth : int;
		
		protected var deeplink : Number;
		private var styleURLSuffix : String="/swf/style.swf";
		
		public function Survey()
		{
			dataClass = SurveyData;

			_metaDepth = -1;
			_formDepth = -1;
			_navigationDepth = -1;
			configState = new StateManager();
			configState.addState( UNIT_WEIGHT_METRIC, true );
			configState.addState( UNIT_WEIGHT_IMPERIAL, true );
			configState.addState( UNIT_HEIGHT_METRIC, true );
			configState.addState( UNIT_HEIGHT_IMPERIAL, true );
			configState.addState( UNIT_CHOLESTEROL_MMOL, true );
			configState.addState( UNIT_CHOLESTEROL_MGDL, true );
			namespaceCollection = new DictionaryCollection();
			
			super();

			if ( stage )
			{
				stageInit( null );
			}
			else
			{
				addEventListener( Event.ADDED_TO_STAGE, stageInit );
			}
		}

		public function getButton( id:String ):UIElement
		{
			return navigation ? navigation.getButton( id ) : null;
		}

		override public function build():void
		{
			super.build();
			buildfixedElements();
			addChildAt( controller, _formDepth == -1 ? this.numChildren - 1 : _formDepth );
			if ( navigation ) addChildAt( navigation as UIElement, _navigationDepth == -1 ? this.numChildren - 1 : _navigationDepth );
			if ( meta ) addChildAt( meta as UIElement, _metaDepth == -1 ? this.numChildren - 1 : _metaDepth );
			onStageResize( null );
			Tracer.output( true, " Survey.build()", getQualifiedClassName( this ) );
		}

		protected function buildfixedElements():void
		{
			// don't create fixed elements more than once
			// FIXME this is a hack, the logic in the engine is wrong
			// at the moment it's recreating all the fixed UIElements and reloading the stylemanager
			// when user clicks restart button
			if ( navigation || meta ) return;

			// Build Fixed UI Elements like Headers, Footers, Logos, Navigation
			var uiData:UIData = customUICollection.iterator().next() as UIData;
			if ( uiData )
			{
				var uiIterator:IIterator = uiData.items.iterator();
				while ( uiIterator.hasNext() )
				{
					var uiDataItem:UIItemData = uiIterator.next() as UIItemData;
					var uiElementClass:Class = getSurveyUIElementClass( uiDataItem.id ) as Class;
					if ( uiElementClass )
					{
						var uiElement:ISurveyUIElement = new uiElementClass() as ISurveyUIElement;
						addChild( uiElement as UIElement );

						// FIXME should give elements data objects instead of entire parser

						// Search for custom CSS declarations for this fixed UI Element and assign collection
						var uiCSSCollection:CSSData = cssCollection.find( "id", uiDataItem.cssID ) as CSSData;
						uiElement.parser = parser;
						uiElement.styleManager = styleManager;
						uiElement.styleNameCollection = uiCSSCollection ? uiCSSCollection.css : null;
						uiElement.hiddenFormIDCollection = uiDataItem.hiddenIDCollection;
						uiElement.addEventListener( SurveyEvent.NAVIGATE, navigationChange );
						uiElement.build();
						uiElement.setStyle();
						uiElement.arrange();

						if ( uiElement is ISurveyNavigation ) navigation = uiElement as ISurveyNavigation;
						if ( uiElement is ISurveyMeta ) meta = uiElement as ISurveyMeta;
					}
				}
			}
		}

		protected function init():void
		{
			// Initialise command mapper
			commands = new CommandMapper();

			// Check FlashVars for config file
			flashVars = new FlashVars( this.loaderInfo.parameters );
			//check flash vars for deeplink, if deeplink equal to 1 call deeplink function
			deeplink = Number(flashVars.getValue( "deeplink" ));
			// Get locale in the format lc-CC
			locale = flashVars.getValue( "locale" ) ? flashVars.getValue( "locale" ) : DEFAULT_LOCALE;
//			configURL = flashVars.getValue( "config" );
			var hostedUrl:String =flashVars.getValue( "hostUrl" )+"/flash"?flashVars.getValue( "hostUrl" ):"";
			configURL = hostedUrl?hostedUrl+"/flash/resources-" + locale + "/xml/survey-config.xml":"resources-"+locale+"/xml/survey-config.xml";

			
			dataURL = hostedUrl ? "/flash/resources-" + locale + "/xml/survey-data.xml" : DEFAULT_DATA_URL;
			if ( Capabilities.playerType == "StandAlone" )dataURL = DEFAULT_DATA_URL;
			styleURL = hostedUrl ? hostedUrl+"/flash/resources-" : DEFAULT_STYLE;

//			styleURL = locale ? "resources-el-GR/swf/style.swf" : DEFAULT_STYLE;

			// Override default config if flashvar was specified
			if ( configURL && configURL != "" )
			{
				// Load config and parse
				var loader:URLLoader = new URLLoader();
				loader.addEventListener( Event.COMPLETE, configEventLoadComplete );
				loader.addEventListener( IOErrorEvent.IO_ERROR, styleError );
				loader.load( new URLRequest( configURL ));
			}
			else
			{				
				// Start the command execution process for using default configuration
				commands.addCommand( SurveyEvent.LOAD_CONFIG, getCommandClass( commandNS, COMMAND_LOAD_CONFIG ) );
				commands.addEventListener( CommandEvent.COMPLETE, configLoadComplete );
				commands.dispatchEvent( new SurveyEvent( SurveyEvent.LOAD_CONFIG, false, false, { locale:this.locale, config:configURL } ) );
			}
		}


		private function configEventLoadComplete(event : Event) : void {
			URLLoader(event.target).removeEventListener( Event.COMPLETE, configEventLoadComplete );
			URLLoader(event.target).removeEventListener( IOErrorEvent.IO_ERROR, error );
			configLoadComplete(new CommandEvent(CommandEvent.COMPLETE, false, false, "",false,URLLoader(event.target).data));
		}

		protected function classIncludes():void
		{
			LoadConfigCommand;
			LoadDataCommand;
			CustomDataCommand;
			LoadStyleCommand;
			ParseIgnoreCommand;
			
			CheckBox;
			Slider;
			FormLabel;
			CustomInputField;
			RadioButton;
			CallToAction;
			ValidateInputField;
			ValidateRadioButton;
			ValidateLinkedItems;
			Navigation;
			Meta;
		}

		protected function stageInit( event:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, stageInit );
			stage.addEventListener( Event.RESIZE, onStageResize );
			init();
		}

		protected function onStageResize( event:Event ):void
		{
			// resize fixed elements
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			while ( it.hasNext() )
			{
				var child:* = it.next();
				if ( child is ISurveyUIElement )
				{
					ISurveyUIElement( child ).resize();
					ISurveyUIElement( child ).arrange();
				}
			}
			it.purge();
			it = null;

			// resize current form
			if ( controller && controller.currentForm )
			{
				controller.currentForm.resize();
				controller.currentForm.arrange();

				var rect:Rectangle = new Rectangle();
				rect.x = controller.currentForm.x;
				rect.y = controller.currentForm.y;
				rect.width = controller.currentForm.width;
				rect.height = controller.currentForm.height;
								
				// update Meta layout
				if ( meta ) meta.updateLayout( rect );
				
				updateNavigation();
			}
		}

		public function updateNavigation( event:FormEvent = null ):void
		{
			var rect:Rectangle;
			if ( !event || !event.data )
			{
				rect = new Rectangle();
				rect.x = controller.currentForm.x;
				rect.y = controller.currentForm.y;
				rect.width = controller.currentForm.width;
				rect.height = controller.currentForm.height;
			}
			else 
				rect = event.data;
				
			// Update Navigation layout
			if ( navigation )
			{
				navigation.updateLayout( rect );
			}
		}

		/**
		 * This method assumes successful load of all external data and assets required. This includes:
		 * 	o Survey Data
		 * 	o Styles
		 * 	o Images/SWFs
		 */
		protected function initializationComplete():void
		{
			addEventListener( FormEvent.ITEM_STATE_CHANGE, onCallToActionClicked );

			var router:SurveyRouter = new SurveyRouter( XML( parser.dataprovider.Routing ) );
			router.build();
			controller = new SurveyController();
			controller.formNS = formNS;
			controller.configState=configState;
			controller.customFormCollection = CustomFormCollectionData( customFormCollection.find( "id", "custom" ) ).customForm;
			controller.addEventListener( SurveyEvent.VALIDATION_COMPLETE, validationComplete );
			controller.addEventListener( SurveyEvent.SURVEY_END, onSurveyEnd );
			controller.addEventListener( FormEvent.SHOW_FORM_COMPLETE, onShowFormComplete );
			controller.addEventListener( FormEvent.HIDE_FORM_COMPLETE, onHideFormComplete );
			controller.addEventListener( FormEvent.SHOW_FORM, onShowForm );
			controller.addEventListener( FormEvent.HIDE_FORM, onHideForm );
			controller.addEventListener( FormEvent.RESIZE, onFormResized );
			controller.addEventListener( FormEvent.NAV_UPDATE, updateNavigation );
			controller.addEventListener( SurveyEvent.SURVEY_RESTART, onSurveyRestart );
			controller.debug = false;
			controller.data = parser.data;
			controller.styleManager = styleManager;
			controller.router = router;
			controller.build();
			controller.setStyle();
			controller.arrange();
			addChild( controller );
			if(deeplink==1)
			{
			}else{
				build();
				start();
			}
		}

		
		private function onSurveyRestart( event:SurveyEvent ):void
		{
			controller.removeEventListener( SurveyEvent.VALIDATION_COMPLETE, validationComplete );
			controller.removeEventListener( SurveyEvent.SURVEY_END, onSurveyEnd );
			controller.removeEventListener( FormEvent.SHOW_FORM_COMPLETE, onShowFormComplete );
			controller.removeEventListener( FormEvent.HIDE_FORM_COMPLETE, onHideFormComplete );
			controller.removeEventListener( FormEvent.SHOW_FORM, onShowForm );
			controller.removeEventListener( FormEvent.HIDE_FORM, onHideForm );
			controller.removeEventListener( FormEvent.RESIZE, onFormResized );
			controller.removeEventListener( SurveyEvent.SURVEY_RESTART, onSurveyRestart );
			controller.purge();
			removeChild( controller );
			controller = null;
			parser.start();
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
			restartSurvey();
		}

		protected function restartSurvey():void
		{
			commands.addEventListener( CommandEvent.COMPLETE, injectCustomDataComplete );
			commands.dispatchEvent( new SurveyEvent( SurveyEvent.CUSTOM_DATA, false, false, { parser:parser,configState: configState } ) );
		}

		protected function onFormResized( event:FormEvent ):void
		{
			onStageResize( null );
		}

		protected function navigationChange( event:SurveyEvent ):void
		{
			controller.onNavigationRequest( event.data );
		}

		protected function onShowFormComplete( event:FormEvent ):void
		{
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var uiElement:*;
			while ( it.hasNext() )
			{
				uiElement = it.next();
				if ( uiElement is ISurveyUIElement )
				{
					ISurveyUIElement( uiElement ).totalForms = parser.data.iterator.length() - 1;
					ISurveyUIElement( uiElement ).history = controller.history;
					ISurveyUIElement( uiElement ).currentFormID = controller.currentFormID;
					ISurveyUIElement( uiElement ).showFormComplete();
				}
			}
			uiElement = null;
			it.purge();
		}

		protected function onHideFormComplete( event:FormEvent ):void
		{
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var uiElement:*;
			while ( it.hasNext() )
			{
				uiElement = it.next();
				if ( uiElement is ISurveyUIElement )
				{
					ISurveyUIElement( uiElement ).history = controller.history;
					ISurveyUIElement( uiElement ).currentFormID = controller.currentFormID;
					ISurveyUIElement( uiElement ).hideFormComplete();
				}
			}

			uiElement = null;
			it.purge();
			it = null;
		}

		protected function onShowForm( event:FormEvent ):void
		{
			onStageResize( null );

			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var uiElement:*;
			while ( it.hasNext() )
			{
				uiElement = it.next();
				if ( uiElement is ISurveyUIElement )
				{
					ISurveyUIElement( uiElement ).history = controller.history;
					ISurveyUIElement( uiElement ).currentFormID = controller.currentFormID;
					ISurveyUIElement( uiElement ).showForm( controller.direction );
				}
			}

			uiElement = null;
			it.purge();
			it = null;
		}

		protected function onHideForm( event:FormEvent ):void
		{
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var uiElement:*;
			while ( it.hasNext() )
			{
				uiElement = it.next();
				if ( uiElement is ISurveyUIElement )
				{
					ISurveyUIElement( uiElement ).history = controller.history;
					ISurveyUIElement( uiElement ).currentFormID = controller.currentFormID;
					ISurveyUIElement( uiElement ).hideForm( controller.direction );
				}
			}

			uiElement = null;
			it.purge();
			it = null;
		}

		protected function onCallToActionClicked( event:FormEvent ):void
		{
			if ( event.target is CallToAction )
			{
				if ( meta )
				{
					var data:IFormMetaData = controller.currentForm.data.getMetaData( CallToAction( event.target ).data.id );
					meta.updateContent( data );
				}
			}
		}

		protected function onSurveyEnd( event:SurveyEvent ):void
		{
			
			Tracer.output( debug, " Survey.onSurveyEnd(event)", getQualifiedClassName( this ) );
			if ( navigation ) 
			{
				navigation.surveyEnd();
			}
		}
		private function configLoadComplete( event:CommandEvent ):void
		{
			
			commands.removeEventListener( CommandEvent.COMPLETE, configLoadComplete );	
			try
			{
							
			configXML = XML( event.data );		
			
			for ( var i:uint = 0; i < configXML.namespaceDeclarations().length; i++ ) 

			{
				var ns:Namespace = configXML.namespaceDeclarations()[i];
				namespaceCollection.addElement( ns.prefix, ns );
			}
			formNS = namespaceCollection.getElement( "form" );
			uiNS = namespaceCollection.getElement( "ui" );
			styleNS = namespaceCollection.getElement( "style" );
			commandNS = namespaceCollection.getElement( "command" );
			customCommandNS = namespaceCollection.getElement( "customcommand" );

			// Add survey framework commands
			for each ( var commandItem:XML in configXML.commandNS::commandmap.item )
			{
				Tracer.output( true, " Mapping " + commandItem.@event + " event >> " + commandNS.uri + "." + commandItem.@id + " with group ID " + commandItem.@group, getQualifiedClassName( this ) );
				commands.addCommand( commandItem.@event, getCommandClass( commandNS, commandItem.@id ), commandItem.@group );
			}

			// Add custom commands
			for each ( var customCommandItem:XML in configXML.customCommandNS::commandmap.item )
			{
				Tracer.output( true, " Mapping " + customCommandItem.@event + " event >> " + customCommandNS.uri + "." + customCommandItem.@id + " with group ID " + customCommandItem.@group, getQualifiedClassName( this ));
				commands.addCommand( customCommandItem.@event, getCommandClass( customCommandNS, customCommandItem.@id ), customCommandItem.@group );		
			}			
			
			commands.addEventListener( CommandEvent.COMPLETE, dataLoadComplete );	
			
			
			
			
			
			commands.dispatchEvent( new SurveyEvent( SurveyEvent.LOAD_DATA, false, false, { locale: this.locale, 
																									url: dataURL,
																									flashVars: this.flashVars,
																									configState: configState}));
			}catch(e:Error)
			{
				styleError(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			}
		}

		private function dataLoadComplete( event:CommandEvent ):void
		{
			parser = event.data as SurveyDataParser;
			commands.removeEventListener( CommandEvent.COMPLETE, dataLoadComplete );
			commands.addEventListener( CommandEvent.COMPLETE, injectCustomDataComplete );
			commands.dispatchEvent( new SurveyEvent( SurveyEvent.CUSTOM_DATA, false, false, { parser: parser,
																							  configState: configState }));

		}

		protected function injectCustomDataComplete( event:CommandEvent ):void
		{
			commands.removeEventListener( CommandEvent.COMPLETE, injectCustomDataComplete );
			commands.addEventListener( CommandEvent.COMPLETE, styleLoadComplete );
			var progressMapper:XMLDataMapper = new XMLDataMapper();
			progressMapper.addDataMap( dataClass );
			progressMapper.addDataMap( ProgressBarData, "progress", "progress" );
			progressMapper.addDataMap( ProgressBarItem, "item", "items" );
			progressMapper.deserialize( configXML );
			ISurveyData( parser.data ).progress = ISurveyData( progressMapper.data ).progress;
			
			var groupingMapper:XMLDataMapper = new XMLDataMapper();			
			groupingMapper.addDataMap( dataClass );
			groupingMapper.addDataMap( ResponseGroupingData, "response-groupings", "responseGroupings" );
			groupingMapper.addDataMap( ResponseGroupData, "group", "groups" );
			groupingMapper.addDataMap( ResponseData, "response", "responses" );
			groupingMapper.addDataMap( ItemData, "item", "items" );
			groupingMapper.deserialize( configXML );
			ISurveyData( parser.data ).responseGroupings = ISurveyData( groupingMapper.data ).responseGroupings;

			var cssMapper:XMLDataMapper = new XMLDataMapper();
			cssMapper.addDataMap( dataClass );
			cssMapper.addDataMap( CSSData, "customCSS", "customCSS" );
			cssMapper.addDataMap( CSSDataItem, "css", "css" );
			cssMapper.deserialize( configXML );
			cssCollection = ISurveyData( cssMapper.data ).customCSS;

			var ignoreMapper:XMLDataMapper = new XMLDataMapper();
			ignoreMapper.addDataMap( dataClass );
			ignoreMapper.addDataMap( IgnoreData, "ignore", "ignoreList" );
			ignoreMapper.addDataMap( ItemData, "item", "ignoreItems" );
			ignoreMapper.deserialize( configXML );
			ignoreCollection = ISurveyData( ignoreMapper.data ).ignoreList;

			var layoutMapper:XMLDataMapper = new XMLDataMapper();
			layoutMapper.addDataMap( dataClass );
			layoutMapper.addDataMap( LayoutData, "layout", "layout" );
			layoutMapper.addDataMap( LayoutDecoratorData, "decorator", "decorators" );
			layoutMapper.deserialize( configXML );

			var metaDataMapper:XMLDataMapper = new XMLDataMapper();
			metaDataMapper.addDataMap( dataClass );
			metaDataMapper.addDataMap( MetaData, "metaData", "metaData" );
			metaDataMapper.addDataMap( MetaSetting, "metaSetting", "metaSettings" );
			metaDataMapper.deserialize( configXML );
			metadataSettingsCollection = ISurveyData( metaDataMapper.data ).metaData;

			// Add all the dynamic UI component to a collection for later use
			var compMapper:XMLDataMapper = new XMLDataMapper();
			compMapper.addDataMap( dataClass );
			compMapper.addDataMap( UIData, "component", "component" );
			compMapper.addDataMap( UIItemData, "item", "items" );
			compMapper.deserialize( configXML );
			customUICollection = ISurveyData( compMapper.data ).component;

			// Add all the dynamic UI component to a collection for later use
			var customFormMapper:XMLDataMapper = new XMLDataMapper();
			customFormMapper.addDataMap( dataClass );
			customFormMapper.addDataMap( CustomFormCollectionData, "customForm", "customForm" );
			customFormMapper.addDataMap( CustomFormData, "item", "customForm" );
			customFormMapper.deserialize( configXML );
			customFormCollection = ISurveyData( customFormMapper.data ).customForm;
			
			
//			cholGroup.getItemData("CholSlider").
//			trace(cholGroup.formItemNS);
			//formItemNS();
			
			commands.dispatchEvent( new SurveyEvent( SurveyEvent.LOAD_STYLE, false, false, { url:styleURL, 
																							 parser:parser, 
																							 styleNS:styleNS, 
																							 styleID:configXML.styleNS::style.@id, 
																							 ignoreMapper:ignoreMapper, 
																							 surveyCSSData:ISurveyData( cssMapper.data ).customCSS, layoutData:ISurveyData( layoutMapper.data ).layout,locale:locale, styleURLSuffix:styleURLSuffix } ) );
		}

		private function styleLoadComplete( event:CommandEvent ):void
		{
			styleManager = event.data.styleManager as IStyleManager;
			commands.removeEventListener( CommandEvent.COMPLETE, styleLoadComplete );
			var arr:Array = Font.enumerateFonts();
			for ( var k:int = 0; k < arr.length; k++ )
				Tracer.output( true, " Font " + arr[k].fontName + " registered.", toString() );

			commands.removeEventListener( CommandEvent.COMPLETE, styleLoadComplete );
			commands.addEventListener( CommandEvent.COMPLETE, parseIgnoreComplete );
			commands.dispatchEvent( new SurveyEvent( SurveyEvent.PARSE_IGNORE, false, false, { url:styleURL, parser:parser, ignoreData:ISurveyData( event.data.ignoreMapper.data ).ignoreList } ) );
		}

		private function parseIgnoreComplete( event:CommandEvent ):void
		{
			commands.removeEventListener( CommandEvent.COMPLETE, parseIgnoreComplete );
			initializationComplete();
		}

		private function error( event:IOErrorEvent ):void
		{
			Tracer.output( true, " LoadSurveyDataCommand.error(event)", getQualifiedClassName( this ) );
		}
		private function styleError( event:IOErrorEvent ):void
		{
			commands.addCommand( SurveyEvent.LOAD_CONFIG, getCommandClass( commandNS, COMMAND_LOAD_CONFIG ) );
			commands.addEventListener( CommandEvent.COMPLETE, configLoadComplete );
			commands.dispatchEvent( new SurveyEvent( SurveyEvent.LOAD_CONFIG, false, false, { locale:this.locale, config:configURL } ) );
			Tracer.output( true, " LoadSurveyDataCommand.error(event)", getQualifiedClassName( this ) );
		}
		private function getCommandClass( ns:Namespace, className:String ):Class
		{
			return getDefinitionByName( ns + "::" + className ) as Class;
		}

		private function getSurveyUIElementClass( className:String ):Class
		{
			return getDefinitionByName( uiNS + "::" + className ) as Class;
		}

		protected function validationComplete( event:SurveyEvent ):void
		{
			if ( navigation )
			{
				navigation.history = controller.history;
				navigation.validate( event.data );
			}
			
		}

		private function start():void
		{
			controller.createForm( "Start" );
			onStageResize( null );
		}

		/**
		 * Is there is a Meta item that should show by default
		 * set in the config XML
		 */
		public function getCurrentFormDefaultMeta():IFormMetaData
		{
			var it:IIterator = controller.currentForm.data.metaIterator;
			var item:IFormMetaData;

			while ( it.hasNext() )
			{
				item = IFormMetaData( it.next() );

				if ( MetaData( metadataSettingsCollection.find() ).metaSetting( item.id ) )
				{
					if ( MetaData( metadataSettingsCollection.find() ).metaSetting( item.id ).autoShow )
					{
						it.purge();
						it = null;
						return item;
					}
				}
			}

			it.purge();
			it = null;
			item = null;

			return null;
		}

		public function get formDepth():int
		{
			return _formDepth;
		}

		public function set formDepth( value:int ):void
		{
			_formDepth = value;
		}

		public function get navigationDepth():int
		{
			return _navigationDepth;
		}

		public function set navigationDepth( value:int ):void
		{
			_navigationDepth = value;
		}

		public function get metaDepth():int
		{
			return _metaDepth;
		}

		public function set metaDepth( value:int ):void
		{
			_metaDepth = value;
		}
	}
}
