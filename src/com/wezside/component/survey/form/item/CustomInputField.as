package com.wezside.component.survey.form.item 
{
	import com.wezside.component.UIElementState;
	import com.wezside.component.decorators.layout.HorizontalLayout;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.component.survey.form.FormEvent;
	import com.wezside.component.survey.form.IFormGroup;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.component.text.InputField;
	import com.wezside.component.text.Label;
	import com.wezside.utilities.logging.Tracer;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;


	/**
	 * @author WSwanepoel
	 */
	public class CustomInputField extends InputField implements IFormItem
	{
		private var label:Label;
		private var _parent:IFormGroup;
		private var _data:IFormItemData;
		private var _defaultValue:String = " ";

		override public function activate():void 
		{
			super.state = UIElementState.STATE_VISUAL_UP;
			field.addEventListener( Event.CHANGE, changeHandler );
			field.addEventListener( FocusEvent.FOCUS_IN, focusIn );
			field.addEventListener( FocusEvent.FOCUS_OUT, focusOut );
		}

		override public function build():void
		{
			layout = new HorizontalLayout( this );
			super.build();
			
			if ( styleManager == null ) styleManager = _data.styleManager;
			styleName = getStyleName( _data.id );
			value = _data.value;
			if ( value.length > 0 ) _defaultValue = value; 
			
			label = new Label();
			label.styleManager = _data.styleManager;
			
//			label.styleName = getStyleName( _data.id + "Fix" );
			label.styleName = "suffix";
			
			label.text = _data.suffix;
			label.width = 50;
			label.build();
			label.setStyle( );
			label.arrange( );
			addChild( label );						
		}
		
		override public function purge() : void {
			
			if ( field ) {
				field.removeEventListener( Event.CHANGE, changeHandler );
				field.removeEventListener( FocusEvent.FOCUS_IN, focusIn );
				field.removeEventListener( FocusEvent.FOCUS_OUT, focusOut );
			}
			
			super.purge();
			
			label = null;
			_parent = null;
			_data = null;
		}
		
		/**
		 * Hook in to the state setter to disable the input field when disabled state is set and 
		 * re-enable the field when UP state is set. The super will only change the text colour and skin
		 * and not anything else, so we need to set the label's selectable property to false if disabled and
		 * also unselect if the input field was selected. The STATE_VISUAL_SELECTED appear in front of the 
		 * disabled state in the skin hierarchy and therefore would cover the STATE_VISUAL_DISABLED.
		 */
		override public function set state(value:String):void 
		{
			super.state = value;
			_data.state = value;

			switch ( value )
			{
				case UIElementState.STATE_VISUAL_DISABLED:
					if ( stateManager.compare( UIElementState.STATE_VISUAL_SELECTED ))
						 super.state = UIElementState.STATE_VISUAL_SELECTED;
					editable = false;
					selectable = false; 
					_data.valid = false;
					if ( label ) label.state = UIElementState.STATE_VISUAL_DISABLED;
					super.text = _defaultValue;
					break;
					
				case UIElementState.STATE_VISUAL_UP:
					editable = true;
					selectable = true; 
					_data.valid = true;
					if ( label ) label.state = UIElementState.STATE_VISUAL_UP;
					break;
			}
		}
		
		override protected function changeHandler( event:Event = null ):void 
		{
			// FIX for older browsers (and Chrome!) where wmode changes
			// UK keyboard to US configuration (i.e. need to use shift+2 to create @ key)
			if ( _data.id == "Email" ) {
				var s : String = field.text;
				if ( s.indexOf( "\"" ) > -1 ) {
					s = s.replace( "\"", "@" );
				}
				field.text = s;
			}
			
			_data.value = field.text;		
			var formEvent:FormEvent = new FormEvent( FormEvent.ITEM_STATE_CHANGE, true );
			formEvent.data = _data;
			dispatchEvent( formEvent );			
		}

		override protected function focusIn( event:Event = null ):void 
		{
			field.setSelection( 0, field.length );	
			if ( field.text == _defaultValue ) field.text = "";
			field.stage.focus = field;
		}

		override protected function focusOut(event:FocusEvent):void 
		{
			Tracer.output( debug, " CustomInputField.focusOut(event)", getQualifiedClassName( this ));
			_data.value = _data.value != "" ? _data.value : _defaultValue;			
			field.text = _data.value; 
		}

		protected function mouseDown( event:MouseEvent ):void 
		{
			Tracer.output( debug, " CustomInputField.mouseDown(event)" + field.text.length, getQualifiedClassName( this ));				
		}

		public function destroy():void
		{
			purge( );
		}

		public function get id():String 
		{
			return _data ? _data.id : "";
		}

		public function get type():String 
		{
			return _data.type;
		}

		public function get selected():Boolean 
		{
			return stateManager.compare( UIElementState.STATE_VISUAL_SELECTED );
		}

		public function set selected( newValue:Boolean ):void 
		{
			if ( newValue ) 
			{
				if ( stateManager.compare( UIElementState.STATE_VISUAL_SELECTED ))
					 super.state = UIElementState.STATE_VISUAL_SELECTED;
			}
			else
			{
				if ( !stateManager.compare( UIElementState.STATE_VISUAL_SELECTED )) 
					super.state = UIElementState.STATE_VISUAL_SELECTED;
			}
		}

		public function get data():IFormItemData 
		{
			return _data;
		}

		public function set data( value:IFormItemData ):void 
		{
			_data = value;
		}

		public function get parentGroup():IFormGroup 
		{
			return _parent;
		}

		public function set parentGroup( value:IFormGroup ):void 
		{
			_parent = value;
		}

		public function get valid():Boolean 
		{
			//TODO need to find a way to validate the default value
			// only do that if there is a defualt value though
//			if ( field.text == _defaultValue || field.text == "" )
//				_data.valid = false; 
			return _data.valid;
		}

		public function set valid( value:Boolean ):void 
		{
			_data.valid = value;

			if ( _data.valid )
			{
				// Check if state that is showing is INVALID_STATE
				// If it is turn it off
				if ( stateManager.compare( UIElementState.STATE_VISUAL_INVALID ))
				{
					state = UIElementState.STATE_VISUAL_INVALID;
					state = UIElementState.STATE_VISUAL_UP;
				}					
			}
			else
			{
				// Data entry is not valid
				// Check if current visual state is INVALID
				if ( stateManager.compare( UIElementState.STATE_VISUAL_INVALID ))
				{
					// Do nothing
				}
				else
				{
					state = UIElementState.STATE_VISUAL_INVALID;
				}
			}
		}	
	
		public function get value():String 
		{
			_data.value = super.field.text;
			return _data.value;
		}

		public function set value( newValue:String):void 
		{
			_data.value = newValue;
			
			if ( newValue == null || newValue.length == 0 )
			{
				super.text = _defaultValue;
			}
			else
			{
				super.text = newValue;
			}
		}
		
		public function get defaultValue():String
		{
			return _defaultValue;
		}
		
		public function set defaultValue( value:String ):void
		{
			_defaultValue = value;
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

	}
}
