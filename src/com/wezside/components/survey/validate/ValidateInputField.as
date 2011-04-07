package com.wezside.components.survey.validate 
{
	import com.wezside.components.survey.Survey;
	import com.wezside.components.survey.form.IForm;
	import com.wezside.components.survey.form.IFormGroup;
	import com.wezside.components.survey.form.IFormItem;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.manager.state.StateManager;
	import com.wezside.utilities.validator.Validator;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ValidateInputField implements IValidate
	{
		private var _validator : Validator;
		private var _configState : StateManager;

		public function ValidateInputField() 
		{
			_validator = new Validator([]);	
		}		
		
		public function validate( item:IFormItem ):Boolean
		{
			////////////check maximum character length
			if(item.data.maxLength)
			{
				if(Number(item.data.maxLength)!=-1 && int(item.value) > int(item.data.maxLength))
				{
						item.value = item.value.substr(0,int(item.data.maxLength));
				}else{
					item.value=String(int(item.value));
				}
			}		
			switch ( item.id ) 
			{
				case "Age":
					if ( _validator.validateForNumerical( item.value ) ) 
					{
						item.value =String(int(item.value));
						item.valid = ( 20 <= Number( item.value ) && Number( item.value ) <= 80 );
//						item.valid =(int(item.value.length) <= int(item.data.maxLength));
						
//						trace(item.value.length,item.data.maxLength);
					}else{
						item.valid = false;
					}
				break;
				
				// These are validated in the class ValidateLinkedItems as all height input fields are linked with each other
				case "Height": 
					item.valid = (120 <= Number( item.value ) && Number( item.value ) <= 240);
				break;
				case "Weight": 
					item.valid = (30 <= Number( item.value ) && Number( item.value ) <= 230);
				break;
				case "Waist": 
					item.valid = (25 <= Number( item.value ) && Number( item.value ) <= 254);					 

				break;
					 
				case "TotalChol":
					var totlCholValid:Boolean = _validator.validateForNumerical( item.value ); 
					if(totlCholValid)
					{
						totlCholValid = validateColesterol(item);
					}
					
					item.valid = totlCholValid; 
					break;
					
				case "HDLChol":
					var newValue:String= trim( item.value );
					var hdlInvalid:Boolean = false; 
					if(newValue!="" && !isNaN(Number(newValue)))hdlInvalid=true;
					if(hdlInvalid)hdlInvalid = validateColesterolHDL(item);
					item.valid = hdlInvalid;
					newValue=null;
					break;
					
				case "SystolicBP":
					var bpValid:Boolean = _validator.validateForNumerical( item.value );
					if ( bpValid )bpValid = ( 80 <= Number( item.value ) && Number( item.value ) <= 220 );
					item.valid = bpValid;
					break;
					
				case "MothersHeartAge":
					item.valid = _validator.validateForNumerical( item.value );		
					break;
					
				case "FathersHeartAge":
					item.valid = _validator.validateForNumerical( item.value );
					break;
					
				case "Email":
				case "EmailAddress":
					item.valid = _validator.validateEmail( item.value );
					break;
				case "feet":
				case "inches":
				case "stone":
				case "pounds":
				case "waist_inches":
				item.value =String(int(item.value));
				break;	
				default:				
					item.valid = _validator.validateString( item.value, 1 );
					break;
			}
			return item.valid;
		}

		private function validateColesterolHDL(item : IFormItem) : Boolean {
			if(_configState.compare(Survey.UNIT_CHOLESTEROL_MMOL))
			{
				return ( 0 <= Number( item.value ) && Number( item.value ) <= 3 );
			}else{
				
				return ( 1 <= Number( item.value ) && Number( item.value ) <= 100 );
			}
		}

		private function validateColesterol(item:IFormItem) : Boolean {
			if(_configState.compare(Survey.UNIT_CHOLESTEROL_MMOL))
			{
				return ( 2 <= Number( item.value ) && Number( item.value ) <= 12 );
			}else{
				return ( 35 <= Number( item.value ) && Number( item.value ) <= 360 );
			}
			
		}
		
		public function get iterator():IIterator
		{
			return null;
		}
		
		public function set iterator( value:IIterator ):void
		{
		}
		
		public function get group():IFormGroup
		{
			return null;
		}
		
		public function get form():IForm
		{
			return null;
		}
		
		public function set group(value:IFormGroup):void
		{
		}
		
		public function set form(value:IForm):void
		{
		}

		public function get configState() : StateManager {
			return _configState;
		}

		public function set configState(value : StateManager) : void {
			_configState= value;
		}
		 public static function isWhitespace( ch:String ):Boolean {
      		return ch == '\r' || 
             ch == '\n' ||
             ch == '\f' || 
             ch == '\t' ||
             ch == ' '; 
    	}
    
   	 	public static function trim( original:String ):String {
    
      	var characters:Array = original.split( "" );
    
	      for ( var i:int = 0; i < characters.length; i++ ) {
	        if ( isWhitespace( characters[i] ) ) {
	          characters.splice( i, 1 );
	          i--;
	        } else {
	          break;
	        }
	      }
	      return characters.join("");
	   }
	}
}
