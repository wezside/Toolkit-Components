package com.wezside.components.survey.util 
{
	import com.wezside.components.survey.form.IForm;
	import com.wezside.components.survey.form.IFormGroup;
	import com.wezside.components.survey.form.IFormItem;
	import com.wezside.utilities.logging.Tracer;

	import flash.utils.getQualifiedClassName;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class Calculations 
	{

		public function updateHeight( group:IFormGroup, selectedID:String ):Number 
		{
			if ( !group ) 
			{
				Tracer.output( true, " Calculations updateHeight error: " + group + ", " + selectedID, getQualifiedClassName( this ), Tracer.ERROR );
				return 0;
			}
			
//			Tracer.output( true, " Calculations.updateHeight(" + group + ", " + selectedID + ")", getQualifiedClassName(this) );
			
			var validHeight:Boolean = true;			
			var feet:IFormItem = group.getItemByID( "feet" );
			var inches:IFormItem = group.getItemByID( "inches" );
			var cm:IFormItem = group.getItemByID( "Height" );
			
			var cm_feet:Number;
			var cm_inches:Number;
			var cmNum:Number; 		
			
			if ( feet && inches && cm ) 
			{
				
				switch ( selectedID.toLowerCase() ) 
				{
					case "feet" : 
						cm_feet = (Number( feet.value ) / .0328 );
						cm_inches = (Number( inches.value ) * 2.54);
						cmNum = cm_feet + cm_inches;
						cm.value = Math.round( cmNum ).toString( );
						inches.value = inches.value.length == 0 || feet.value == "NaN" ? "0" : inches.value;
						break;
						
					case "inches" : 
						// Setting cm
						cm_feet = (Number( feet.value ) / .0328 );
						cm_inches = (Number( inches.value ) * 2.54);
						cmNum = cm_feet + cm_inches;
						cm.value = Math.round( cmNum ).toString( );
						feet.value = feet.value.length == 0 || feet.value == "NaN" ? "0" : feet.value;
						break;
						
					case "height" : 
						//Centimeters
						var feetCalc:Number = Math.floor( ( Number( cm.value ) * 0.39) / 12 );
						var inchesCalc:Number = Math.round( ( Number( cm.value ) * 0.39) % 12 );
						feet.value = String( isNaN( feetCalc ) ? 0 : feetCalc );
						inches.value = String( isNaN( inchesCalc ) ? 0 : inchesCalc );
						break;
						
					default : break;
				}
				
				//validHeight = !(Number( inches.value ) >= 0 && Number( inches.value ) < 12); 
				validHeight = (120 <= Number( cm.value ) && Number( cm.value ) <= 240); 
				
				cm.valid = validHeight;	
				feet.valid = validHeight;
				inches.valid = validHeight;
				
				return Number( cm.value );
			}
			return 0;
		}

		
		public function updateWeight( group:IFormGroup, selectedID:String ):Number 
		{
			if ( !group ) 
			{
				Tracer.output( true, " Calculations updateWeight error: " + group + ", " + selectedID, getQualifiedClassName( this ), Tracer.ERROR );
				return 0;
			}
			
			var invalidWeight:Boolean = true;			
			var stone:IFormItem = group.getItemByID( "stone" );
			var pounds:IFormItem = group.getItemByID( "pounds" );
			var kg:IFormItem = group.getItemByID( "Weight" );				
			
			var kg_stone:Number;
			var kg_pounds:Number;
			var kgNum:Number; 			
			
			if ( stone && pounds && kg ) 
			{
				switch ( selectedID ) 
				{
					case stone.id : 
						kg_stone = Math.round((Number( stone.value ) * 14) / 2.205) ;
						kg_pounds = Math.round((Number( pounds.value ) / 2.205) * 10);
						kgNum = kg_stone + kg_pounds / 10;
						kg.value = Math.round( kgNum ).toString( );
						pounds.value = pounds.value.length == 0 || pounds.value == "NaN" ? "0" : pounds.value;
						break;
						
					case pounds.id : 
						kg_stone = (Number( stone.value ) * 14) / 2.205 ;
						kg_pounds = (Number( pounds.value ) / 2.205) * 10;
						kgNum = kg_stone + kg_pounds / 10;
						kg.value = Math.round( kgNum ).toString( );
						stone.value = stone.value.length == 0 || pounds.value == "NaN" ? "0" : stone.value;
						break;
						
					case kg.id : 
						var stonCalc:Number = Math.floor( ( Number( kg.value ) * 2.205) / 14 );
						var poundsCalc:Number = Math.round( ( Number( kg.value ) * 2.205) % 14 );
						stone.value = String( isNaN( stonCalc ) ? 0 : stonCalc );
						pounds.value = String( isNaN( poundsCalc ) ? 0 : poundsCalc );
						break;
				}
				
				invalidWeight = (30 <= Number( kg.value ) && Number( kg.value ) <= 230);
				
				stone.valid = invalidWeight; 
				pounds.valid = invalidWeight;			 
				kg.valid = invalidWeight;
				
				return Number( kg.value );
			}
			return 0;
		}

		public function updateWaist( group:IFormGroup, selectedID:String ):void 
		{
			if ( !group ) 
			{
				Tracer.output( true, " Calculations updateWaist error: " + group + ", " + selectedID, getQualifiedClassName( this ), Tracer.ERROR );
				return;
			}
			
			var invalidWaist:Boolean = true;	
			var cm:IFormItem = group.getItemByID( "Waist" );
			var inches:IFormItem = group.getItemByID( "waist_inches" );
			
			if ( cm && inches ) 
			{
				if ( cm.id == selectedID ) 
				{
					var inchesCalc:Number = Math.round( Number( cm.value ) / 2.54 );
					inches.value = String( isNaN( inchesCalc ) ? 0 : inchesCalc );
				}
				else 
				{
					var cmCalc:Number = Math.round( Number( inches.value ) * 2.54 );
					cm.value = String( isNaN( cmCalc ) ? 0 : cmCalc );
				}
	
				invalidWaist = (25 <= Number( cm.value ) && Number( cm.value ) <= 254); 			
				cm.valid = invalidWaist;				
				inches.valid = invalidWaist;
			}
		}

		public function updateBMI( form:IForm ):void
		{
			if ( !form ) 
			{
				Tracer.output( true, " Calculations updateBMI: form was null", getQualifiedClassName( this ), Tracer.ERROR );
				return;
			}
			
			var height : IFormGroup = form.getFormGroupByID( "Height" );
			var weight : IFormGroup = form.getFormGroupByID( "Weight" );
			var bmi : IFormGroup = form.getFormGroupByID( "Weight" );
			
			if ( height && weight && bmi ) 
			{
				var height_cm:Number = Number( height.getItemByID( "Height" ).value );
				var weight_kg:Number = Number( weight.getItemByID( "Weight" ).value );
				var bmiString:String = String( calculateBMI( height_cm, weight_kg ) );
				if(bmi.getItemByID( "bmi_text_dynamic" ).data.maxLength)
				{
					if(Number(bmi.getItemByID( "bmi_text_dynamic" ).data.maxLength)!=-1 && int(bmiString) > int(bmi.getItemByID( "bmi_text_dynamic" ).data.maxLength))
					{
						bmiString = bmiString.substr(0,int(bmi.getItemByID( "bmi_text_dynamic" ).data.maxLength));	
					}
				}
				bmi.getItemByID( "bmi_text_dynamic" ).value = bmiString;
			}
		}

		private function calculateBMI( height_cm:Number, weight_kg:Number ):Number 
		{
			if( height_cm > 0 && weight_kg > 0)
			{
				return Math.round( weight_kg / Math.pow( ( height_cm / 100), 2 ) );
			}
			
			return 0;
		}
	}
}
