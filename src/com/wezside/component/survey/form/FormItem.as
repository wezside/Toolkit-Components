package com.wezside.component.survey.form
{
	import com.wezside.component.UIElement;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 * 
	 * Abstract class for building custom IFormItem classes
	 */
	public class FormItem extends UIElement implements IFormItem
	{
		public static const ITEM_DO_NOT_KNOW:String 		= "CheckBox";
		public static const ITEM_TYPE_STATIC_TEXT:String 	= "FormLabel";
		public static const ITEM_RADIO_BUTTON:String 		= "RadioButton";
		public static const ITEM_TEXT_INPUT:String 			= "CustomInputField";
		public static const ITEM_CALL_TO_ACTION:String 		= "CallToAction";
		public static const ITEM_SLIDER:String 				= "Slider";
		public static const ITEM_GROUP:String 				= "GroupedFormItem";
		
		private var _valid:Boolean;
		private var _selected:Boolean;
		private var _value:String;
		private var _type:String;
		private var _data:ICollection = new Collection();

		override public function purge():void
		{
			super.purge();
			_data = null;
		}

		public function setDataCollection( collection:ICollection ):void
		{
			_data = collection;
		}		

		public function get id():String
		{
			return _data.length > 0 ? data.id : "";
		}

		public function get type():String
		{
			return _type;
		}

		public function get value():String
		{
			return _value;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function get data():IFormItemData
		{
			return _data.length > 0 ? _data.getElementAt( 0 ) : null;
		}

		public function get valid():Boolean
		{
			return _valid;
		}

		public function set value( value:String ):void
		{
			_value = value;
		}

		public function set selected( value:Boolean ):void
		{
			_selected = value;
		}

		public function set data( value:IFormItemData ):void
		{
			_data.addElement( value );
		}

		public function set valid( value:Boolean ):void
		{
			_valid = value;
		}

	}
}
