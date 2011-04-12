package com.wezside.components.media.player.element.decorator
{
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
		
		private var _state:String;		
		
		public function ControlElement( decorated:IUIDecorator ) 
		{
			this.decorated = decorated;
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
	}
}
