package com.wezside.components.media.player.element
{
	import com.wezside.components.UIElement;
	import com.wezside.components.UIElementState;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.components.text.Label;
	import com.wezside.data.iterator.IIterator;

	import flash.text.TextFieldAutoSize;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlaylistItem extends UIElement implements IPlaylistItem
	{
		
		private var _index:int = -1;
		
		public var resource:IMediaResource;
			
		override public function build():void
		{
			super.build();
			
			if ( index > -1 )
				addChild( buildLabel( ( index + 1 ).toString(), "playlist-item-index" ));
					
			if ( resource.title )
				addChild( buildLabel( resource.title, "playlist-item-title" ));				
				
			if ( resource.lyrics )
				addChild( buildLabel( resource.lyrics, "playlist-item-lyrics" ));				
				
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
			switch ( value )
			{
				case UIElementState.STATE_VISUAL_SELECTED:
					var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
					var label:Label;
					while ( it.hasNext() )
					{
						label = it.next() as Label;
						if ( !label ) continue;
						label.state = value;
					}
					it.purge();
					it = null;
					label = null;
					break;
				default:
			}
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
		
		private function buildLabel( text:String, styleName:String, html:Boolean = false ):Label
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
			return label;	
		}

	}
}
