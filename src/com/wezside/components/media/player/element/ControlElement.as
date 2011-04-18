package com.wezside.components.media.player.element
{
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
		
		public function ControlElement( decorated:IUIDecorator ) 
		{
			this.decorated = decorated;
		}

		public function build():void
		{
			if ( decorated is IControlElement ) 
			{
				decorated.width = width;
				decorated.height = height;
				IControlElement( decorated ).build();
			}
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
			return "";
		}

		public function set styleName( value:String ):void
		{
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

	}
}
