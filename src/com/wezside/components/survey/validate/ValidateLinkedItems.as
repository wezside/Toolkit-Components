package com.wezside.components.survey.validate
{
	import com.wezside.components.UIElementState;
	import com.wezside.components.survey.form.IForm;
	import com.wezside.components.survey.form.IFormGroup;
	import com.wezside.components.survey.form.IFormItem;
	import com.wezside.components.survey.form.item.CustomInputField;
	import com.wezside.components.survey.util.Calculations;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.manager.state.StateManager;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ValidateLinkedItems implements IValidate 
	{
		private var _form:IForm;
		private var _group:IFormGroup;
		private var _iterator:IIterator;
		private var calc:Calculations;

		public function validate( item:IFormItem ):Boolean
		{
			var form:IForm = _form;
			var group:IFormGroup = _group;
			var linkedGroup:IFormGroup;
			var linkedItem:IFormItem;
			
			switch ( group.data.id )
			{
				case "MothersHeartHistory": 
					linkedGroup = form.getFormGroupByID( "MothersHeartAge" );
					linkedItem = linkedGroup.getItemByID( "Age" );
					parentHeartHistory( linkedGroup, linkedItem, item );
					break;
					
				case "FathersHeartHistory": 
					linkedGroup = form.getFormGroupByID( "FathersHeartAge" );
					linkedItem = linkedGroup.getItemByID( "Age" );
					parentHeartHistory( linkedGroup, linkedItem, item );
					break;
					
				case "MothersHeartAge":
					break;
					
				case "FathersHeartAge":
					break;
					
				case "HDLChol":
					hdCholValidation(item,linkedItem,linkedGroup);
					break;
					
				case "dontKnowGroup":
					linkedGroup = form.getFormGroupByID( "HDLChol" );
					linkedItem = linkedGroup.getItemByID( "HDLChol" );
					linkedItem.valid = ( linkedItem.value != "" && linkedItem.value != " " );
					
					break;
					
				case "SmokingHistory":
					
					linkedGroup = form.getFormGroupByID( "RecentlyStoppedSmoking" );
					if ( linkedGroup )
					{
					if ( item.id == "No" )
					{
						linkedGroup.data.valid = false;
						linkedGroup.getItemByID( "No" ).selected = false;
						linkedGroup.getItemByID( "No" ).activate();
						linkedGroup.getItemByID( "Yes" ).selected = false;
						linkedGroup.getItemByID( "Yes" ).activate();
					}
					
					if ( item.id == "Yes" ) 
					{
						linkedGroup.data.valid = true;
						linkedGroup.getItemByID( "No" ).valid = true;
						linkedGroup.getItemByID( "No" ).selected = false;
						linkedGroup.getItemByID( "No" ).state = UIElementState.STATE_VISUAL_DISABLED;
						linkedGroup.getItemByID( "No" ).deactivate();
						linkedGroup.getItemByID( "Yes" ).valid = true;
						linkedGroup.getItemByID( "Yes" ).selected = false;
						linkedGroup.getItemByID( "Yes" ).state = UIElementState.STATE_VISUAL_DISABLED;
						linkedGroup.getItemByID( "Yes" ).deactivate();
					}
					}
					break;
				case "Height": 
					calc = new Calculations( );
					calc.updateHeight( group, item.id );
					calc.updateBMI( form );
					calc = null;
					break;
					
				case "Weight": 
					calc = new Calculations( );
					calc.updateWeight( group, item.id );
					calc.updateBMI( form );
					calc = null;
					break;
					
				case "Waist": 
					calc = new Calculations( );
					calc.updateWaist( group, item.id );
					calc.updateBMI( form );
					calc = null;
					break;
				case "TotalChol":
				break;
				case "MedicationChol":
					linkedGroup = form.getFormGroupByID( "CholSlider" );
					if(linkedGroup)
					{
						if(item.id=="Yes")
						{
							linkedGroup.getItemByID("Slider").value="1";
						}else if(item.id=="No"){
							linkedGroup.getItemByID("Slider").value="0";
						}
					}
				break;					
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
		
		
		/**
		 * This method will validate Mother and Father's heart history age. 
		 */
		private function  hdCholValidation(item:IFormItem,linkedItem:IFormItem,linkedGroup:IFormGroup):void{
			linkedGroup = form.getFormGroupByID( "HDLChol" );
			var totalLinkedGroup:IFormGroup = form.getFormGroupByID( "TotalChol" );
			linkedItem = linkedGroup.getItemByID( "HDLChol" );
			var totalItem:IFormItem = totalLinkedGroup.getItemByID( "TotalChol" );
			if ( item.selected ) {
				linkedItem.state = "";
				linkedItem.state = UIElementState.STATE_VISUAL_DISABLED;
				linkedItem.data.value = " ";
				linkedItem.value = " ";
				linkedItem.data.valid = true;
//				CustomInputField(linkedItem).editable = false;
//				CustomInputField(linkedItem).selectable = false; 
//				linkedItem.deactivate();
				item.data.valid = true;
				linkedGroup.data.valid = true;
			}
			else {
				if(linkedItem.value == "" || linkedItem.value == " ")
				{
					linkedItem.value = " ";
					linkedItem.valid=false;
					linkedItem.data.valid = false;
					
				}
				item.data.valid = false;
				if ( linkedItem.valid ) linkedGroup.data.valid = true; 
				linkedItem.state = UIElementState.STATE_VISUAL_UP;
				linkedItem.activate();
				CustomInputField(linkedItem).editable = true;
				CustomInputField(linkedItem).selectable = true; 
			}
			totalLinkedGroup = null;
			totalItem = null;
		}
		private function parentHeartHistory( linkedGroup:IFormGroup, linkedItem:IFormItem, selectedItem:IFormItem ):void
		{
			if ( selectedItem.id == "No" )
			{
				linkedItem.value=" ";
				linkedGroup.data.valid = true; 
				linkedItem.valid = true;				
				linkedItem.state = UIElementState.STATE_VISUAL_DISABLED;
				linkedItem.deactivate();
			}
			if ( selectedItem.id == "Yes")
			{
				if ( !selectedItem.selected ) 
				{
					linkedItem.state = UIElementState.STATE_VISUAL_DISABLED;
					linkedItem.deactivate();
				}		
				else 
				{
					linkedItem.state = UIElementState.STATE_VISUAL_UP;
					linkedItem.activate();
					linkedGroup.data.valid = false; 
					linkedItem.valid = false;
				}
			}		
		}

		public function get configState() : StateManager {
			return null;
		}

		public function set configState(value : StateManager) : void {
		}
	}
}
