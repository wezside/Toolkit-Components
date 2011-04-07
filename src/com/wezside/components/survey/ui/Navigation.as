package com.wezside.components.survey.ui
{
	import com.wezside.components.UIElement;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;
	import com.wezside.components.control.Button;
	import com.wezside.components.decorators.layout.HorizontalLayout;
	import com.wezside.components.survey.SurveyController;
	import com.wezside.components.survey.SurveyDataParser;
	import com.wezside.components.survey.SurveyEvent;
	import com.wezside.components.survey.data.config.CSSDataItem;
	import com.wezside.data.collection.ICollection;

	import flash.geom.Rectangle;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class Navigation extends UIElement implements ISurveyNavigation
	{
		
		public static const SURVEY_END:String = "SURVEY_END";
		public static const SURVEY_STOPPED:String = "SURVEY_STOPPED";
		public static const SURVEY_START:String = "SURVEY_START";
		public static const SURVEY_ERROR:String = "SURVEY_ERROR";
		public static const SURVEY_NORMAL:String = "SURVEY_NORMAL";

		private var _styleNameCollection:ICollection;
		private var _history:Array = [];
		private var _hiddenFormIDCollection:ICollection;
		private var _currentFormID:String;
		private var _totalForms:uint;
		private var _parser : SurveyDataParser;
		
		
		public function Navigation() 
		{
			super();
			layout = new HorizontalLayout( this );	
			stateManager.addState( SURVEY_END ); // Submit results
			stateManager.addState( SURVEY_STOPPED ); // Can't go forward
			stateManager.addState( SURVEY_START );
			stateManager.addState( SURVEY_ERROR );
			stateManager.addState( SURVEY_NORMAL );
		}
		
		override public function build():void 
		{
			super.build();
			createButtons();
		}
		
		override public function purge() : void {
			
			super.purge();
			
			_styleNameCollection = null;
			_history = null;
			_hiddenFormIDCollection = null;
			_parser = null;
		}
		
		/**
		 * This can be overriden to set your own copy
		 */
		public function createButtons() : void {
			addChild( createButton( SurveyController.NAVIGATE_BACK, " " ) );
			addChild( createButton( SurveyController.NAVIGATE_NEXT, " " ) );
			addChild( createButton( SurveyController.NAVIGATE_RESTART, " " ) );
			addChild( createButton( SurveyController.NAVIGATE_START, " " ) );
			addChild( createButton( SurveyController.NAVIGATE_SUBMIT, " " ) );
			addChild( createButton( SurveyController.NAVIGATE_TRY_AGAIN, " " ) );
		}
		
		override public function arrange():void 
		{
			super.arrange();
			x = int( ( stage.stageWidth - width ) * .5 );
			y = int( ( stage.stageHeight - height ) * .5 );
		}


		/**
		 * This method is responsible for enable/disabled of navigation items based on the valid 
		 * state of the current form. 
		 */
		public function validate( value:Object ):void
		{
			var nextButton:UIElement = getButton( SurveyController.NAVIGATE_NEXT );
			var backButton:UIElement = getButton( SurveyController.NAVIGATE_BACK );
			var submitButton:UIElement = getButton( SurveyController.NAVIGATE_SUBMIT );
						
			if ( value.validate ) 
			{
				nextButton.activate();
				nextButton.state = UIElementState.STATE_VISUAL_UP;
				submitButton.activate();
				submitButton.state = UIElementState.STATE_VISUAL_UP;
			}
			else 
			{
				nextButton.deactivate();
				nextButton.state = UIElementState.STATE_VISUAL_DISABLED;
				submitButton.deactivate();
				submitButton.state = UIElementState.STATE_VISUAL_DISABLED;
			}
			
			if ( _history.length >= 1 ) 
			{
				backButton.activate();
				backButton.state = UIElementState.STATE_VISUAL_UP;
			}
			else 
			{
				backButton.deactivate();
				backButton.state = UIElementState.STATE_VISUAL_DISABLED;
			}
			
			if ( _history.length == 0 ) 
			{
				nextButton.visible = false;
				backButton.visible = false;
			}
			else if ( _history.length == _totalForms )
			{
				nextButton.visible = false;
				submitButton.visible = true;
			}
		}		

		/**
		 * This method is called once a form has dispatched the event FormEvent.SHOW_COMPLETE. 
		 */
		public function showFormComplete():void
		{	
			var nextButton:UIElement = getButton( SurveyController.NAVIGATE_NEXT );
			var backButton:UIElement = getButton( SurveyController.NAVIGATE_BACK );
			var startButton:UIElement = getButton( SurveyController.NAVIGATE_START );
			
			startButton.visible = false;
			
			if ( _history.length == 0 ) 
			{
				nextButton.visible = false;
				backButton.visible = false;
				startButton.visible = true;
				startButton.activate();	
			}
			if ( _history.length > 0 && _history.length != _totalForms ) 
			{
				nextButton.visible = true;
				backButton.visible = true;
			}
		}
		
		public function hideFormComplete():void
		{	
			//
		}
		
		
		
		public function resize():void
		{
		}
		
		public function showForm( direction : int = 0 ):void
		{
		}
		
		public function hideForm( direction : int = 0 ):void
		{
		}
		
		public function updateLayout( currentFormRectangle:Rectangle ):void
		{
		}
		
		public function surveyEnd():void
		{
			getButton( SurveyController.NAVIGATE_BACK ).visible = false;
		}
		
		public function get hiddenFormIDCollection():ICollection
		{
			return _hiddenFormIDCollection;
		}
		
		public function set hiddenFormIDCollection( value:ICollection ):void
		{
			_hiddenFormIDCollection = value;
		}
		
		public function get currentFormID():String
		{
			return _currentFormID;
		}
		
		public function set currentFormID(value:String):void
		{
			_currentFormID = value;
		}
		
		public function get history():Array
		{
			return _history;
		}
		
		public function set history( value:Array ):void
		{
			_history = value;
		}
		
		public function get parser():SurveyDataParser
		{
			return _parser;
		}
		
		public function set parser( value:SurveyDataParser ):void
		{
			_parser = value;
		}
		
		public function get styleNameCollection():ICollection
		{
			return _styleNameCollection;
		}
		
		public function set styleNameCollection( value:ICollection ):void
		{
			_styleNameCollection = value;
		}
		
		public function getButton( id:String ):UIElement
		{
			return getChildByName( id ) as UIElement;
		}
		
		protected function getStyleName( id:String ):String 
		{
			var cssID:String;
			if ( _styleNameCollection )
			{
				var cssDataItem:CSSDataItem = styleNameCollection.find( "id", id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}			
		
		protected function createButton( id:String, text:String ):Button 
		{
			var button:Button = new Button();
			button.id = id;
			button.name = id;
			button.text = text;
			button.styleManager = styleManager;
			button.styleName = getStyleName( id );
			
			switch ( id ) {
				
				case SurveyController.NAVIGATE_TRY_AGAIN : 
					button.styleName = "TryAgainButton";
					break;
					
				case SurveyController.NAVIGATE_BACK : 
					button.styleName = "BackButton";
					break;
					
				case SurveyController.NAVIGATE_NEXT : 
					button.styleName = "NextButton";
					break;
					
				case SurveyController.NAVIGATE_START : 
					button.styleName = "StartButton";
					break;
					
				default : break;
			}
			
			button.setStyle();
			button.iconStyleName = button.styleName + "Icon";
			button.build();
			button.arrange();
			button.visible = false;
			button.addEventListener( UIElementEvent.STATE_CHANGE, stateChange );
			button.state = UIElementState.STATE_VISUAL_DISABLED;
			return button;
		}

		protected function stateChange( event:UIElementEvent ):void 
		{
			if ( event.state.key == UIElementState.STATE_VISUAL_CLICK && event.target.id != SurveyController.NAVIGATE_TRY_AGAIN )
			{
				if ( _history.length == 1 && event.target.id == SurveyController.NAVIGATE_BACK ) 
				{
					getButton( SurveyController.NAVIGATE_NEXT ).visible = false;
					getButton( SurveyController.NAVIGATE_BACK ).visible = false;
				}
				
				getButton( SurveyController.NAVIGATE_START ).visible = false;
				getButton( SurveyController.NAVIGATE_SUBMIT ).visible = false;				
				dispatchEvent( new SurveyEvent( SurveyEvent.NAVIGATE, false, false, { id: event.target.id, history: _history }));
			}
		}
		
		public function get totalForms():uint
		{
			return _totalForms;
		}
		
		public function set totalForms( value:uint ):void
		{
			_totalForms = value;
		}
	}
}
