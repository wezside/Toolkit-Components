package com.wezside.component.survey.form.item
{
	import com.wezside.component.UIElementState;
	import com.wezside.component.decorator.shape.ShapeRectangle;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.component.survey.form.FormEvent;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.component.text.InputField;
	import com.wezside.data.collection.ICollection;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.filters.GlowFilter;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormInputField extends InputField implements IFormItem
	{
		private var _data:IFormItemData;

		public function FormInputField()
		{
			background = new ShapeRectangle( this );
			background.colours = [ 0xffffff, 0xffffff ];
			background.alphas = [ 1, 1 ];
			background.cornerRadius = 10;
			DisplayObject( background ).filters = [ new GlowFilter( 0xC1C4B8, 1 ) ];
		}

		override public function build():void
		{
			styleName = getStyleName( data.id );
			super.build();
			value = data.value;
		}

		override public function setStyle():void
		{
			super.setStyle();
			valid = data.valid;
		}

		override public function set state( value:String ):void
		{
			super.state = value;
			_data.state = value;

			switch ( value )
			{
				case UIElementState.STATE_VISUAL_UP:
					editable = true;
					selectable = true;
					break;
				case UIElementState.STATE_VISUAL_DISABLED:
					editable = false;
					selectable = false;
					break;
			}
		}

		override protected function focusIn( event:Event = null ):void
		{
			setFocus();
			if ( field.text == data.defaultValue || field.text == data.value ) field.text = "";
			if ( !data.valid ) DisplayObject( background ).filters = [ new GlowFilter( 0x7f7f7f, 1 ) ];
			dispatchEvent( new FormEvent( FormEvent.FORM_FOCUS_IN, true ) );
		}

		override protected function focusOut( event:FocusEvent ):void
		{
			_data.value = _data.value != "" ? _data.value : data.defaultValue;
			field.text = _data.value == "" ? " " : _data.value;
			if ( !data.valid ) DisplayObject( background ).filters = [ new GlowFilter( 0xC1C4B8, 1 ) ];
			dispatchEvent( new FormEvent( FormEvent.FORM_FOCUS_OUT, true ) );
		}

		public function set valid( value:Boolean ):void
		{
			data.valid = value;
			if ( value )
			{
				textColor = 0x9EC22C;
				DisplayObject( background ).filters = [ new GlowFilter( 0x9EC22C, 1 ) ];
			}
			else
			{
				textColor = 0xC1C4B8;
				DisplayObject( background ).filters = [ new GlowFilter( 0xC1C4B8, 1 ) ];
			}
		}

		public function get displayAsPassword():Boolean
		{
			return field.displayAsPassword;
		}

		public function set displayAsPassword( value:Boolean ):void
		{
			field.displayAsPassword = value;
		}

		public function get data():IFormItemData
		{
			return _data;
		}

		public function set data( value:IFormItemData ):void
		{
			_data = value;
		}

		public function get id():String
		{
			return data.id;
		}

		public function get selected():Boolean
		{
			return stateManager.compare( UIElementState.STATE_VISUAL_SELECTED );
		}

		public function set selected( value:Boolean ):void
		{
			state = "";
			state = UIElementState.STATE_VISUAL_UP;
			if ( value ) state = UIElementState.STATE_VISUAL_SELECTED;
		}

		public function get type():String
		{
			return data.type;
		}

		public function get valid():Boolean
		{
			return data.valid;
		}

		public function get value():String
		{
			return data.value;
		}

		public function set value( value:String ):void
		{
			data.value = value;
			if ( !value || value.length == 0 )
			{
				super.text = data.defaultValue;
			}
			else
			{
				super.text = value;
			}
		}

		override protected function changeHandler( event:Event = null ):void
		{
			if ( _data.id.toLowerCase() == "email" )
			{
				var s:String = field.text;
				if ( s.indexOf( "\"" ) > -1 )
				{
					s = s.replace( "\"", "@" );
				}
				field.text = s;
			}

			_data.value = field.text;
			var formEvent:FormEvent = new FormEvent( FormEvent.ITEM_STATE_CHANGE, true );
			formEvent.data = _data;
			dispatchEvent( formEvent );
		}

		protected function getStyleName( id:String ):String
		{
			var cssID:String;
			if ( _data && _data.styleNameCollection )
			{
				var cssDataItem:CSSDataItem = data.styleNameCollection.find( "id", id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}

		public function setDataCollection( collection:ICollection ):void
		{
		}
	}
}
