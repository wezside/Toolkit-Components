package com.wezside.components.media.player.element
{
	import flash.display.DisplayObject;
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.element.decorator.ControlElement;
	import com.wezside.components.media.player.element.decorator.IControlElement;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerControl extends UIElement implements IPlayerElement 
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
