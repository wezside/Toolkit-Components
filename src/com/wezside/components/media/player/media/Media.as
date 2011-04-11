package com.wezside.components.media.player.media
{
	import com.wezside.data.collection.DictionaryCollection;
	import com.wezside.data.collection.IDictionaryCollection;
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.resource.IMediaResource;
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class Media extends UIElement implements IMedia
	{
		public static const ERROR_PLAY:String = "ERROR_PLAY";
		
		private var _error:IDictionaryCollection;
		private var _resource:IMediaResource;
		
		public function Media() 
		{
			_error = new DictionaryCollection();
		}
			
		override public function purge():void
		{
			super.purge();
			_error.purge();
			_error = null;
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
	}
}
