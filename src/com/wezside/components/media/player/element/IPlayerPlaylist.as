package com.wezside.components.media.player.element
{
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlayerPlaylist extends IPlayerElement
	{
		function get selectedIndex():int;
		function set selectedIndex( value:int ):void;
	}
}
