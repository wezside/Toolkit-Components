package com.wezside.components.media.player.resource
{
	import com.wezside.components.media.player.media.MediaMeta;
	import flash.system.LoaderContext;
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IMediaResource
	{
		
		function get id():String;
		function set id( value:String ):void;		
		function get title():String;
		function set title( value:String ):void;
		function get type():String;
		function set type( value:String ):void;
		function get uri():String;
		function set uri( value:String ):void;		
		function get bytesLoaded():Number;
		function set bytesLoaded( value:Number ):void;		
		function get bytesTotal():Number;
		function set bytesTotal( value:Number ):void;		
		function get data():*;
		function set data( value:* ):void;		
		function get autoPlay():Boolean;
		function set autoPlay( value:Boolean ):void;		
		function get xmlns():Namespace;
		function set xmlns( value:Namespace ):void;		
		function get key():String;
		function set key( value:String ):void;		
		function get context():LoaderContext
		function set context( value:LoaderContext ):void
		function get quality():int;
		function set quality( value:int ):void;
		function get bufferTime():Number;
		function set bufferTime( value:Number ):void;
		function get meta():MediaMeta;
		function set meta( value:MediaMeta ):void;
		function get lyrics():String;
		function set lyrics( value:String ):void;
		function get artwork():String;
		function set artwork( value:String ):void;
	}
}
