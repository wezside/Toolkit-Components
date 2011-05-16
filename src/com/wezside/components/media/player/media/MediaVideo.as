package com.wezside.components.media.player.media
{
	import com.wezside.components.media.player.resource.IMediaResource;

	import flash.events.Event;
	import flash.events.NetStatusEvent; 
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaVideo extends Media implements IMedia
	{

		private var video:Video;
		private var stream:NetStream;
		private var netConnection:NetConnection;

		
		override public function load( resource:IMediaResource ):void
		{
			resource.key = "flv";
			netConnection = new NetConnection();
			netConnection.addEventListener( NetStatusEvent.NET_STATUS, statusHandler );
			netConnection.connect( null );
		}

		override public function play():Boolean
		{
			trace( resource.id, "play." );
			if ( !resource.key )
			{
				error.addElement( ERROR_PLAY, "ERROR: Play for resource " + resource.id + " failed. " + "You need an API key to play VIMEO videos. Make sure the " + "resource has the 'key' property set." );
				playing = false;
			}
			else playing = true;
			return playing;
		}

		override public function get currentTime():Number
		{
			return !playing && !buffering ? super.currentTime : stream.time;
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
				stream.pause();
				playing = false;
			}
			else
			{
				// Only resume if possible, i.e. super.play(); is true
				trace( resource.id, "resumed." );
				stream.resume();
				playing = true;
			}
		}

		override public function seekTo( seconds:Number ):void
		{
			trace( "seekTo", seconds, playing );
			stream.seek( seconds );
			currentTime = seconds;
			if ( seconds == totalTime )
			{
				dispatchEvent( new MediaEvent( MediaEvent.COMPLETE ));
			}
		}
			
		override public function set volume( level:Number ):void
		{
			trace( "volume", level );
			stream.soundTransform = new SoundTransform( level );
		}
			
		override public function get volume():Number
		{
			return stream.soundTransform.volume;
		}

		override public function purge():void
		{			
			netConnection = null;
			if ( video )
			{
				removeChild( video );
				video.clear();			
				video = null;
			}
			if ( stream )
			{
				stream.removeEventListener( NetStatusEvent.NET_STATUS, statusHandler );
				stream.close();
				stream = null;
			}
			super.purge();
		}
			
		override public function get progress():Number
		{
			return stream.bytesLoaded / stream.bytesTotal;
		}
	
		override public function set width( value:Number ):void
		{
			if ( video ) video.width = value;
			super.width;
		}
	
		override public function set height( value:Number ):void
		{
			if ( video ) video.height = value;
			super.height;
		}

		public function onXMPData( info:Object ):void
		{
			trace( "onXMLData received ", info );
		}

		public function onMetaData( info:Object ):void
		{
			totalTime = info.duration;
			resource.meta = new MediaMeta();
			for ( var a:String in info )
			{
				if ( resource.meta.hasOwnProperty( a ))
					resource.meta[a] = info[a];
			}
			dispatchEvent( new  MediaEvent( MediaEvent.META, false, false, resource.meta ));
		}

		private function statusHandler( event:NetStatusEvent ):void
		{
//			trace( "statusHandler", event.info.code );
			switch ( event.info.code )
			{
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.Complete":
					break;
				case "NetStream.Buffer.Empty":
					buffering = true;
					break;
				case "NetStream.Buffer.Flush":
				case "NetStream.Buffer.Full":
					if ( stream.bytesLoaded < stream.bytesTotal )
						buffering = true;
					else
						buffering = false;					
					break;
				case "NetStream.Play.Start":
					playbackFinished = false;
					break;
				case "NetStream.Play.Stop":
					if ( stream.bytesLoaded >= stream.bytesTotal ) buffering = false;
					playbackFinished = true;
					trace( "----------------- MEDIA FINISHED." );
					dispatchEvent( new MediaEvent( MediaEvent.COMPLETE ));
					break;
				case "NetStream.Seek.Notify":
					break;
				case "NetStream.Play.StreamNotFound":
					trace( "NetStream.Play.StreamNotFound", resource.uri );
					break;
			}
		}

		private function connectStream():void
		{
			video = new Video();
			addChild( video );
			stream = new NetStream( netConnection );
			stream.addEventListener( NetStatusEvent.NET_STATUS, statusHandler );
			stream.client = this;
			stream.bufferTime = 0.3;
			video.attachNetStream( stream );

			if ( resource.bufferTime && autoPlay ) 
			{
				dispatchEvent( new Event( Event.COMPLETE ));
				stream.play( resource.uri );
			}
			else if ( autoPlay )
			{
				dispatchEvent( new Event( Event.COMPLETE ));
				stream.play( resource.uri );
			}
			else
			{
				stream.play( resource.uri );
				stream.pause();				
			}
		}		
	}
}
