package com.wezside.component.survey.data
{
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;

	/**
	 * @author Wesley.Swanepoel
	 */
	public interface ISurveyData
	{
		function debug():void;

		function get iterator():IIterator;
		
		function addFormData( formData:IFormData ):void;
		function getFormData( id:String ):IFormData;
		function removeFormData( id:String ):void;
		function getFormGroupData( id:String ):IFormGroupData;
		function reset():void;
		function purgeData():void;

		function get formData():ICollection;
		function set formData( value:ICollection ):void;

		function get component():ICollection;
		function set component( value:ICollection ):void

		function get customCSS():ICollection
		function set customCSS( value:ICollection ):void;

		function get customForm():ICollection;
		function set customForm( value:ICollection ):void;

		function get ignoreList():ICollection;
		function set ignoreList( value:ICollection ):void;

		function get layout():ICollection;
		function set layout( value:ICollection ):void;

		function get progress():ICollection;
		function set progress( value:ICollection ):void;

		function get responseGroupings():ICollection;
		function set responseGroupings( value:ICollection ):void;
	}
}