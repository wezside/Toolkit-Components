package com.wezside.components.media.player.element
{
	import com.wezside.components.UIElementState;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.utilities.manager.style.IStyleManager;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElement;
	import com.wezside.data.iterator.IIterator;

	import flash.display.Sprite;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class ControlElement extends Sprite implements IControlElement
	{
		
		protected var decorated:IUIDecorator;
		
		private var _data:*;
		private var _state:String;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _styleManager:IStyleManager;
		private var _flagForUpdate:Boolean;
		private var _autoSize:Boolean;
		private var _styleName:String;
		private var _barColors:Array = [ 0x333333, 0x333333 ];
		private var _barAlphas:Array = [ 1, 1 ];
		private var _progressFillColor:uint = 0x73141B;
		private var _progressFillAlpha:Number = 1;
		private var _playbackBarColor:uint = 0xFFFFFF;
		private var _playbackBarAlpha:Number = 1;
		private var _handleWidth:Number = 2;
		private var _handleColors:Array = [ 0x676968, 0x676968 ];
		private var _handleAlphas:Array = [ 1, 1 ];
		private var _padding:Array = [ 0, 0, 0, 0 ];
		private var _defaultState:String;
		
		public function ControlElement( decorated:IUIDecorator ) 
		{
			this.decorated = decorated;
			_defaultState = UIElementState.STATE_VISUAL_UP;
		}

		public function build():void
		{
			if ( decorated is IControlElement ) 
				IControlElement( decorated ).build();
		}

		public function arrange():void
		{
			if ( decorated is IControlElement ) 
				decorated.arrange();
		}	

		public function purge():void
		{
		}		
		
		public function update( media:IMedia ):void
		{
		}		

		public function get styleName():String
		{
			return _styleName;
		}

		public function set styleName( value:String ):void
		{
			_styleName = value;
		}

		public function iterator( type:String = null ):IIterator
		{
			return decorated.iterator( UIElement.ITERATOR_CHILDREN );
		}

		public function get state():String
		{
			return _state;
		}

		public function set state( value:String ):void
		{
			_state = value;
			if ( decorated is IControlElement ) 
				IControlElement( decorated ).state = value;
		}
	
		override public function get width():Number
		{
			return _width;
		}
			
		override public function set width( value:Number ):void
		{
			_width = value;
		}
	
		override public function get height():Number
		{
			return _height;
		}
			
		override public function set height( value:Number ):void
		{
			_height = value;
		}

		public function get styleManager():IStyleManager
		{
			return _styleManager;
		}

		public function set styleManager( value:IStyleManager ):void
		{
			_styleManager = value;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data( value:* ):void
		{
			_data = value;
		}

		public function get flagForUpdate():Boolean
		{
			return _flagForUpdate;
		}

		public function set flagForUpdate( value:Boolean ):void
		{
			_flagForUpdate = value;
		}

		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize( value:Boolean ):void
		{
			_autoSize = value;
		}

		public function get barColors():Array
		{
			return _barColors;
		}

		public function set barColors( value:Array ):void
		{
			_barColors = value;
		}

		public function get barAlphas():Array
		{
			return _barAlphas;
		}

		public function set barAlphas( value:Array ):void
		{
			_barAlphas = value;
		}

		public function get progressFillColor():uint
		{
			return _progressFillColor;
		}

		public function set progressFillColor( value:uint ):void
		{
			_progressFillColor = value;
		}

		public function get progressFillAlpha():Number
		{
			return _progressFillAlpha;
		}

		public function set progressFillAlpha( value:Number ):void
		{
			_progressFillAlpha = value;
		}

		public function get playbackBarColor():uint
		{
			return _playbackBarColor;
		}

		public function set playbackBarColor( value:uint ):void
		{
			_playbackBarColor = value;
		}

		public function get playbackBarAlpha():Number
		{
			return _playbackBarAlpha; 
		}

		public function set playbackBarAlpha( value:Number ):void
		{
			_playbackBarAlpha = value;
		}

		public function get handleWidth():Number
		{
			return _handleWidth;
		}

		public function set handleWidth( value:Number ):void
		{
			_handleWidth = value;
		}

		public function get handleColors():Array
		{
			return _handleColors;
		}

		public function set handleColors( value:Array ):void
		{
			_handleColors = value;
		}

		public function get handleAlphas():Array
		{
			return _handleAlphas;
		}

		public function set handleAlphas( value:Array ):void
		{
			_handleAlphas = value;
		}

		public function get padding():Array
		{
			return _padding;
		}

		public function set padding( value:Array ):void
		{
			_padding = value;
		}

		public function get defaultState():String
		{
			return _defaultState;
		}

		public function set defaultState( value:String ):void
		{
			_defaultState = value;
		}
	}
}
