package com.wezside.components.media.player.event
{
	import com.wezside.components.UIElementEvent;
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerControlEvent extends UIElementEvent
	{
		
		public static const CLICK:String = "CLICK";
		public var data:*;
		
		
		public function PlayerControlEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
			
		override public function clone():Event
		{
			return new PlayerControlEvent( type, bubbles, cancelable, data );
		}
	}
}
