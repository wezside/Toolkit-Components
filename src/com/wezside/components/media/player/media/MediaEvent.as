package com.wezside.components.media.player.media
{
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaEvent extends Event
	{
		
		public static const META:String = "META";
		public static const COMPLETE:String = "COMPLETE";
		public static const PROGRESS:String = "PROGRESS";
		public static const PLAYBACK_COMPLETE:String = "PLAYBACK_COMPLETE";
		
		public var data:*;
		
		public function MediaEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
			
		override public function clone():Event
		{
			return new MediaEvent( type, bubbles, cancelable, data );
		}
	}
}
