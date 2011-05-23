package com.wezside.components.media.player
{
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerDisplayEvent extends Event
	{
		public static const HIDE_COMPLETE:String = "HIDE_COMPLETE";
		
		
		
		public function PlayerDisplayEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
			
		override public function clone():Event
		{
			return new PlayerDisplayEvent( type, bubbles, cancelable );
		}
	}
}
