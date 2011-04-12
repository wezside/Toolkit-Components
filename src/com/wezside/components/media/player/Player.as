package com.wezside.components.media.player
{
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.display.IPlayerDisplay;
	import com.wezside.components.media.player.element.IPlayerControl;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.components.media.player.media.Media;
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
	 * <p>A media player that will play almost all media types. Easy expand this 
	 * component to suit your own needs.</p> 
	 * 
	 * <p><b>Runtime Versions:</b> Flash Player 10.1, AIR 2</p>
	 *  
	 * @author Wesley.Swanepoel
	 */
	public class Player extends UIElement implements IPlayerDisplay
	{
		
		private var media:IMedia;
		private var _resources:ICollection;
		private var _typeClasses:IDictionaryCollection;
		
		// Media is loaded and ready for playback
		public static const STATE_READY:String = "STATE_READY";
		// Play method was invoked
		public static const STATE_PLAY:String = "STATE_PLAY";
		// Pause method was invoked
		public static const STATE_PAUSE:String = "STATE_PAUSE";
		// Seek method was invoked		
		public static const STATE_SEEK:String = "STATE_SEEK";
		// Media progress state 		
		public static const STATE_PROGRESS:String = "STATE_PROGRESS";
		// Volume change occcured		
		public static const STATE_VOLUME:String = "STATE_VOLUME";	
		
		public static const SWF:String = "SWF";
		public static const BMP:String = "BMP";
		public static const JPG:String = "JPG";
		public static const JPEG:String = "JPEG";
		public static const GIF:String = "GIF";
		public static const PNG:String = "PNG";
		public static const MP3:String = "MP3";
		public static const FLV:String = "FLV";
		public static const F4V:String = "F4V";
		public static const VIMEO:String = "VIMEO";
		public static const YOUTUBE:String = "YOUTUBE";
		
		public function Player() 
		{
			_resources = new Collection();
			_typeClasses = new DictionaryCollection();
			_typeClasses.addElement( SWF, MediaSWF );
			_typeClasses.addElement( BMP, MediaImage );
			_typeClasses.addElement( JPG, MediaImage );
			_typeClasses.addElement( JPEG, MediaImage );
			_typeClasses.addElement( GIF, MediaImage );
			_typeClasses.addElement( PNG, MediaImage );
			_typeClasses.addElement( MP3, MediaAudio );
			_typeClasses.addElement( FLV, MediaVideo );
			_typeClasses.addElement( F4V, MediaVideo );
			_typeClasses.addElement( VIMEO, MediaVimeo );
			_typeClasses.addElement( YOUTUBE, MediaYoutube );			
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
	
		override public function purge():void
		{
			super.purge();					
			var it:IIterator = display.iterator( UIElement.ITERATOR_CHILDREN );
			var object:IMedia;
			while ( it.hasNext() )
			{
				object = it.next() as IMedia;
				object.purge();
				object = null;
			}
			it.purge();
			it = null;
			display.purge();
		}
			
		override public function set state( value:String ):void
		{
			trace( " control.state",  control.state );
			super.state = value;
			if ( control.state != value )
				control.state = value;
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
					media = new MediaClazz();
					media.data = resource.data;
					media.resource = resource;
					media.addEventListener( Event.COMPLETE, mediaComplete );
					media.build();
					media.setStyle();
					media.arrange();
					display.addChild( media as UIElement );
					media.load( resource );
				}
				else
					trace( "No class was found for the resource type", resource.type );
			}
			else
				trace( "Couldn't play the resource", id, "because it couldn't be found." );
		}
	
		public function pause( id:String = "" ):void
		{
			var media:IMedia = getChildByName( id ) as IMedia;
			if ( media ) media.pause();
			else
			{
				var it:IIterator = display.iterator( UIElement.ITERATOR_CHILDREN );
				var object:IMedia;
				while ( it.hasNext() )
				{
					object = it.next() as IMedia;
					if ( !object ) continue;
					object.pause();
					state = STATE_PAUSE;
				}
				it.purge();
				it = null;
				object = null;
			}
		}
		
		/**
		 * <p>Return the current display object associated with the current media type. So if an IPlayerDisplay
		 * was created with a "vimeo" media type, and the current media item to be played is video on Vimeo,
		 * this IPlayerDisplay will be returned.</p>
		 * 
		 * @return The IPlayerDisplay object associated with the current IMedia instance being played.
		 */
		public function get display():UIElement
		{			
			if ( !media ) return this;			
			var mediaType:String;
			var it:IIterator = allDisplays.iterator();
			var playerDisplay:IPlayerDisplay;
			var selectedDisplay:IPlayerDisplay;
			while ( it.hasNext() )
			{
				playerDisplay = it.next() as IPlayerDisplay;
				if ( !playerDisplay ) continue;
				mediaType = playerDisplay.find( media.resource.type );
				if ( mediaType ) 
				{
					selectedDisplay = playerDisplay;
					break;				
				}
			}
			it.purge();
			it = null;
			playerDisplay = null;
			return selectedDisplay ? selectedDisplay as UIElement : this;
		}

		/**
		 * Return all displays added to this Player instance.
		 */
		public function get allDisplays():ICollection
		{
			var collection:ICollection = new Collection();
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var object:IPlayerDisplay;
			while ( it.hasNext() )
			{
				object = it.next() as IPlayerDisplay;
				if ( !object ) continue;
				collection.addElement( object );
			}
			it.purge();
			it = null;
			object = null;
			return collection;
		}

		public function get control():IPlayerControl
		{
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var object:IPlayerControl;
			while ( it.hasNext() )
			{
				object = it.next() as IPlayerControl;
				if ( !object ) continue;
				if ( object ) break;
			}
			it.purge();
			it = null;		
			return object;
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

		/**
		 * This method is not applicable to this class.
		 * @return Empty string
		 */
		public function find( mediaType:String ):String
		{
			return "";
		}
		
		/**
		 * This method is not applicable to this class.
		 */
		public function addMediaType( id:String ):void
		{
			throw new Error( "The Player class is the default IPlayerDisplay and doesn't allow specific media type associations. To add a specific media type, you have to create " +
							 "a new IPlayerDisplay class and add it as a child of the Player instance. " );
		}		

		/**
		 * Parse the media type of the uri. Will always return the last match in the regex expression. 
		 * This is to include filenames. 
		 */
		private function parseType( uri:String ):String
		{
			var pattern:RegExp = /[^\.][a-zA-Z0-9]+/gi;
			var ext:Array = uri.match( pattern );
			var fileString:String = ext.length == 0 ? "" : ext[ ext.length-1 ];
			if ( uri.indexOf( "vimeo" ) != -1 ) fileString = "vimeo";
			if ( uri.indexOf( "youtube" ) != -1 ) fileString = "youtube";
			return fileString.toLowerCase();
		}
		
		/**
		 * Math the ID of the supplied URI using regex. Match Youtube first, then Vimeo or 
		 * a filename has the same match pattern.  
		 */
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

		private function mediaComplete( event:Event ):void
		{
			var media:IMedia = event.currentTarget as IMedia;
			if ( media.autoPlay )
			{
				var success:Boolean = media.play();
				if ( !success ) trace( media.error.getElement( Media.ERROR_PLAY ));
				else state = STATE_PLAY;
			}
			else
				trace( "Media is ready to be played" );
		}

	}
}

