package com.wezside.component.survey.form.item
{
	import com.wezside.component.UIElementState;
	import com.wezside.component.control.Button;
	import com.wezside.component.decorator.interactive.InteractiveSelectable;
	import com.wezside.component.decorator.layout.HorizontalLayout;
	import com.wezside.component.decorator.shape.ShapeRectangle;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.component.survey.form.FormEvent;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.component.text.Label;
	import com.wezside.data.collection.ICollection;
	import com.wezside.utilities.observer.IObserverDetail;

	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormButton extends Button implements IFormItem
	{
		
		private var _data:IFormItemData;
		private var _suffix:Label;


		public function FormButton()
		{
			background = new ShapeRectangle( this );
			background.cornerRadius = 10;
			autoSkinSize = false;
		}

		override public function build():void
		{
			layout = new HorizontalLayout( this );
			layout.horizontalGap = 5;

			super.build();

			if ( data.suffix )
			{
				_suffix = new Label();
				_suffix.styleManager = styleManager;
				_suffix.styleName = "suffixLabel";
				_suffix.text = data.suffix;
				_suffix.setStyle();
				_suffix.build();
				_suffix.arrange();
				addChild( _suffix );
			}			

			interactive = new InteractiveSelectable( this );
			if ( !styleManager ) styleManager = _data.styleManager;
			styleName = getStyleName( _data.id );
			text = _data.label;
			setObserveState( UIElementState.STATE_VISUAL_SELECTED, stateChange );
		}
	
		override public function purge():void
		{
			super.purge();
			if ( _suffix ) _suffix.purge();
			_suffix = null;
		}

		override public function set state( value:String ):void
		{
			super.state = value;
			
			DisplayObject( background ).filters = [];
			switch ( value )
			{
				case UIElementState.STATE_VISUAL_UP:
					background.colours = [ 0xc1c4b8, 0xc1c4b8 ];
					background.alphas = [ 1, 1 ];
					background.arrange();					
					break;
				case UIElementState.STATE_VISUAL_OVER:
					background.colours = [ 0, 0 ];
					background.alphas = [ 0.3, 0.3 ];
					background.arrange();
					break;
				case UIElementState.STATE_VISUAL_SELECTED:
					background.colours = [ 0x9EC22C, 0x9EC22C ];
					background.alphas = [ 1, 1 ];
					background.arrange();					
					break;
				case UIElementState.STATE_VISUAL_DISABLED:
					background.colours = [ 0, 0 ];
					background.alphas = [ 0.3, 0.3 ];
					background.arrange();
					break;
				case UIElementState.STATE_VISUAL_INVALID:
					textColor = 0xC1C4B8;
					DisplayObject( background ).filters = [ new GlowFilter( 0xFA2D78, 1 ) ];
					break;
				default:
			}
		}
		
		public function setDataCollection( collection:ICollection ):void
		{
			// Not applicable
		}		

		public function get data():IFormItemData
		{
			return _data;
		}

		public function set data( value:IFormItemData ):void
		{
			_data = value;
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
			else activate();
		}

		public function get type():String
		{
			return _data.type;
		}

		public function set valid( value:Boolean ):void
		{
			data.valid = value;
		}
		
		public function get valid():Boolean
		{
			return _data.valid;
		}

		public function get value():String
		{
			return data.label;
		}

		public function set value( value:String ):void
		{
			_data.value = value;
		}
			
		override public function get id():String
		{
			return data.id;
		}
			
		override public function set id( value:String ):void
		{
			data.id = value;
		}

		protected function stateChange( detail:IObserverDetail ):void
		{
			dispatchEvent( new FormEvent( FormEvent.ITEM_STATE_CHANGE, true ));
			deactivate();
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
