package com.wezside.components.survey.form 
{
	import com.wezside.data.collection.ICollection;
	import com.wezside.components.IUIElement;
	import com.wezside.components.survey.data.IFormData;

	public interface IForm extends IUIElement
	{
		function get data():IFormData;		
		function set data(value:IFormData):void;
	 
		function get questions():FormQuestions;
		function set questions( value:FormQuestions ):void;
		
		function get groupCollection():ICollection;
		function set groupCollection( value:ICollection ):void;
		
		function show(direction:int=0):void;
		function hide(direction:int=0):void;
		function resize():void;	
		function getUIItem( id:String ):IFormItem;

		function getFormGroupByID( id:String ):IFormGroup;

		function hideGroups( item:IFormItem ):void;
		function showGroups( item:IFormItem ):void;
	}
}
