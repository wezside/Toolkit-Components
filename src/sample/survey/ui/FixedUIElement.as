package sample.survey.ui {
	import com.wezside.components.UIElement;
	import com.wezside.components.survey.SurveyDataParser;
	import com.wezside.components.survey.data.config.CSSDataItem;
	import com.wezside.components.survey.ui.ISurveyUIElement;
	import com.wezside.components.text.Label;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;

	/**
	 * @author Sean Lailvaux
	 */
	public class FixedUIElement extends UIElement implements ISurveyUIElement {
		
		private var _styleNameCollection 		: ICollection;
		private var _hiddenFormIDCollection 	: ICollection;
		private var _currentFormID 				: String;
		private var _history 					: Array;
		private var _totalForms 				: uint;
		private var _parser 					: SurveyDataParser;
		
		private var label : Label;
		
		
		override public function build() : void {
			
			label = new Label();
			label.styleName = getStyleName( "" );
			label.styleManager = styleManager;
			label.text = " ";
			label.build();
			label.setStyle();
			label.arrange();
			addChild( label );
			
			super.build();
		}
		
		override public function purge() : void {
			
			super.purge();
			
			_parser = null;
			_styleNameCollection = null;
			_hiddenFormIDCollection = null;
			_history = null;
			
			label = null;
		}
		
		public function resize() : void {
			if ( stage && label ) {
				label.x = int( stage.stageWidth - label.width - 10 );
				label.y = stage.stageHeight - 40;
			}
		}
		
		/**
		 * Required methods for visibility change based on history
		 */
		public function showFormComplete() : void {
			
			if ( label ) {
				
				var progressStr : String = "";
				
				if ( _parser && _parser.data ) {
					var resourceID : String = _parser.data.getProgressItemByFormID( _currentFormID ).id;
					progressStr = " - " + _parser.getContent( "ProgressBar", resourceID, "Content" );
				}
				
				label.text = "Form " + ( _history ? _history.length : "" ) + " of " + _totalForms + progressStr;
				resize();
			}
		}
		
		public function showForm( direction : int = 0 ) : void {
			
			
			// toggle visibility
			visible = true;
			var it : IIterator = _hiddenFormIDCollection.iterator();
			while( it.hasNext() ) {
				var id : String = String( it.next() );
				if ( id == _currentFormID )
					visible = false;
			}
			it.purge();
			it = null;
		}
		
		protected function getStyleName( id : String ) : String {
			var cssID : String;
			if ( _styleNameCollection ) {
				var cssDataItem : CSSDataItem = styleNameCollection.find( id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}
		
		public function get parser() : SurveyDataParser { return _parser; }
		public function set parser( value : SurveyDataParser ) : void { _parser = value; }
		
		public function get styleNameCollection() : ICollection { return _styleNameCollection; }
		public function set styleNameCollection( value : ICollection ) : void { _styleNameCollection = value; }
		
		public function get hiddenFormIDCollection() : ICollection { return _hiddenFormIDCollection; }
		public function set hiddenFormIDCollection( value : ICollection ) : void { _hiddenFormIDCollection = value; }
		
		public function get currentFormID() : String { return _currentFormID; }
		public function set currentFormID( value : String ) : void { _currentFormID = value; }
		
		public function get history() : Array { return _history; }
		public function set history( value : Array ) : void { _history = value; }
		
		public function get totalForms():uint { return _totalForms; }

		public function set totalForms( value:uint ):void
		{
			_totalForms = value;
		}

		public function hideForm( direction:int = 0 ):void
		{
		}

		public function hideFormComplete():void
		{
		}
	}
}