package com.wezside.components.survey.validate 
{
	import com.wezside.components.survey.form.IForm;
	import com.wezside.components.survey.form.IFormGroup;
	import com.wezside.components.survey.form.IFormItem;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.manager.state.StateManager;

	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IValidate 
	{
		function get iterator():IIterator;
		function set iterator( value:IIterator ):void;
		
		function get group():IFormGroup;
		function set group( value:IFormGroup ):void;
		
		function get form():IForm;
		function set form( value:IForm ):void;
		
		function get configState():StateManager;
		function set configState( value:StateManager ):void;
		
		function validate( item:IFormItem ):Boolean;
	}
}
