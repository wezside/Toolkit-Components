package com.wezside.components.survey.ui 
{
	import com.wezside.components.UIElement;

	import flash.geom.Rectangle;
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface ISurveyNavigation extends ISurveyUIElement
	{
		function getButton( id:String ):UIElement;
		function surveyEnd():void;
		function validate( value:Object ):void;
		function updateLayout( currentFormRectangle:Rectangle ):void;
	}
}