package sample
{
	import sample.survey.command.CustomDataCommand;
	import sample.survey.command.LoadDataCommand;
	import sample.survey.command.LoadStyleCommand;
	import sample.survey.form.InfoCaptureForm;
	import sample.survey.form.SampleForm;
	import sample.survey.form.StartForm;
	import sample.survey.style.SampleStyle;
	import sample.survey.ui.FixedUIElement;
	import sample.survey.ui.SampleNavigation;

	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.greensock.plugins.RoundPropsPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.wezside.components.UIElement;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;
	import com.wezside.components.decorators.layout.FillLayout;
	import com.wezside.components.survey.Survey;
	import com.wezside.components.survey.SurveyController;
	import com.wezside.components.survey.SurveyEvent;
	import com.wezside.components.survey.data.IFormData;
	import com.wezside.components.survey.data.IFormGroupData;
	import com.wezside.components.survey.data.IFormItemData;
	import com.wezside.components.survey.data.ISurveyData;
	import com.wezside.components.survey.form.Form;
	import com.wezside.components.survey.form.FormEvent;
	import com.wezside.components.survey.form.FormItem;
	import com.wezside.components.survey.form.item.FormLabel;
	import com.wezside.components.text.Label;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.logging.Tracer;

	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Sean Lailvaux
	 */
	[SWF(backgroundColor="#999999", frameRate="31", width="640", height="480")]
	public class VisualTestSurvey extends Survey {
		
		private static const URL:String = "http://sample.com/sample.ashx";
		
		private var urlLoader : URLLoader;
		private var tryAgainButton : UIElement;
		
		
		override protected function stageInit( event : Event ) : void {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			super.stageInit( event );
		}
		
		/**
		 * This method is invoked when a form has been successfully constructed 
		 * but before the SHOW_COMPLETE event.
		 */
		override protected function onShowForm( event : FormEvent ) : void {
			super.onShowForm( event );
		}
		
		override protected function classIncludes() : void {
			super.classIncludes();			
			SampleNavigation;	
			StartForm;
			SampleForm;
			StartForm;
			FixedUIElement;
			InfoCaptureForm;
			CustomDataCommand;
			LoadDataCommand;
			LoadStyleCommand;
			SampleStyle;
			FillLayout;
		}
		
		override protected function initializationComplete() : void {			
			TweenPlugin.activate([ AutoAlphaPlugin,RemoveTintPlugin,TintPlugin,BlurFilterPlugin,RoundPropsPlugin ]);						
			parser.debug( false );
			super.initializationComplete();			
		}
		
		override protected function onSurveyEnd( event : SurveyEvent ) : void {
			
			super.onSurveyEnd( event );
			
			// update with success copy
			captureFormState = "Submit";
			
			// create URLVariables
			var urlVars:URLVariables = new URLVariables();
			var surveyData:ISurveyData = ISurveyData( parser.data );
			var surveyDataIt:IIterator = surveyData.iterator;
			
			// For each form within the survey
			while ( surveyDataIt.hasNext() ) {
				
				var formData:IFormData = surveyDataIt.next() as IFormData;
				var formDataIt:IIterator = formData.iterator;
				
				// For each group within a form
				while ( formDataIt.hasNext()) {
					
					var groupData:IFormGroupData = formDataIt.next() as IFormGroupData;	
					var answers:ICollection = groupData.getItemAnswerData();
					var answersIt:IIterator = answers.iterator();
					
					while ( answersIt.hasNext() ) {
						
						var answer:IFormItemData = answersIt.next() as IFormItemData;
						var index:int = Number( answer.groupID.substring( answer.groupID.length - 1 ));
						var value:Number = Number( answer.id.substring( answer.id.length - 1 ));
						
						if (!isNaN( value )) {
							// Form Questions
							if ( urlVars["Question_" + index ] != undefined && answer.type == FormItem.ITEM_DO_NOT_KNOW )
								urlVars["Question_" + index ] += "," + value;
							else
								urlVars["Question_" + index ] = value;
						}
						else {
							// Info Capture form details
							urlVars[ answer.id ] = answer.value;
						}
					}
					answersIt.purge();
					answersIt = null;
				}
				formDataIt.purge();
				formDataIt = null;
			}
			surveyDataIt.purge();
			surveyDataIt = null;					
			
			var request:URLRequest = new URLRequest();
			request.data = decodeURI( urlVars.toString());  
			request.method = URLRequestMethod.POST;
			request.url = URL;
			
			destroyURLLoader();
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener( Event.COMPLETE, result );
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			urlLoader.load( request );
		}
		
		private function onIOError( event : IOErrorEvent ) : void {
			Tracer.output( true, " onIOError: " + event.text, getQualifiedClassName( this ), Tracer.ERROR );
			destroyURLLoader();
			fault( null );
		}
		
		private function onSecurityError( event : SecurityErrorEvent ) : void {
			Tracer.output( true, " onSecurityError: " + event.text, getQualifiedClassName( this ), Tracer.ERROR );
			destroyURLLoader();
			fault( null );
		}
		
		private function destroyURLLoader() : void {
			if ( urlLoader ) {
				urlLoader.removeEventListener( Event.COMPLETE, result );
				urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				try {
					urlLoader.close();
				}
				catch ( error : Error ) {
					//
				}
			}
			urlLoader = null;
		}
		
		private function fault( event : Event ) : void {
			
			// update with error copy
			captureFormState = "Error";
			
			// show try again button
			if ( tryAgainButton == null ) {
				tryAgainButton = getButton( SurveyController.NAVIGATE_TRY_AGAIN );
				tryAgainButton.addEventListener( UIElementEvent.STATE_CHANGE, tryAgainClicked );
			}
			tryAgainButton.activate();
			tryAgainButton.visible = true;
		}
		
		private function tryAgainClicked( event : UIElementEvent ) : void  {
			
			if ( event.state.key == UIElementState.STATE_VISUAL_CLICK ) {
				
				UIElement( event.target ).visible = false;
				
				// default state
				captureFormState = "";
				
				getButton( SurveyController.NAVIGATE_SUBMIT ).visible = true;
				getButton( SurveyController.NAVIGATE_BACK ).visible = true;
				
				controller.previous();
			}
		}
		
		private function result( event : Event ) : void {
			// TODO: Need API to update UI Form Item from currentForm
			var responseXML:XML = XML( event.target.data );
			if ( responseXML.result.text() == "Error" ) {
				fault( null );
			}
			else {
				// update with success copy
				captureFormState = "Success";
			}
		}
		
		private function set captureFormState( state : String ) : void {
			
			var newAlpha : int = state == "" ? 1 : 0;
			DisplayObject( controller.currentForm.getUIItem( "FirstName" ) ).alpha = newAlpha;  
			DisplayObject( controller.currentForm.getUIItem( "LastName" ) ).alpha = newAlpha;  
			DisplayObject( controller.currentForm.getUIItem( "Email" ) ).alpha = newAlpha;
						var infoCaptureQuestionLabel 		: String = "";
			var infoCaptureQuestionSubLabel 	: String = "";
			var heading 						: String = "";			var subheading 						: String = "";			var body 							: String = "";
			
			if ( state == "" ) {
				infoCaptureQuestionLabel = parser.getContent( "InfoCapture", "QuestionLabel", "Questions" );
				infoCaptureQuestionSubLabel = parser.getContent( "InfoCapture", "QuestionSubLabel", "Questions" );
				heading = parser.getContent( "InfoCapture", "FormTitle", "Forms" );
				subheading = parser.getContent( "InfoCapture", "FormSubTitle", "Forms" );
				body = parser.getContent( "InfoCapture", "Description", "Forms" );
			}
			else {
				infoCaptureQuestionLabel = parser.getContent( state, "label", "Content" );
				infoCaptureQuestionSubLabel = parser.getContent( state, "subLabel", "Content" );
				heading = parser.getContent( state, "heading", "Content" );
				subheading = parser.getContent( state, "subheading", "Content" );
				body = parser.getContent( state, "body", "Content" );
			}
			
			updateCopy( controller.currentForm.getUIItem( "InfoCapture_QuestionLabel" ), infoCaptureQuestionLabel );			updateCopy( controller.currentForm.getUIItem( "InfoCapture_QuestionLabel" ), infoCaptureQuestionSubLabel, true );			updateCopy( Form( controller.currentForm ).heading, heading );			updateCopy( Form( controller.currentForm ).subheading, subheading );			updateCopy( Form( controller.currentForm ).body, body );
		}
		
		private function updateCopy( target : *, text : String, subLabel : Boolean = false ) : void {
			if ( target && target is Label ) {
				if ( subLabel && target is FormLabel ) {
					FormLabel( target ).subLabelText = text;
				}
				else {
					Label( target ).text = text;
				}
			}
		}
	}
}