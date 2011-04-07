package com.wezside.components.survey
{
	import com.wezside.components.UIElement;
	import com.wezside.components.decorators.layout.PaddedLayout;
	import com.wezside.components.decorators.layout.VerticalLayout;
	import com.wezside.components.survey.data.IFormData;
	import com.wezside.components.survey.data.ISurveyData;
	import com.wezside.components.survey.data.SurveyData;
	import com.wezside.components.survey.data.config.CustomFormData;
	import com.wezside.components.survey.data.config.grouping.ResponseGroupingData;
	import com.wezside.components.survey.data.router.Route;
	import com.wezside.components.survey.data.router.SurveyRouter;
	import com.wezside.components.survey.form.Form;
	import com.wezside.components.survey.form.FormEvent;
	import com.wezside.components.survey.form.FormItem;
	import com.wezside.components.survey.form.FormValidator;
	import com.wezside.components.survey.form.IForm;
	import com.wezside.components.survey.form.IFormGroup;
	import com.wezside.components.survey.form.IFormItem;
	import com.wezside.data.collection.ICollection;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.state.StateManager;

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class SurveyController extends UIElement
	{
		public static const NAVIGATE_BACK:String = "back";
		public static const NAVIGATE_NEXT:String = "next";
		public static const NAVIGATE_RESTART:String = "restart";
		public static const NAVIGATE_START:String = "Start";
		public static const NAVIGATE_SUBMIT:String = "submit";
		public static const NAVIGATE_TRY_AGAIN:String = "TryAgain";
		public static const NAVIGATE_SHOW_FORM:String = "showForm";
		
		private var _data:ISurveyData;
		private var _currentForm:IForm;
		private var _nextRoute:Route;
		private var _router:SurveyRouter;
		private var _validator:FormValidator;
		private var _history:Array = [];
		private var _formNS:Namespace;
		private var _currentFormID:String;
		private var _customFormCollection:ICollection;
		private var _direction : int;
		private var _currentFormIndex : int;
		private var _configState : StateManager;
		private var _currentFormItem:IFormItem;
		private var _currentFormGroup:IFormGroup;
		private var responseLevelRoute : Route;
		private var responseLevelID : String;
		private var responseLevelRoutes : Dictionary;
		private var currentFormData:IFormData;
		
		
		public function SurveyController() {
			
			super();

			_validator = new FormValidator();
			responseLevelRoutes = new Dictionary();

			addEventListener( FormEvent.ITEM_STATE_CHANGE, onFormItemChange );
		}

		override public function purge():void
		{
			removeEventListener( FormEvent.ITEM_STATE_CHANGE, onFormItemChange );

			if ( _currentForm )
			{
				_currentForm.removeEventListener( FormEvent.HIDE_FORM_COMPLETE, hideFormComplete );
				_currentForm.removeEventListener( FormEvent.SHOW_FORM_COMPLETE, onShowFormComplete );
				_currentForm.removeEventListener( FormEvent.SHOW_FORM, onShowForm );
				_currentForm.removeEventListener( FormEvent.RESIZE, onFormResize );
				_currentForm.purge();
				try
				{
					removeChild( DisplayObject( _currentForm ) );
				}
				catch ( error:Error )
				{
					trace( "couldn't remove: " + DisplayObject( currentForm ) + ", " + error.message );
				}
			}

			if ( currentFormData ) currentFormData.purge();
			if ( _nextRoute ) _nextRoute.purge();
			if ( responseLevelRoute ) responseLevelRoute.purge();
			if ( _router ) _router.purge();
			if ( _validator ) _validator.purge();
			if ( _customFormCollection ) _customFormCollection.purge();
			if ( _data ) _data.purgeData();

			super.purge();
			_configState=null;
			responseLevelRoute = null;
			responseLevelRoutes = null;
			currentFormData = null;
			_nextRoute = null;
			_data = null;
			_history = null;
			_router = null;
			_currentForm = null;
			_validator = null;
			_customFormCollection = null;
		}

		public function createForm( id:String ):void
		{

			if (!_validator.configState)
			{
				_validator.configState=_configState?_configState:new StateManager();
			}
			currentFormData = data.getFormData( id );
			
			if ( !currentFormData )
			{
				Tracer.output( debug, "ERROR : SurveyController.createForm :: Form data could not be retrieved for form " + id, getQualifiedClassName( this ) );
				return;
			}

			if ( _currentForm )
			{
				// A form page already exists
				if ( _currentForm.data && currentFormData.id == _currentForm.data.id )
				{
					// The requested form page is the one that is currently displayed
					// Tracer.output( _debug, "WARN : FormController.createForm :: requested form ID is current form - ID: " + formData.id );
					return;
				}
				else
				{
					// Clear old form so that new form can be created
					// Tracer.output( _debug, "WARN : FormController.createForm :: Clearing old form ID:" + _currentForm.data.id );
					_currentForm.addEventListener( FormEvent.HIDE_FORM_COMPLETE, hideFormComplete );
					_currentForm.hide( _direction );
					dispatchEvent( new FormEvent( FormEvent.HIDE_FORM ) );
					return;
				}
			}
			showForm();
		}

		public function get currentForm():IForm
		{
			return _currentForm;
		}

		public function set currentForm( value:IForm ):void
		{
			_currentForm = value;
		}

		public function get currentFormID():String
		{
			return _currentFormID ? _currentFormID : "Start";
		}

		public function set currentFormID( value:String ):void
		{
			_currentFormID = value;
		}

		public function get data():ISurveyData
		{
			return _data ? _data : new SurveyData();
		}

		public function set data( value:ISurveyData ):void
		{
			_data = value;
		}

		public function get router():SurveyRouter
		{
			return _router;
		}

		public function set router( value:SurveyRouter ):void
		{
			_router = value;
		}

		public function get formNS():Namespace
		{
			return _formNS;
		}

		public function set formNS( value:Namespace ):void
		{
			_formNS = value;
		}

		public function get customFormCollection():ICollection
		{
			return _customFormCollection;
		}

		public function set customFormCollection( value:ICollection ):void
		{
			_customFormCollection = value;
		}

		public function get history():Array
		{
			return _history;
		}

		public function set history( value:Array ):void
		{
			_history = value;
		}

		public function previous():String
		{
			_history.splice( _history.length - 1, 1 );
			return _history[ _history.length - 1 ] ? _history[ _history.length - 1 ] : "Start";
		}

		private function showForm():void
		{
			_currentForm = getFormClassFromID( currentFormData.id );

			addChild( DisplayObject( _currentForm ) );
			_currentForm.data = currentFormData;
			_currentForm.data.responseGroupings = ResponseGroupingData( data.responseGroupings.getElementAt( 0 )).groups;
			_currentForm.styleManager = currentFormData.styleManager ? currentFormData.styleManager : styleManager;
			_currentForm.layout = new VerticalLayout( _currentForm );
			_currentForm.layout = new PaddedLayout( _currentForm.layout );
			_currentForm.addEventListener( FormEvent.SHOW_FORM_COMPLETE, onShowFormComplete );
			_currentForm.addEventListener( FormEvent.SHOW_FORM, onShowForm );
			_currentForm.addEventListener( FormEvent.RESIZE, onFormResize );
			_currentForm.build();
			_currentForm.setStyle();
			_currentForm.resize();
			_currentForm.arrange();
			_currentFormID = currentFormData.id;
			_validator.formData = currentFormData;

			var formValid:Boolean = _validator.validateForm( _currentForm );
			var surveyEvent:SurveyEvent = new SurveyEvent( SurveyEvent.VALIDATION_COMPLETE );
			surveyEvent.data = { validate:formValid, formID:currentFormData.id };
			dispatchEvent( surveyEvent );

			_currentForm.show( _direction );
		}

		private function hideFormComplete( event:FormEvent ):void
		{
			IForm( event.currentTarget ).removeEventListener( FormEvent.HIDE_FORM_COMPLETE, hideFormComplete );
			IForm( event.currentTarget ).removeEventListener( FormEvent.SHOW_FORM_COMPLETE, onShowFormComplete );
			IForm( event.currentTarget ).removeEventListener( FormEvent.SHOW_FORM, onShowForm );
			IForm( event.currentTarget ).removeEventListener( FormEvent.RESIZE, onFormResize );
			IForm( event.currentTarget ).purge();
			if ( IForm( event.currentTarget ) == _currentForm )
			{
				try
				{
					removeChild( DisplayObject( _currentForm ) );
				}
				catch ( error:Error )
				{
					trace( "couldn't remove: " + DisplayObject( currentForm ) + ", " + error.message );
				}
				_currentForm = null;
			}
			dispatchEvent( event );
			showForm();
		}

		private function onFormResize( event:FormEvent ):void
		{
			dispatchEvent( event );
		}

		private function onShowFormComplete( event:FormEvent ):void
		{
			dispatchEvent( event );
		}

		private function onShowForm( event:FormEvent ):void
		{
			dispatchEvent( event );
		}

		/**
		 * This method deals with state changes on a Form Item level. 
		 */
		private function onFormItemChange( event:FormEvent ):void
		{
			if ( !( event.target is IFormItem ) )
			{
				// if this is not from an IFormItem target
				// stop to the event from carrying on (bubbling) and return
				event.stopImmediatePropagation();
				return;
			}

			var formItem:IFormItem = IFormItem( event.target );

			if ( formItem.type != FormItem.ITEM_CALL_TO_ACTION )
			{
				// only CTAs should bubble the event up
				//FIXME removed for about page
//				event.stopImmediatePropagation();
			}

			switch ( formItem.type )
			{
				case FormItem.ITEM_CALL_TO_ACTION:
					// Show meta content or navigate to exit URL
					// dispatchEvent( event );
					break;
				default:
					_validator.formData = _currentForm.data;
					// Determine the navigation path based on user choices
					_nextRoute = _router.next( formItem.data.groupID );
					if ( _router.hasChild( formItem.id )||_currentForm.data.getResponseItemIds(formItem.data.groupID, formItem.data.id ).length>0)
					{
						// Routing is a response level for this item
						responseLevelRoute = router.next( formItem.id );
						responseLevelID = responseLevelRoute.nextpath;
						responseLevelRoutes[ _currentForm.data.id ] = { id:formItem.data.groupID, responseLevelID:responseLevelID };

						// Determine if the child route has a response level grouping set in the config
						// If it has then we showHide
						_currentFormItem = formItem;
						_currentFormGroup = _currentForm.getFormGroupByID( formItem.data.groupID );
						
						if ( _nextRoute && _currentForm.data.getResponseItemIds(formItem.data.groupID, formItem.data.id ).length>0)
						{
							// Reset the responseLevelRoute recording as this conditional indicates there are in-line response level routing, i.e. 
							// hidden groups based on a response. This will force the 'onNavigationRequest' handler to use the lastItemID look-up which 
							// will successfully return the last groupID in the current form
							responseLevelID = "";
							responseLevelRoute = null;
							responseLevelRoutes[ _currentForm.data.id ] = null;
														
							// TODO: Find a better way to get the current state change FormItem
							_currentForm.addEventListener( FormEvent.SHOW_GROUPS_COMPLETE, showHideGroupsComplete );
							_currentForm.showGroups( formItem );
						}
						else
						{
							_currentForm.addEventListener( FormEvent.HIDE_GROUPS_COMPLETE, showHideGroupsComplete );
							_currentForm.hideGroups( formItem );
						}
					}
					else
					{
						// If a response level does exist for the current form and the current form item's group ID
						// is part of the current form then clear it. 
						if ( responseLevelRoutes[ _currentForm.data.id ])
						{
							if ( formItem.data.groupID == responseLevelRoutes[ _currentForm.data.id ].id )
							{
								responseLevelID = "";
								responseLevelRoute = null;
								responseLevelRoutes[ _currentForm.data.id ] = null;
							}
						}
					}
					var groupData:IFormGroup = _currentForm.getFormGroupByID( formItem.data.groupID );
					if(!groupData)return;
//					trace("formItem.data.groupID",groupData);					
					var surveyEvent:SurveyEvent = new SurveyEvent( SurveyEvent.VALIDATION_COMPLETE );
					var formValid:Boolean = _validator.validate( formItem, groupData, _currentForm );
					surveyEvent.data = { validate:formValid, history:_history, formID:_currentForm.data.id };
					dispatchEvent( surveyEvent );
					break;
			}
			
		}

		private function showHideGroupsComplete( event:FormEvent ):void
		{
			event.currentTarget.removeEventListener( event.type, showHideGroupsComplete );
			var surveyEvent:SurveyEvent = new SurveyEvent( SurveyEvent.VALIDATION_COMPLETE );
			var formValid:Boolean = _validator.validate( _currentFormItem, _currentFormGroup, _currentForm );
			surveyEvent.data = { validate:formValid, history:_history, formID:_currentForm.data.id };
			dispatchEvent( surveyEvent );			
		}

		public function onNavigationRequest( eventData:Object ):void
		{
			switch ( eventData.id )
			{
				case NAVIGATE_START:
				case NAVIGATE_NEXT:
				case NAVIGATE_SUBMIT:
					// Direction logic changed as we know next/start/submit is forward (1)
					_direction = history.length - 1 > _currentFormIndex ? 1 : _direction;
					_direction = 1;
					var formID:String = _currentForm.data.id;
					var formData:IFormData = _currentForm.data;
					if ( formData.valid )
					{
						if ( _nextRoute )
						{
							_nextRoute = router.next( formData.lastGroupID );
						}
						else
						{
							_nextRoute = router.next( "Start" );
						}

						// If survey ends and all forms valid
						if ( _nextRoute.nextpath == "[End]" )
						{
							_history.push( _currentForm.data.id );
							var surveyEvent:SurveyEvent = new SurveyEvent( SurveyEvent.SURVEY_END );
							surveyEvent.data = _currentForm.data;
							dispatchEvent( surveyEvent );
						}
						else
						{
							// Check if a responselevel for the current form has been recorded, i.e. a user has interacted with
							// a responselevel routing form item. If so we update the formID value accordingly to use the associated
							// nextPath value recorded against it in the formItem state change handler 'onFormItemChange'. 
							if ( hasResponseLevelID( _currentForm.data.id ))
							{
								if ( _data.getFormGroupData( responseLevelRoutes[ _currentForm.data.id ].responseLevelID ).parent )
								{
									// Get the groupID from the responseLevelRoutes associative array and in return get the IFormGroupData
									// Then get the IFormData the IFormGroupData belongs to using parent and the ID 
									formID = _data.getFormGroupData( responseLevelRoutes[ _currentForm.data.id ].responseLevelID ).parent.id;
								}
								else
								{
									formID = _data.getFormGroupData( responseLevelRoutes[ formID ].responseLevelID ).id;
								}
								_history.push( formID );
							}
							else
							{
								if ( _data.getFormGroupData( _nextRoute.nextpath ).parent )
								{
									formID = _data.getFormGroupData( _nextRoute.nextpath ).parent.id;
								}
								else
								{
									formID = _data.getFormGroupData( _nextRoute.nextpath ).id;
								}
								_history.push( formID );
							}							
							createForm( formID );
						}
					}
					break;
				case NAVIGATE_BACK:
					// Direction logic changed as we know next/start/submit is backward (-1)
					_direction = history.length - 1 <= _currentFormIndex ? -1 : _direction;
					_direction = -1;
					formID = previous();
					if ( formID == router.startID )
					{
						_nextRoute = null;
						responseLevelRoute = null;
						_nextRoute = router.next( "Start" );
					}
					createForm( formID );
					break;
				case NAVIGATE_RESTART :
					dispatchEvent( new SurveyEvent( SurveyEvent.SURVEY_RESTART ));
					break;
				case NAVIGATE_SHOW_FORM:
				default:
					_history.splice( eventData.index );
					_history.push( eventData.id );
					createForm( eventData.id );
					break;
			}

			if ( eventData.id != NAVIGATE_RESTART )
			{
				_currentFormIndex = history.length - 1;
			}
		}

		private function hasResponseLevelID( currentFormID:String ):Boolean
		{
			return responseLevelRoutes[ currentFormID ] ? true : false;
		}

		private function getFormClassFromID( id:String ):IForm
		{
			var clazz:Class;
			try
			{
				clazz = getDefinitionByName( formNS + "::" + CustomFormData( _customFormCollection.find( "id", id ) ).className ) as Class;
				return new clazz as IForm;
			}
			catch( error:Error )
			{
				Tracer.output( debug, " No Custom Class " + id + " found. Look for generic class Form within custom namespace", getQualifiedClassName( this ) );
				try
				{
					clazz = getDefinitionByName( formNS + "::" + CustomFormData( _customFormCollection.find( "id", "Form" )).className ) as Class;
					return new clazz as IForm;
				}
				catch ( error:Error )
				{
					trace( "getFormClassFromID: " + id + ", " + error.message );
				}
			}
			return new Form();
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction( value:int ):void
		{
			_direction = value;
		}

		public function get configState() : StateManager {
			return _configState;
		}

		public function set configState(value : StateManager) : void {
			_configState = value;
		}
	}
}