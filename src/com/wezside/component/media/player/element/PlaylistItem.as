package com.wezside.component.media.player.element
{
	import com.wezside.component.UIElement;
	import com.wezside.component.UIElementEvent;
	import com.wezside.component.UIElementState;
	import com.wezside.component.media.player.event.PlaylistEvent;
	import com.wezside.component.media.player.resource.IMediaResource;
	import com.wezside.component.text.Label;
	import com.wezside.data.iterator.IIterator;

	import flash.text.TextFieldAutoSize;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlaylistItem extends UIElement implements IPlaylistItem
	{
		
		private var _index:int = -1;
		
		public var lyricLabel:String;
		public var resource:IMediaResource;
			
		override public function build():void
		{
			super.build();
			
			if ( index > -1 )
			{
				var indexStr:String = ( index + 1 ).toString().length == 1 ? "0" + ( index + 1 ).toString() : ( index + 1 ).toString();
				addChild( buildLabel( indexStr, "playlist-item-index", false, false ));
			}
					
			if ( resource.title )
				addChild( buildLabel( resource.title, "playlist-item-title" ));				
				
			if ( resource.lyrics )
				addChild( buildLabel( lyricLabel, "playlist-item-lyrics" ));
								
			if ( resource.meta )
			{
				if ( resource.meta.duration )
					addChild( buildLabel( resource.meta.duration.toString(), "playlist-item-duration" ));
			}				
		}
			
		override public function arrange():void
		{
			super.arrange();
		}
	
		override public function set state( value:String ):void
		{
			super.state = value;
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var label:Label;
			switch ( value )
			{
				case UIElementState.STATE_VISUAL_SELECTED:
					while ( it.hasNext() )
					{
						label = it.next() as Label;
						if ( !label || label.styleName == "playlist-item-lyrics" ) continue;
						label.state = value;
						label.deactivate();
					}
					break;
				case UIElementState.STATE_VISUAL_UP:
					while ( it.hasNext() )
					{
						label = it.next() as Label;
						if ( !label ) continue;
						label.state = value;
						label.activate();
					}
					break;
				default:
			}
			it.purge();
			it = null;
			label = null;
		}

		public function reset():void
		{
			state = UIElementState.STATE_VISUAL_UP;
		}

		public function get id():String
		{
			return resource.id;
		}

		public function set id( value:String ):void
		{
			resource.id = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index( value:int ):void
		{
			_index = value;
		}
		
		private function buildLabel( text:String, styleName:String, html:Boolean = false, active:Boolean = true ):Label
		{
			var label:Label = new Label();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.font = "_sans";
			label.embedFonts = false;
			label.styleManager = styleManager;
			label.styleName = styleName;
			label.textColorOver = 0xFFFFFF;
			label.textColorSelected = 0xFF0000;
			if ( html ) label.htmlText = text;
			if ( !html ) label.text = text;
			label.build();
			label.setStyle();
			label.arrange();
			active ? label.activate() : label.deactivate();
			if ( active ) label.addEventListener( UIElementEvent.STATE_CHANGE, stateChange );		
			return label;	
		}

		private function stateChange( event:UIElementEvent ):void
		{
			if ( event.state.key == UIElementState.STATE_VISUAL_CLICK )
			{
				if ( event.currentTarget.text == lyricLabel )
					dispatchEvent( new PlaylistEvent( PlaylistEvent.LYRIC_CLICK, false, false, resource.lyrics ));
				else				
					dispatchEvent( new PlaylistEvent( PlaylistEvent.CLICK, false, false, _index ));
			}
		}

	}
}
