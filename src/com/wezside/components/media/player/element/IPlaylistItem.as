package com.wezside.components.media.player.element
{
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlaylistItem
	{
		
		function get id():String;
		function set id( value:String ):void;
		function get index():int;
		function set index( value:int ):void;
		function get state():String;
		function set state( value:String ):void;
	
		function reset():void;	
	}
}
