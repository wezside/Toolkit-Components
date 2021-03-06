package com.wezside.component.media.player.element
{
	import com.wezside.component.UIElement;
	import com.wezside.component.UIElementState;
	import com.wezside.component.decorator.layout.HorizontalLayout;
	import com.wezside.component.decorator.layout.ILayout;
	import com.wezside.component.media.player.event.PlaylistEvent;
	import com.wezside.component.media.player.resource.IMediaResource;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerPlaylist extends UIElement implements IPlayerPlaylist
	{

		public var entries:ICollection = new Collection();
		
		private var _autoSize:Boolean;
		private var _displayWidth:int;
		private var _displayHeight:int;
		private var _selectedIndex:int = 0;
		private var _lyricLabel:String;
	
	
		override public function build():void
		{
			super.build();			
			var playlistItem:PlaylistItem;
			var it:IIterator = entries.iterator();
			var resource:IMediaResource;
			while ( it.hasNext() )
			{
				resource = it.next() as IMediaResource;
				playlistItem = new PlaylistItem();
				playlistItem.lyricLabel = _lyricLabel;
				playlistItem.styleName = "playlistItem";
				playlistItem.styleManager = styleManager;
				playlistItem.layout = new HorizontalLayout( playlistItem );
				playlistItem.index = it.index() - 1;
				playlistItem.resource = resource;
				playlistItem.build();
				playlistItem.setStyle();
				playlistItem.arrange();
				playlistItem.addEventListener( PlaylistEvent.CLICK, click );
				playlistItem.addEventListener( PlaylistEvent.LYRIC_CLICK, lyricClick );
				addChild( playlistItem );
			}
			it.purge();
			it = null;
			resource = null;			
		}

	
		override public function arrange():void
		{
			if ( _displayWidth != 0 && _displayHeight != 0 )
			{
				background.width = _displayWidth;
				background.height = _displayHeight;			
			}			
			super.arrange();
		}

		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize( value:Boolean ):void
		{
			_autoSize = value;
		}

		public function get displayWidth():int
		{
			return _displayWidth;
		}

		public function set displayWidth( value:int ):void
		{
			_displayWidth = value;	
		}

		public function get displayHeight():int
		{
			return _displayHeight;
		}

		public function set displayHeight( value:int ):void
		{
			_displayHeight = value;
		}

		public function hasLayoutDecorator( layout:ILayout, decorator:Class ):Boolean
		{
			if ( layout is decorator ) return true;
			var result:Boolean;
			var chainLayout:ILayout = layout.chain();
			if ( chainLayout )
				result = hasLayoutDecorator( chainLayout, decorator );
			else
				result = layout is decorator;
			return result;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex( value:int ):void
		{
			_selectedIndex = value;
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var playlistItem:IPlaylistItem;
			while ( it.hasNext() )
			{
				playlistItem = it.next() as IPlaylistItem;
				playlistItem.reset();
			}
			it.purge();
			it = null;
			playlistItem = null;
			IPlaylistItem( getChildAt( _selectedIndex )).state = UIElementState.STATE_VISUAL_SELECTED;
		}
		
		public function get lyricLabel():String
		{
			return _lyricLabel;
		}
		
		public function set lyricLabel( value:String ):void
		{
			_lyricLabel = value;
		}
		
		private function autoSizeElements( value:Boolean ):ICollection
		{
			var collection:ICollection = new Collection();
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var element:IControlElement;
			while ( it.hasNext() )
			{
				element = it.next() as IControlElement;
				if ( element.autoSize == value ) collection.addElement( element );
			}
			it.purge();
			it = null;
			element = null;			
			return collection;
		}		
		
		private function click( event:PlaylistEvent ):void
		{
			selectedIndex = int( event.data );
			dispatchEvent( event );
		}		
		
		private function lyricClick( event:PlaylistEvent ):void
		{
			dispatchEvent( event );
		}		
	}
}
