package com.wezside.components.media.player.display
{
	import com.wezside.components.media.player.element.IPlayerElement;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlayerDisplay extends IPlayerElement
	{
		function get mediaWidth():int;
		function set mediaWidth( value:int ):void;		
		function get mediaHeight():int;
		function set mediaHeight( value:int ):void;
	}
}
