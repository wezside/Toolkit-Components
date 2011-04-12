package com.wezside.components.media.player.element.decorator
{
	import com.wezside.components.IUIDecorator;
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IControlElement extends IUIDecorator
	{
		function get state():String;
		function set state( value:String ):void;
		function get styleName():String;
		function set styleName( value:String ):void;
		function build():void;
		
	}
}
