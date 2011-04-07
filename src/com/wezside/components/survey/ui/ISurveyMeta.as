package com.wezside.components.survey.ui 
{
	import com.wezside.components.survey.data.IFormMetaData;

	import flash.geom.Rectangle;
	/**
	 * @author Sean Lailvaux
	 */
	public interface ISurveyMeta extends ISurveyUIElement
	{
		function updateContent( data:IFormMetaData ):void;		function updateLayout( currentFormRectangle:Rectangle ):void;
	}
}