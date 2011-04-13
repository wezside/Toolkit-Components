package com.wezside.components.media.player.media
{
	import com.wezside.components.media.player.resource.IMediaResource;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaVideo extends Media implements IMedia
	{

		private var video:Video;
		private var bytes:ByteArray = new ByteArray();
		private var netStream:NetStream;
		private var netConnection:NetConnection;
		private var downStream:URLStream;
		private var start:uint = 0;


		override public function load( resource:IMediaResource ):void
		{
			resource.key = "flv";
			netConnection = new NetConnection();
			netConnection.addEventListener( NetStatusEvent.NET_STATUS, statusHandler );
			netConnection.connect( null );

			var request:URLRequest = new URLRequest( resource.uri );
			downStream = new URLStream();
			downStream.addEventListener( Event.COMPLETE, completeHandler );
			downStream.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
			downStream.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			downStream.addEventListener( Event.OPEN, openHandler );
			downStream.addEventListener( ProgressEvent.PROGRESS, progressHandler );
			downStream.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			downStream.load( request );
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
			
			if ( !resource.bufferTime ) netStream.play( resource.uri );
			return playing;
		}

		override public function get currentTime():Number
		{
			return netStream.time;
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
				netStream.pause();
				playing = false;
			}
			else
			{
				// Only resume if possible, i.e. super.play(); is true
				trace( resource.id, "resumed." );
				netStream.resume();
				playing = true;
			}
		}

		override public function seekTo( seconds:Number ):void
		{
			trace( "seekTo", seconds, playing );
			netStream.seek( seconds );
			if ( seconds == totalTime )
			{
				dispatchEvent( new MediaEvent( MediaEvent.COMPLETE ) );
			}
		}

		override public function purge():void
		{
			super.purge();
			netConnection.close();
			netConnection = null;
			video.clear();
			video = null;
			netStream.close();
			netStream = null;
		}
	
		override public function get buffering():Boolean
		{
			trace( "netStream.bufferLength", netStream.bufferLength );
			return netStream.bufferLength < 0.1;
		}

		public function onXMPData( info:Object ):void
		{
			trace( "onXMLData received ");
		}

		public function onMetaData( info:Object ):void
		{
			totalTime = info.duration;
		}

		public function onPlayStatus( info:Object ):void
		{
			trace( "------------------", info );
			switch ( info.code )
			{
				case "NetStream.Play.Complete":
					break;
			}
		}
		
		private function completeHandler( event:Event ):void
		{
			trace( "completeHandler: " + event );
			dispatchEvent( event );
//			downStream.readBytes( bytes, start, downStream.bytesAvailable );
			if ( resource.autoPlay && !resource.bufferTime )
			{
				trace( "---- PLAY NET STREAM" );
				netStream.play( resource.uri );
			}
		}

		private function openHandler( event:Event ):void
		{
			trace( "openHandler: " + event );
		}

		private function progressHandler( event:ProgressEvent ):void
		{
//			trace( "progressHandler: " + event );
			progress = event.bytesLoaded / event.bytesTotal;
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
			trace( "statusHandler", event.info.code );
			switch ( event.info.code )
			{
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.Complete":
					break;
			}
		}

		private function connectStream():void
		{
			video = new Video();
			addChild( video );
			netStream = new NetStream( netConnection );
			netStream.client = this;
			netStream.bufferTime = 5;
			netStream.bufferTimeMax = 10;
			video.attachNetStream( netStream );			
			if ( resource.bufferTime ) netStream.play( resource.uri );
		}
	}
}
