package com.wezside.components.media.player.media
{
	import com.wezside.components.media.player.resource.IMediaResource;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
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
		private var _buffering:Boolean;
		private var _playbackFinished:Boolean;
		
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
			
			if ( !resource.bufferTime ) stream.play( resource.uri );
			return playing;
		}

		override public function get currentTime():Number
		{
			return !playing ? super.currentTime : stream.time;
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
			stream.soundTransform = new SoundTransform( level );
		}
			
		override public function get volume():Number
		{
			return stream.soundTransform.volume;
		}

		override public function purge():void
		{
			super.purge();
			netConnection.close();
			netConnection = null;
			video.clear();
			video = null;
			stream.close();
			stream = null;
		}
	
		override public function get buffering():Boolean
		{
			return _buffering;
		}
	
		override public function get playbackFinished():Boolean
		{
			return _playbackFinished;
		}
			
		override public function get progress():Number
		{
			return stream.bytesLoaded / stream.bytesTotal;
		}

		public function onXMPData( info:Object ):void
		{
			trace( "onXMLData received ", info );
		}

		public function onMetaData( info:Object ):void
		{
			totalTime = info.duration;
			video.width = info.width;
			video.height = info.height;
			resource.meta = new MediaMeta();
			for ( var a:String in info )
				if ( resource.meta.hasOwnProperty( a ))
					resource.meta[a] = info[a];
			dispatchEvent( new  MediaEvent( MediaEvent.META, false, false, resource.meta ));
		}
		
		private function completeHandler( event:Event ):void
		{
			dispatchEvent( event );
			if ( resource.autoPlay && !resource.bufferTime )
				stream.play( resource.uri );
		}

		private function openHandler( event:Event ):void
		{
			trace( "openHandler: " + event );
		}

		/**
		 * Sometimes stream.time indicates a position greater than the bytes that were downloaded. So 
		 * this will then draw the playback indicator in front of the progress bar which is visually incorrect. 
		 * To fix this behaviour we check if this is happening and then set the progress value to the stream 
		 * currentTime and totalTime ration instead. 
		 */
		private function progressHandler( event:ProgressEvent ):void
		{
			progress = event.bytesLoaded / event.bytesTotal;			
			if ( progress  < stream.time / totalTime  ) progress = stream.time / totalTime;			
			dispatchEvent( new MediaEvent( MediaEvent.PROGRESS, false, false, progress ));
		}

		private function securityErrorHandler( event:SecurityErrorEvent ):void
		{
			trace( "securityErrorHandler: " + event );
		}

		private function httpStatusHandler( event:HTTPStatusEvent ):void
		{
			trace( "httpStatusHandler: " + event );
		}

		private function ioErrorHandler( event:IOErrorEvent ):void
		{
			trace( "ioErrorHandler: " + event );
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
					_buffering = true;					
					break;
				case "NetStream.Buffer.Flush":
				case "NetStream.Buffer.Full":
					_buffering = false;
					break;
				case "NetStream.Play.Start":
					_playbackFinished = false;
					break;
				case "NetStream.Play.Stop":
					_playbackFinished = true;
					dispatchEvent( new MediaEvent( MediaEvent.COMPLETE ));
					break;
				case "NetStream.Play.StreamNotFound":
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
			stream.bufferTime = 5;
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
