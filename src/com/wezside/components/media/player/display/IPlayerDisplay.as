package com.wezside.components.media.player.display
{
	import com.wezside.components.media.player.element.IPlayerElement;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlayerDisplay extends IPlayerElement
	{
		function show():void;
		function hide():void;
		function find( mediaType:String ):String;
		function addMediaType( id:String ):void;
	}
}
