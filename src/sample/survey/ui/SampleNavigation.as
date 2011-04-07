package sample.survey.ui {
	import com.greensock.TweenLite;
	import com.wezside.components.UIElement;
	import com.wezside.components.UIElementState;
	import com.wezside.components.survey.SurveyController;
	import com.wezside.components.survey.ui.Navigation;

	/**
	 * @author Sean Lailvaux
	 */
	public class SampleNavigation extends Navigation {
		
		private var startButton 		: UIElement;
		private var nextButton 			: UIElement;
		private var backButton 			: UIElement;
		private var tryAgainButton 		: UIElement;
		private var submitButton 		: UIElement;
		
		
		override public function createButtons() : void {
			if ( parser ) {
				addChild( createButton( SurveyController.NAVIGATE_TRY_AGAIN, parser.getContent( "TryAgain", "NavigationLabel", "Navigation" ) ) );
				addChild( createButton( SurveyController.NAVIGATE_BACK, parser.getContent( "Back", "NavigationLabel", "Navigation" ) ) );
				addChild( createButton( SurveyController.NAVIGATE_NEXT, parser.getContent( "Next", "NavigationLabel", "Navigation" ) ) );
				addChild( createButton( SurveyController.NAVIGATE_START, parser.getContent( "Start", "NavigationLabel", "Navigation" ) ));
				addChild( createButton( SurveyController.NAVIGATE_SUBMIT, parser.getContent( "Submit", "NavigationLabel", "Navigation" ) ) );
			}
		}
		
		override public function arrange() : void {
			resize();
		}
		
		override public function resize() : void {
			
			if ( stage ) {
				
				var padding : int = 20;
				var middle : int = int( stage.stageWidth * .5 );
				
				startButton = getButton( SurveyController.NAVIGATE_START );
				startButton.state = UIElementState.STATE_VISUAL_UP;
				startButton.x = int( ( stage.stageWidth - startButton.width ) * .5 );
				startButton.y = int( stage.stageHeight - startButton.height - padding );
				
				backButton = getButton( SurveyController.NAVIGATE_BACK );
				backButton.x = int( middle - backButton.width - padding * .5 );
				backButton.y = int( stage.stageHeight - backButton.height - padding );
				
				tryAgainButton = getButton( SurveyController.NAVIGATE_TRY_AGAIN );
				tryAgainButton.x = int( ( stage.stageWidth - tryAgainButton.width ) * .5 );
				tryAgainButton.y = int( stage.stageHeight - backButton.height - padding );
				
				nextButton = getButton( SurveyController.NAVIGATE_NEXT );
				nextButton.x = int( backButton.x + backButton.width + padding );
				nextButton.y = int( stage.stageHeight - nextButton.height - padding );
				
				submitButton = getButton( SurveyController.NAVIGATE_SUBMIT );
				submitButton.x = int( backButton.x + backButton.width + padding );
				submitButton.y = int( stage.stageHeight - submitButton.height - padding );
			}
		}
		
		override public function showFormComplete() : void {
			
			startButton.visible = false;
			
			if ( history.length == 0 ) {
				nextButton.visible = false;
				backButton.visible = false;
				startButton.alpha = 0;
				startButton.visible = true;
				startButton.activate();
				TweenLite.to( startButton, .3, { alpha:1 } );
			}
			if ( history.length > 0 && history.length != totalForms ) {
				nextButton.visible = true;
				backButton.visible = true;
			}
		}
	}
}