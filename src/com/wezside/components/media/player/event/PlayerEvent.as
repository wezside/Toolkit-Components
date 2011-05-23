package com.wezside.components.media.player.event
{
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerEvent extends Event
	{
		public static const META_ARRANGE_COMPLETE:String = "META_ARRANGE_COMPLETE";
		public static const HIDE_COMPLETE:String = "HIDE_COMPLETE";
		public static const VOLUME_FADE_COMPLETE:String = "VOLUME_FADE_COMPLETE";
		public static const PLAYING:String = "PLAYING";
		
		public function PlayerEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
			
		override public function clone():Event
		{
			return new PlayerEvent( type, bubbles, cancelable );
		}
	}
}
