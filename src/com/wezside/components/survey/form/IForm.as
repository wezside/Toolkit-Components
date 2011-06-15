package com.wezside.component.survey.form 
{
	import com.wezside.component.survey.data.IFormData;
	import com.wezside.components.IUIElement;

	public interface IForm extends IUIElement
	{
		function get data():IFormData;		
		function set data(value:IFormData):void;
		 
		function get questions():FormQuestions;
		function set questions( value:FormQuestions ):void;
		
		function show(direction:int=0):void;
		function hide(direction:int=0):void;
		function resize():void;	
		function getUIItem( id:String ):IFormItem;

		function getFormGroupByID( id:String ):IFormGroup;

		function hideGroups():void;
		function showGroups():void;
	}
}
