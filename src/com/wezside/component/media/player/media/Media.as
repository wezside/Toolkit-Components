package com.wezside.component.media.player.media
{
	import com.wezside.component.UIElement;
	import com.wezside.component.media.player.resource.IMediaResource;
	import com.wezside.data.collection.DictionaryCollection;
	import com.wezside.data.collection.IDictionaryCollection;

	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class Media extends UIElement implements IMedia
	{
		
		public static const ERROR_LOAD:String = "ERROR_LOAD";
		public static const ERROR_PLAY:String = "ERROR_PLAY";
		
		private var _error:IDictionaryCollection;
		private var _resource:IMediaResource;
		private var _playing:Boolean = false;
		private var _totalTime:Number = -1;
		private var _currentTime:Number = 0;
		private var _progress:Number = 0;
		private var _buffering:Boolean;
		private var _playbackFinished:Boolean;		
		
		public function Media() 
		{
			_error = new DictionaryCollection();
		}
			
		override public function purge():void
		{
			if ( _error )
			{
				_error.purge();
				_error = null;
			}
			super.purge();
		}
		
		public function load( resource:IMediaResource ):void
		{
			trace( "Media.load()" );
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		public function play():Boolean
		{
			trace( "Media.play()" );
			return false;
		}

		public function pause():void
		{
			trace( "Media.pause()" );
		}

		public function reset():void
		{
			trace( "Media.reset()" );
		}
		
		public function seekTo( seconds:Number ):void
		{
			trace( "Media.seekTo()" );
		}

		public function set volume( level:Number ):void
		{
		}
		
		public function get volume():Number
		{
			return 0;
		}
		
		public function get data():*
		{
		}

		public function set data( value:* ):void
		{
		}

		public function get autoPlay():Boolean
		{
			return _resource.autoPlay;
		}

		public function set autoPlay( value:Boolean ):void
		{
			_resource.autoPlay = value;
		}

		public function get error():IDictionaryCollection
		{
			return _error;
		}

		public function set error( value:IDictionaryCollection ):void
		{
			_error = value;
		}

		public function get resource():IMediaResource
		{
			return _resource;
		}

		public function set resource( value:IMediaResource ):void
		{
			_resource = value;
		}

		public function get playing():Boolean
		{
			return _playing;
		}

		public function set playing( value:Boolean ):void
		{
			_playing = value;
		}

		public function get currentTime():Number
		{
			return _currentTime;
		}

		public function set currentTime( value:Number ):void
		{
			_currentTime = value;
		}

		public function get totalTime():Number
		{
			return _totalTime;
		}

		public function set totalTime( value:Number ):void
		{
			_totalTime = value;
		}

		public function get progress():Number
		{
			return _progress;
		}

		public function set progress( value:Number ):void
		{
			_progress = value;
		}

		public function get buffering():Boolean
		{
			return _buffering;
		}

		public function set buffering( value:Boolean ):void
		{
			_buffering = value;
		}

		public function get playbackFinished():Boolean
		{
			return _playbackFinished;
		}

		public function set playbackFinished( value:Boolean ):void
		{
			_playbackFinished = value;
		}
	}
}