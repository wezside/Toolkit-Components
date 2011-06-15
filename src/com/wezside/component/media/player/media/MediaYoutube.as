package com.wezside.component.media.player.media
{
	import com.wezside.component.media.player.resource.IMediaResource;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Security;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaYoutube extends Media implements IMedia
	{
		
		private var loader:Loader;
		private var player:*;
		
			
		override public function load( resource:IMediaResource ):void
		{			
			Security.allowDomain( "*" );
			Security.allowInsecureDomain( "*" );
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.INIT, loaderInit );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progressHandler );
			loader.load( new URLRequest( "http://www.youtube.com/apiplayer?version=3" ));
		}

		override public function purge():void
		{
			if ( player )
			{
	 			player.removeEventListener( "onReady", playerReady );
			    player.removeEventListener( "onError", playerError );
			    player.removeEventListener( "onStateChange", playerStateChange );
			    player.removeEventListener( "onPlaybackQualityChange", videoPlaybackQuality );					
				player.destroy();
				removeChild( player );
				player = null;
			}
			super.purge();
		}
		
		
		
		override public function get currentTime():Number
		{
			return !playing && !buffering ? super.currentTime : player ? player.getCurrentTime() : 0;
		}		
			
		override public function get totalTime():Number
		{
			return player ? player.getDuration() : super.totalTime;
		}
		
		override public function set width( value:Number ):void
		{
			if ( player ) player.width = value;
			super.width;
		}
	
		override public function set height( value:Number ):void
		{
			if ( player ) player.height = value;
			super.height;
		}
		
		public function onMetaData( info:Object = null ):void
		{
			totalTime = player.getDuration();
			resource.meta = new MediaMeta();
			resource.meta.totalduration = totalTime;
			resource.meta.width = 853;
			resource.meta.height = 480;
			dispatchEvent( new  MediaEvent( MediaEvent.META, false, false, resource.meta ));
		}		

		private function progressHandler( event:ProgressEvent ):void
		{
			progress = event.bytesLoaded / event.bytesTotal;
		}

		private function loaderInit( event:Event ):void
		{
			loader.contentLoaderInfo.removeEventListener( Event.INIT, loaderInit );
 			player = loader.content;
		    addChild( player );			
		    player.addEventListener( "onReady", playerReady );
		    player.addEventListener( "onError", playerError );
		    player.addEventListener( "onStateChange", playerStateChange );
		    player.addEventListener( "onPlaybackQualityChange", videoPlaybackQuality );			
		}

		private function playerError( event:Event ):void
		{
			switch ( Number( Object( event ).data ))
			{
				case 2	: error.addElement( ERROR_PLAY, "ERROR: The 2 error code is broadcast when a request contains an invalid parameter. For example, this error occurs if you specify a video ID that does not have 11 characters, or if the video ID contains invalid characters, such as exclamation points or asterisks." );
						  break; 
				case 100: error.addElement( ERROR_PLAY, "ERROR: The 100 error code is broadcast when the video requested is not found. This occurs when a video has been removed (for any reason), or it has been marked as private." );
						  break; 
				case 150:
				case 101: error.addElement( ERROR_PLAY, "ERROR: The 101 error code is broadcast when the video requested does not allow playback in the embedded players. The error code 150 is the same as 101, it's just 101 in disguise!" );
						  break;
				default : error.addElement( ERROR_PLAY, "ERROR: An unknown error occured." );
						  break;
			}
			trace( error.getElement( ERROR_PLAY ));
		}

		private function playerReady( event:Event ):void
		{
		    trace( "player ready:", Object( event ).data );		    		    
			player.setPlaybackQuality( "large" );
			if ( autoPlay )
				player.loadVideoByUrl( resource.uri );
			else
			{
				var id:String = resource.uri.substring( resource.uri.lastIndexOf( "v=" ) + 2 );
				id = id.substr( 0, id.indexOf( "&" ) == -1 ? id.length : id.indexOf( "&" ));
				player.cueVideoById( id );
			}	
		}
				
		private function playerStateChange( event:Event ):void 
		{
		    switch ( Number(  Object( event ).data ))
		    {
		    	case -1: playing = false; trace( "Video unstarted. "); break;
		    	case 0 : playing = false; trace( "Video ended. "); break;
		    	case 1 : playing = true; 
		    			 dispatchEvent( new Event( Event.COMPLETE )); 
		    			 trace( "Video playing. "); 
		    			 break;
		    	case 2 : trace( "Video buffering. "); 
		    			 buffering = true; 
		    			 break;
		    	case 5 : trace( "Video cued. "); 
		    			 onMetaData(); 
		    			 break;
		    }
		}
		
		private function videoPlaybackQuality(event:Event):void 
		{
		    // Event.data contains the event parameter, which is the new video quality
		    trace( "video quality:", Object( event ).data );
		}		
				
		override public function play():Boolean
		{			
			if ( !resource.key )
			{
				playing = false;
				error.addElement( ERROR_PLAY, "ERROR: Play for resource " + resource.id + " failed. " +
											  "You need an API key to play YOUTUBE videos. Make sure the " +
											  "resource has the 'key' property set." );
			}
			else playing = true;
			return playing;
		}		

		/**
		 * <p>Pause will only pause if the current media item is playing. Resume will only occur if 
		 * the state was paused and the play() returns success as true.</p>  
		 */
		override public function pause():void
		{
			if ( playing )
			{
				trace( resource.id, "paused." );
				player.pauseVideo();
				playing = false;
			}
			else
			{
				// Only resume if possible, i.e. super.play(); is true
				trace( resource.id, "resumed." );
				player.playVideo();
				playing = true;
			}
		}	
	}
}
