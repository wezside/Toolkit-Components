package com.wezside.components.media.player.element
{
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlayerControl extends IPlayerElement
	{
		
		function get autoSize():Boolean;
		function set autoSize( value:Boolean ):void;
		function get displayWidth():int;
		function set displayWidth( value:int ):void;
		function get displayHeight():int;
		function set displayHeight( value:int ):void;	
		
		function hasLayoutDecorator( clazz:Class ):void;
	}
}
