package com.wezside.component.media.player.element
{
	import com.wezside.component.IUIDecorator;
	import com.wezside.component.media.player.media.IMedia;
	import com.wezside.utilities.manager.style.IStyleManager;
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IControlElement extends IUIDecorator
	{
		
		function get autoSize():Boolean;
		function set autoSize( value:Boolean ):void;
		function get state():String;
		function set state( value:String ):void;
		function get styleName():String;
		function set styleName( value:String ):void;
		function get styleManager():IStyleManager;
		function set styleManager( value:IStyleManager ):void;
		function get data():*;
		function set data( value:* ):void;
		function get flagForUpdate():Boolean;
		function set flagForUpdate( value:Boolean ):void;
		function get barColors():Array;
		function set barColors( value:Array ):void;
		function get barAlphas():Array;
		function set barAlphas( value:Array ):void;
		function get progressFillColor():uint
		function set progressFillColor( value:uint ):void
		function get progressFillAlpha():Number;
		function set progressFillAlpha( value:Number ):void;
		function get playbackBarColor():uint;
		function set playbackBarColor( value:uint ):void;
		function get playbackBarAlpha():Number;
		function set playbackBarAlpha( value:Number ):void;
		function get handleColors():Array;
		function set handleColors( value:Array ):void;
		function get handleAlphas():Array;
		function set handleAlphas( value:Array ):void;
		function get padding():Array;
		function set padding( value:Array ):void;
		function get filters():Array
		function set filters( value:Array ):void
		
		function get defaultState():String;
		function set defaultState( value:String ):void;
		
		function get handleWidth():Number;
		function set handleWidth( value:Number ):void;
		
		function update( media:IMedia ):void;
		function build():void;
		function purge():void;
		
	}
}