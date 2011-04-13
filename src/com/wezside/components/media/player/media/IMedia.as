package com.wezside.components.media.player.media
{
	import com.wezside.components.IUIElement;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.data.collection.IDictionaryCollection;
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IMedia extends IUIElement
	{
		
		function get resource():IMediaResource;
		function set resource( value:IMediaResource ):void;
		
		function get data():*;
		function set data( value:* ):void;
		
		function get autoPlay():Boolean;
		function set autoPlay( value:Boolean ):void;
		
		function get playing():Boolean;
		function set playing( value:Boolean ):void;
		
		function get currentTime():Number;
		function set currentTime( value:Number ):void;
		
		function get totalTime():Number;
		function set totalTime( value:Number ):void;
		
		function get error():IDictionaryCollection;
		function set error( value:IDictionaryCollection ):void;
		
		function get progress():Number;
		function set progress( value:Number ):void;
		
		function get buffering():Boolean;
		
		function seekTo( seconds:Number ):void;
		function play():Boolean;
		function pause():void;
		function reset():void;
		function load( resource:IMediaResource ):void;
		
	}
}
