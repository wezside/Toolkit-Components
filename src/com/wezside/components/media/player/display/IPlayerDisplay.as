package com.wezside.components.media.player.display
{
	import com.wezside.components.media.player.element.IPlayerElement;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlayerDisplay extends IPlayerElement
	{
		function get maintainAspectRatio():Boolean;
		function set maintainAspectRatio( value:Boolean ):void;		
		function get originalWidth():int;
		function set originalWidth( value:int ):void;
		function get originalHeight():int;
		function set originalHeight( value:int ):void;
		
		function show():void;
		function hide():void;
		function find( mediaType:String ):String;
		function addMediaType( id:String ):void;
		function purgeAllChildren():void;
		
	}
}
