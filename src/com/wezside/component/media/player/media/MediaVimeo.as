package com.wezside.component.media.player.media
{

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaVimeo extends Media implements IMedia
	{
		
		private var isPlaying:Boolean;

			
		override public function play():Boolean
		{			
			if ( !resource.key )
				error.addElement( ERROR_PLAY, "ERROR: Play for resource " + resource.id + " failed. " +
											  "You need an API key to play VIMEO videos. Make sure the " +
											  "resource has the 'key' property set." );
			
			isPlaying = true;
			return false;
		}
			

		/**
		 * <p>Pause will only pause if the current media item is playing. Resume will only occur if 
		 * the state was paused and the play() returns success as true.</p>  
		 */			
		override public function pause():void
		{
			if ( isPlaying ) trace( resource.id, "paused." );
			else
			{
				// Only resume if possible, i.e. super.play(); is true
				var success:Boolean = play();
				if ( success ) trace( resource.id, "resumed." );	
			}
			isPlaying = !isPlaying;
		}		
	}
}
