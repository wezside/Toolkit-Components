package com.wezside.components.media.player.display
{
	import com.wezside.components.media.player.element.IPlayerElement;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlayerDisplay extends IPlayerElement
	{
		
		function get displayWidth():int;
		function set displayWidth( value:int ):void;
		function get displayHeight():int;
		function set displayHeight( value:int ):void;
		
		function show():void;
		function hide():void;
		function find( mediaType:String ):String;
		function addMediaType( id:String ):void;
		
	}
}
