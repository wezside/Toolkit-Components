package com.wezside.components.media.player.element
{
	import com.wezside.components.UIElementEvent;
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerControlEvent extends UIElementEvent
	{
		
		public static const CLICK:String = "CLICK";
		
		
		public function PlayerControlEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
			
		override public function clone():Event
		{
			return new PlayerControlEvent( type, bubbles, cancelable );
		}
	}
}
