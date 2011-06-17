package com.wezside.component.survey.validate
{
	import com.wezside.component.UIElement;
	import com.wezside.component.survey.data.IFormData;
	import com.wezside.component.survey.form.FormItem;
	import com.wezside.component.survey.form.IForm;
	import com.wezside.component.survey.form.IFormGroup;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.manager.state.StateManager;

	import flash.utils.getDefinitionByName;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormValidator
	{
	
			
		private var _valid:Boolean;
		private var _formData:IFormData;
		private var _configState:StateManager;
		private var _validateNS:Namespace = new Namespace( "", "com.wezside.component.survey.validate" );


		public function validate( formItem:IFormItem, formGroup:IFormGroup, form:IForm ):Boolean
		{
			_valid = validateItem( formItem, formGroup, form );
//			 trace( "Item validation", _valid );

			_valid = validateGroup( formItem, formGroup, form );
//			 trace( "Group validation", _valid );
			if ( !_valid ) return false;

			_valid = validateForm( form );
//			 trace( "Form validation", _valid );
			return _valid;
		}

		public function validateForm( form:IForm ):Boolean
		{
			var iterator:IIterator = form.questions.iterator( UIElement.ITERATOR_CHILDREN );
			formData.valid = true;
			while ( iterator.hasNext())
			{
				var item:* = iterator.next();
				if ( item is IFormGroup )
				{
					if ( !IFormGroup( item ).data.valid )
					{
						formData.valid = false;
						break;
					}
				}
			}
			return formData.valid;
		}

		private function validateGroup( formItem:IFormItem, formGroup:IFormGroup, form:IForm ):Boolean
		{
			formGroup.data.valid = false;

			var radioGroupValid:Boolean = false;			
			var it:IIterator = UIElement( formGroup ).iterator( UIElement.ITERATOR_CHILDREN );

			// Update Radio button selected state in same group
			if ( formItem.type == FormItem.ITEM_RADIO_BUTTON ||  formItem.type == "FormButton" )
			{
				customValidateItem( formItem, _validateNS, "ValidateRadioButton", form, formGroup, it );
			}

			// Reset and loop through collection looking for at least 1 item to be valid
			it.reset();
			while ( it.hasNext() )
			{
				var item:IFormItem = it.next() as IFormItem;
				// Validate for Input Field
				if ( 	item.type != FormItem.ITEM_TYPE_STATIC_TEXT && 
						item.type != FormItem.ITEM_CALL_TO_ACTION && 
						item.type != FormItem.ITEM_RADIO_BUTTON && 
						item.type != FormItem.ITEM_DO_NOT_KNOW && 
						item.type != FormItem.ITEM_SLIDER && 
						item.type != "FormButton" )
				{
					if ( !item.valid )
					{
						formGroup.data.valid = false;
						break;
					}
					formGroup.data.valid = item.valid;
				}
				
				// Validate for Radio + Checkboxes
				if ( item.type == FormItem.ITEM_RADIO_BUTTON || item.type == "FormButton" )
				{ 
					if ( item.valid )
					{
						radioGroupValid = true;
						formGroup.data.valid = true;
					}
					else if ( formGroup.data.valid && !radioGroupValid )
					{
						// Only set the form group invalid if the radio group doesn't 
						// contain a radio button which is valid
						formGroup.data.valid = false;
					}
				}
			}

			it.purge();
			it = null;
			return formGroup.data.valid;
		}

		private function validateItem( formItem:IFormItem, formGroup:IFormGroup, form:IForm ):Boolean
		{
			switch( formItem.data.type )
			{
				case "FormInputField" :
				case FormItem.ITEM_TEXT_INPUT :
					customValidateItem( formItem, _validateNS, "InputValidator", form, formGroup );
					break;
				case FormItem.ITEM_DO_NOT_KNOW :
				case "FormButton" :
				case FormItem.ITEM_RADIO_BUTTON :
					formItem.valid = formItem.selected;
					break;
				case FormItem.ITEM_CALL_TO_ACTION :
				case FormItem.ITEM_TYPE_STATIC_TEXT :
				case FormItem.ITEM_SLIDER :
					break;
			}
			return formItem.data.valid;
		}

		public function get formData():IFormData
		{
			return _formData;
		}

		public function set formData( value:IFormData ):void
		{
			_formData = value;
		}

		public function get validateNS():Namespace
		{
			return _validateNS;
		}

		public function set validateNS( value:Namespace ):void
		{
			_validateNS = value;
		}

		public function purge():void
		{
			_configState = null;
			if ( _formData ) _formData.purge();
			_formData = null;
		}

		private function customValidateItem( formItem:IFormItem, ns:Namespace, className:String, form:IForm = null, group:IFormGroup = null, iterator:IIterator = null ):Boolean
		{
			var clazz:Class = getDefinitionByName( ns + "::" + className ) as Class;
			var inputValidator:IValidate = new clazz() as IValidate;
			inputValidator.iterator = iterator;
			inputValidator.form = form;
			inputValidator.group = group;
			inputValidator.configState = _configState;
			return inputValidator.validate( formItem );
		}

		public function get configState():StateManager
		{
			return _configState;
		}

		public function set configState( value:StateManager ):void
		{
			_configState = value;
		}
	}
}
