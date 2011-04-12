package com.wezside.components.media.player.element
{
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.element.decorator.ControlElement;
	import com.wezside.components.media.player.element.decorator.IControlElement;

	import flash.display.DisplayObject;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerControl extends UIElement implements IPlayerControl 
	{
				
		private var _element:IControlElement;
		
				
		public function PlayerControl() 
		{
			_element = new ControlElement( this );
		}
			
		override public function build():void
		{
			super.build();
			_element.build();
		}
			
		override public function arrange():void
		{
			_element.arrange();
			super.arrange();
		}
				
		override public function set state( value:String ):void
		{
			super.state = value;
			_element.state = value;
		}
		
		public function get element():IControlElement
		{
			return _element;
		}
		
		public function set element( value:IControlElement ):void
		{
			_element = value;
		}

		public function decorate( Control:Class, styleName:String = "" ):void
		{
			_element = new Control( this.element );
			_element.styleName = styleName;
			addChild( _element as DisplayObject );
		}
	}
}
