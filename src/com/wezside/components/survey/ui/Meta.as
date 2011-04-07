package com.wezside.components.survey.ui
{
	import com.wezside.components.UIElement;
	import com.wezside.components.survey.SurveyDataParser;
	import com.wezside.components.survey.data.IFormMetaData;
	import com.wezside.components.survey.data.config.CSSDataItem;
	import com.wezside.data.collection.ICollection;

	import flash.geom.Rectangle;


	/**
	 * @author Sean Lailvaux
	 */
	public class Meta extends UIElement implements ISurveyMeta {

		private var _styleNameCollection : ICollection;
		private var _history : Array = [];
		private var _hiddenFormIDCollection : ICollection;
		private var _currentFormID : String;
		private var _totalForms : uint;
		private var _parser : SurveyDataParser;

		
		

		public function resize() : void 
		{
			//
		}
		
		public function showForm( direction : int = 0 ) : void 
		{
			//
		}
		
		public function hideForm( direction : int = 0 ) : void 
		{
			//
		}
		
		public function showFormComplete() : void 
		{
			//
		}
		
		public function hideFormComplete() : void 
		{
			//
		}
		
		public function updateContent( data : IFormMetaData ) : void 
		{
			//
		}
		
		public function updateLayout( currentFormRectangle : Rectangle ) : void 
		{
			//
		}

		
		override public function purge() : void {
			
			super.purge();
			
			_styleNameCollection = null;
			_history = null;
			_hiddenFormIDCollection = null;
			_parser = null;
		}

		
		protected function getStyleName( id : String ) : String {
			var cssID : String;
			if ( _styleNameCollection ) {
				var cssDataItem : CSSDataItem = styleNameCollection.find("id", id) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}

		
		public function get currentFormID() : String { 
			return _currentFormID; 
		}

		public function set currentFormID( value : String ) : void { 
			_currentFormID = value; 
		}

		public function get hiddenFormIDCollection() : ICollection { 
			return _hiddenFormIDCollection; 
		}

		public function set hiddenFormIDCollection( value : ICollection ) : void { 
			_hiddenFormIDCollection = value; 
		}

		public function get history() : Array { 
			return _history; 
		}

		public function set history( value : Array ) : void { 
			_history = value; 
		}

		public function get parser() : SurveyDataParser { 
			return _parser; 
		}

		public function set parser( value : SurveyDataParser ) : void { 
			_parser = value; 
		}

		public function get styleNameCollection() : ICollection { 
			return _styleNameCollection; 
		}

		public function set styleNameCollection( value : ICollection ) : void { 
			_styleNameCollection = value; 
		}

		public function get totalForms() : uint { 
			return _totalForms; 
		}

		public function set totalForms( value : uint ) : void { 
			_totalForms = value; 
		}
	}
}
