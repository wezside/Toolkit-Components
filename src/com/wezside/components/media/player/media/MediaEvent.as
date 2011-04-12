package com.wezside.components.media.player.media
{
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaEvent extends Event
	{
		
		public static const COMPLETE : String = "COMPLETE";
		
		public function MediaEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
	}
}
