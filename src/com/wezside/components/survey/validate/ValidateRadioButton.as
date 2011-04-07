package com.wezside.components.survey.validate
{
	import com.wezside.components.survey.form.FormItem;
	import com.wezside.components.survey.form.IForm;
	import com.wezside.components.survey.form.IFormGroup;
	import com.wezside.components.survey.form.IFormItem;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.manager.state.StateManager;
	import com.wezside.utilities.validator.Validator;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ValidateRadioButton implements IValidate
	{
		
		private var _iterator:IIterator;
		private var _validator:Validator;
		private var _group:IFormGroup;
		private var _form:IForm;

		public function ValidateRadioButton() 
		{
			_validator = new Validator([]);	
		}		
		
		public function validate( item:IFormItem ):Boolean
		{
			_iterator.reset();
			while ( _iterator.hasNext() )
			{
				var formItem:IFormItem = iterator.next() as IFormItem;
				if ( formItem.type == FormItem.ITEM_RADIO_BUTTON && formItem.id != item.id )
					formItem.selected = false;
			}
			return true;
		}
		
		public function get iterator():IIterator
		{
			return _iterator;
		}
		
		public function set iterator( value:IIterator ):void
		{
			_iterator = value;
		}
		
		public function get group():IFormGroup
		{
			return _group;
		}
		
		public function get form():IForm
		{
			return _form;
		}
		
		public function set group( value:IFormGroup ):void
		{
			_group = value;
		}
		
		public function set form( value:IForm ):void
		{
			_form = value;
		}

		public function get configState() : StateManager {
			return null;
		}

		public function set configState(value : StateManager) : void {
		}
	}
}
