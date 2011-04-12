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
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaVideo extends Media implements IMedia
	{
		private var isPlaying:Boolean;
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
			netConnection.addEventListener( NetStatusEvent.NET_STATUS, netConnectionStatusHandler );
			netConnection.connect( null );
				
			video = new Video();
			addChild( video );
			
			netStream = new NetStream( netConnection );
			netStream.client = {};
			video.attachNetStream( netStream );			

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

		private function completeHandler( event:Event ):void
		{
			trace( "completeHandler: " + event );
			dispatchEvent( event );
			downStream.readBytes( bytes, start, downStream.bytesAvailable );
			if ( resource.autoPlay )
			{
				netStream.play( null );
				netStream.appendBytesAction( NetStreamAppendBytesAction.RESET_BEGIN );
				netStream.appendBytes( bytes );
			}	
		}

		private function openHandler( event:Event ):void
		{
			trace( "openHandler: " + event );
		}

		private function progressHandler( event:ProgressEvent ):void
		{
			trace( "progressHandler: " + event );
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

		override public function play():Boolean
		{
			if ( !resource.key )
			{
				error.addElement( ERROR_PLAY, "ERROR: Play for resource " + resource.id + " failed. " + "You need an API key to play VIMEO videos. Make sure the " + "resource has the 'key' property set." );
				isPlaying = false;
			}
			else isPlaying = true;
			netStream.play( null );
			netStream.appendBytesAction( NetStreamAppendBytesAction.RESET_BEGIN );
			netStream.appendBytes( bytes );			
			return isPlaying;
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

		private function netConnectionStatusHandler( event:NetStatusEvent ):void
		{
			trace( "event.info.code", event.info.code );
			switch ( event.info.code )
			{
				case "NetConnection.Connect.Success":


					break;
				case "NetStream.Seek.Notify" :
					trace( "NetStream Notify" );
					netStream.appendBytesAction( NetStreamAppendBytesAction.RESET_SEEK );
					netStream.appendBytes( bytes );
					break;
			}
		}

		public function createURLRequest( url:String, bytesFrom:Number, bytesTo:Number = 0 ):URLRequestHeader
		{
			var header:URLRequestHeader;
			if ( bytesTo > 0 )
			{
				header = new URLRequestHeader( "Range", "bytes=" + bytesFrom + "-" + (bytesFrom + bytesTo) );
			}
			else
			{
				header = new URLRequestHeader( "Range", "bytes=" + bytesFrom + "-" );
			}
			return header;
		}
	}
}
