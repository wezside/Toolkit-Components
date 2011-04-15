package com.wezside.components.media.player.element
{
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.utilities.manager.style.IStyleManager;
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
		function get styleManager():IStyleManager;
		function set styleManager( value:IStyleManager ):void;
		function get data():*;
		function set data( value:* ):void;
		function get flagForUpdate():Boolean;
		function set flagForUpdate( value:Boolean ):void;
		
		function update( media:IMedia ):void;
		function build():void;
		function purge():void;
		
	}
}
