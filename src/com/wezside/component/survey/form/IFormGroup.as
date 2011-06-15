package com.wezside.component.survey.form
{
	import com.wezside.component.IUIElement;
	import com.wezside.component.survey.data.IFormGroupData;
	

	/**
	 * @author DaSmith
	 */
	public interface IFormGroup extends IUIElement
	{
		function getItemByID( id:String ):IFormItem;

		function set data( value:IFormGroupData ):void;

		function get data():IFormGroupData;

		function get parentForm():IForm;

		function set parentForm( value:IForm ):void;
	}
}
