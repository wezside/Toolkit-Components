package com.wezside.components.survey.ui
{
	import com.wezside.components.IUIElement;
	import com.wezside.components.survey.SurveyDataParser;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public interface ISurveyUIElement extends IUIElement {
		
		function get parser() : SurveyDataParser;
		function set parser( value : SurveyDataParser ) : void;
		
		function get styleNameCollection() : ICollection;
		function set styleNameCollection( value : ICollection ) : void;
		
		function get hiddenFormIDCollection() : ICollection;
		function set hiddenFormIDCollection( value : ICollection ) : void;
		
		function get history() : Array;
		function set history( value : Array ) : void;
		
		function get totalForms() : uint;
		function set totalForms( value : uint ) : void;
		
		function get currentFormID() : String;
		function set currentFormID( value : String ) : void;
		
		function showForm( direction : int = 0 ) : void;
		function hideForm( direction : int = 0 ) : void;
		
		function showFormComplete() : void;
		function hideFormComplete() : void;
		
		function resize() : void;
	}
}