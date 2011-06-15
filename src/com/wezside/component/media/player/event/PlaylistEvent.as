package com.wezside.component.media.player.event
{
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlaylistEvent extends Event
	{
		public static const CLICK:String = "PLAYLIST_CLICK";
		public static const LYRIC_CLICK:String = "LYRIC_CLICK";
		public var data:*;
		
		public function PlaylistEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
			
		override public function clone():Event
		{
			return new PlaylistEvent( type, bubbles, cancelable, data );
		}
	}
}
