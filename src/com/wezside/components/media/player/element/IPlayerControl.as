package com.wezside.components.media.player.element
{
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlayerControl extends IPlayerElement
	{
		
		function get displayWidth():int;
		function set displayWidth( value:int ):void;
		function get displayHeight():int;
		function set displayHeight( value:int ):void;	
	}
}
