package com.wezside.components.media.player.media
{
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.display.Bitmap;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.utilities.date.DateUtil;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaAudio extends Media
	{
		private var sound:Sound;
		private var dateUtil:DateUtil;
		private var bufferFraction:Number;
		private var channel:SoundChannel = new SoundChannel();
		private var id3:ID3Info;
		private var loader:Loader;
		private var artworkBmp:Bitmap;

		
		override public function load( resource:IMediaResource ):void
		{			
			resource.key = "mp3";
			dateUtil = new DateUtil();
			bufferFraction = resource.bufferTime / 100;
			
			soundTransform = new SoundTransform();
			sound = new Sound();
			sound.addEventListener( Event.ID3, id3Handler );
		    sound.addEventListener( Event.COMPLETE, complete );
			sound.addEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			sound.addEventListener( ProgressEvent.PROGRESS, progressHandler );			
			sound.load( new URLRequest( resource.uri ), new SoundLoaderContext( resource.bufferTime ));
			
			if ( resource.bufferTime && resource.autoPlay ) 
			{
				buffering = true;
				channel = sound.play( 0 );
				channel.addEventListener( Event.SOUND_COMPLETE , soundComplete );
				dispatchEvent( new Event( Event.COMPLETE ));
				dispatchMeta();
			}
			
			if ( resource.artwork )
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, artworkLoaded );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, errorHandler );
				loader.load( new URLRequest( resource.artwork ));
			}
		}
		
		override public function seekTo( seconds:Number ):void
		{
			currentTime = seconds;
			if ( playing )
			{
				channel.stop();
				dispatchMeta();
				channel = sound.play( seconds );
				channel.addEventListener( Event.SOUND_COMPLETE , soundComplete );
			}
			else
			{
				dispatchMeta();
				var currentVolume:Number = volume;
				channel.soundTransform = new SoundTransform( 0 );
				channel = sound.play( seconds );			
				channel.stop();
				channel.soundTransform = new SoundTransform( currentVolume );
			}
			if ( seconds == totalTime )
			{
				dispatchEvent( new MediaEvent( MediaEvent.COMPLETE ));
			}
		}
			
		override public function purge():void
		{			
			if ( artworkBmp )
			{
				artworkBmp.bitmapData.dispose();
				artworkBmp = null;
			}
			
			id3 = null;
			dateUtil = null;
			
			if ( channel )
			{
				channel.stop();
				channel.removeEventListener( Event.SOUND_COMPLETE , soundComplete );
				channel = null;
			}
			
			resource.meta = null;
			
			if ( sound )
			{
				sound.removeEventListener( Event.ID3, id3Handler );
			    sound.removeEventListener( Event.COMPLETE, complete );
				sound.removeEventListener( IOErrorEvent.IO_ERROR, errorHandler );
				sound.removeEventListener( ProgressEvent.PROGRESS, progressHandler );	
				sound = null;
			}					
			super.purge();
		}

		override public function get volume():Number
		{
			return channel.soundTransform.volume;
		}
			
		override public function set volume( level:Number ):void
		{
			channel.soundTransform = new SoundTransform( level );
		}
	
		override public function play():Boolean
		{
			if ( !resource.key )
			{
				error.addElement( ERROR_PLAY, "ERROR: Play for resource " + resource.id + " failed. " + 
											  "You need an API key to play VIMEO videos. Make sure the " + "resource has the 'key' property set." );
				playing = false;
			}
			else playing = true;			
			return playing;
		}
	
		override public function pause():void
		{
			if ( playing )
			{
				trace( resource.id, "paused." );
				channel.stop();
				currentTime = channel.position; 
				playing = false;
			}
			else
			{
				// Only resume if possible, i.e. super.play(); is true
				trace( resource.id, "resumed." );
				channel = sound.play( currentTime ); 
				playing = true;
			}
		}

		override public function get currentTime():Number
		{
			return !playing && !buffering ? super.currentTime : channel.position;
		}

		private function click( event:MouseEvent ):void
		{
			dispatchEvent( new MediaEvent( MediaEvent.CLICK, false, false ));
		}

		private function artworkLoaded( event:Event ):void
		{
			artworkBmp = event.currentTarget.content;
			artworkBmp.smoothing = true;
			addChild( artworkBmp );
		}

		private function id3Handler( event:Event ):void
		{
			id3 = sound.id3;
			totalTime = id3.duration;
			resource.meta = new MediaMeta();
			for ( var a:String in id3 )
			{
				if ( resource.meta.hasOwnProperty( a ))
					resource.meta[a] = id3[a];
			}
			dispatchEvent( new  MediaEvent( MediaEvent.META, false, false, resource.meta ));
		}
		
		private function errorHandler( event:IOErrorEvent ):void
		{
			error.addElement( ERROR_LOAD, event.text );
			trace( event.text );
		}

		private function complete( event:Event ):void
		{
			trace( "MEDIA COMPLETE." );
			dispatchEvent( event );
			if ( progress == 1 ) buffering = false;
			if ( resource.autoPlay && !resource.bufferTime )
			{
				trace( "MEDIA AUDIO PLAY " );
				channel = sound.play( 0 );
				channel.addEventListener( Event.SOUND_COMPLETE , soundComplete );
			}
			dispatchMeta();
		}
		
		private function dispatchMeta():void
		{
			if ( !id3 )
			{
				if ( !resource.meta ) resource.meta = new MediaMeta();
				resource.meta.duration = totalTime;
				resource.meta.totalduration = totalTime;
				resource.meta.starttime = currentTime;
				resource.meta.width = artworkBmp ? artworkBmp.width : 0;					
				resource.meta.height = artworkBmp ? artworkBmp.height : 0;					
				dispatchEvent( new  MediaEvent( MediaEvent.META, false, false, resource.meta ));
			}			
		}

		private function progressHandler( event:ProgressEvent ):void
		{
			progress = event.bytesLoaded / event.bytesTotal;
			totalTime = ( sound.bytesTotal / ( sound.bytesLoaded / sound.length ));
		}	
		
		private function soundComplete( event:Event ):void
		{
			dispatchEvent( new MediaEvent( MediaEvent.COMPLETE ));
		}		
	}
}
