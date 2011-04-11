package com.wezside.components.media.player
{
	import com.wezside.components.media.player.media.Media;
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.display.IPlayerDisplay;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.components.media.player.media.MediaAudio;
	import com.wezside.components.media.player.media.MediaImage;
	import com.wezside.components.media.player.media.MediaSWF;
	import com.wezside.components.media.player.media.MediaVideo;
	import com.wezside.components.media.player.media.MediaVimeo;
	import com.wezside.components.media.player.media.MediaYoutube;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.DictionaryCollection;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.collection.IDictionaryCollection;
	import com.wezside.data.iterator.IIterator;
	import flash.events.Event;

	
	/**
	 * @author Wesley.Swanepoel
	 */
	public class Player extends UIElement
	{
		
		private var media:IMedia;
		private var display:IPlayerDisplay;
		private var _resources:ICollection;
		private var _typeClasses:IDictionaryCollection;
		
		public function Player() 
		{
			_resources = new Collection();
			_typeClasses = new DictionaryCollection();
			_typeClasses.addElement( "swf", MediaSWF );
			_typeClasses.addElement( "bmp", MediaImage );
			_typeClasses.addElement( "jpg", MediaImage );
			_typeClasses.addElement( "jpeg", MediaImage );
			_typeClasses.addElement( "gif", MediaImage );
			_typeClasses.addElement( "png", MediaImage );
			_typeClasses.addElement( "mp3", MediaAudio );
			_typeClasses.addElement( "flv", MediaVideo );
			_typeClasses.addElement( "f4v", MediaVideo );
			_typeClasses.addElement( "vimeo", MediaVimeo );
			_typeClasses.addElement( "youtube", MediaYoutube );			
		}
			
		override public function build():void
		{
			super.build();
			
			var it:IIterator = _resources.iterator();
			var resource:IMediaResource;
			while ( it.hasNext() )
			{
				resource = it.next() as IMediaResource;
				if ( !resource ) continue;
				resource.id = parseID( resource.uri );
				resource.type = parseType( resource.uri );
			}
			it.purge();
			it = null;
			resource = null;
		}

		/**
		 * <p>Play will automatically play the resource with the ID specified.
		 * The ID will be parsed from the filename or the url specified if for 
		 * example it is a Youtube or Vimeo link.</p>
		 * <p>This method will effectively do the same thing as if a user has 
		 * selected an item from the playlist should it exist.</p> 
		 */
		public function play( id:String ):void
		{
			var resource:IMediaResource = resources.find( "id", id );
			if ( resource )
			{
				var MediaClazz:Class = typeClasses.getElement( resource.type ) as Class;
				if ( MediaClazz )
				{
					display = getIDisplay();
					media = new MediaClazz();
					media.data = resource.data;
					media.resource = resource;
					media.addEventListener( Event.COMPLETE, mediaComplete );
					media.build();
					media.setStyle();
					media.arrange();
					display ? UIElement( display ).addChild( media as UIElement ) : addChild( media as UIElement );
					media.load( resource );
				}
				else
					trace( "No class was found for the resource type", resource.type );
			}
			else
				trace( "Couldn't play the resource", id, "because it couldn't be found." );
		}
	
		public function pause():void
		{
			if ( media ) media.pause();
		}

		public function get resources():ICollection
		{
			return _resources;
		}
		
		public function set resources( value:ICollection ):void
		{
			_resources = value;
		}		
		
		public function get typeClasses():IDictionaryCollection
		{
			return _typeClasses;
		}
		
		/**
		 * <p>Uses a file extension or a unique string ID to associate a IMedia class with a 
		 * specific Media type. For example the string ID "vimeo" is associated with the MediaVimeo
		 * class and the "png" file extension is associated with the MediaImage class.</p> 
		 */
		public function set typeClasses( value:IDictionaryCollection ):void
		{
			_typeClasses = value;
		}

		private function parseType( uri:String ):String
		{
			var pattern:RegExp = /[^\.][a-zA-Z0-9]+/gi;
			var ext:Array = uri.match( pattern );
			var fileString:String = ext.length == 0 ? "" : ext[ ext.length-1 ];
			if ( uri.indexOf( "vimeo" ) != -1 ) fileString = "vimeo";
			if ( uri.indexOf( "youtube" ) != -1 ) fileString = "youtube";
			return fileString.toLowerCase();
		}
		
		private function parseID( uri:String ):String
		{
			var id:String = "";
			var ext:Array = [];
			
			// Match Youtube
			var youTubePattern:RegExp = /v\=[a-zA-Z0-9]+/gi;
			ext = uri.match( youTubePattern );
			
			if ( ext.length == 0 )
			{				
				// Match Vimeo http://vimeo.com/3238824 or filename
				var vimeoPattern:RegExp = /[^\/]+[a-zA-Z0-9]+/gi;
				ext = uri.match( vimeoPattern );
				id = ext[ ext.length - 1 ];
			}
			else
			{
				// It's youtube
				id = String(ext[ext.length-1]).substr( 2 );
			}
			return id;
		}			
				private function getIDisplay():IPlayerDisplay
		{
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var object:IPlayerDisplay;
			while ( it.hasNext() )
			{
				object = it.next() as IPlayerDisplay;
				if ( !object ) continue;
				else break;
			}
			it.purge();
			it = null;
			return object;
		}

		private function mediaComplete( event:Event ):void
		{
			var media:IMedia = event.currentTarget as IMedia;
			if ( media.autoPlay )
			{
				var success:Boolean = media.play();
				if ( !success ) trace( media.error.getElement( Media.ERROR_PLAY ));
			}
			else
				trace( "Media is ready to be played" );
		}		
	}
}

