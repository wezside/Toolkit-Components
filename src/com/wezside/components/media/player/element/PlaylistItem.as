package com.wezside.components.media.player.element
{
	import flash.text.TextFieldAutoSize;
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.components.text.Label;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlaylistItem extends UIElement
	{
		
		public var index:int = -1;
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
		
		private function buildLabel( text:String, styleName:String, html:Boolean = false ):Label
		{
			var label:Label = new Label();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.font = "_sans";
			label.embedFonts = false;
			label.styleManager = styleManager;
			label.styleName = styleName;
			label.textColorOver = 0xFFFFFF;
			if ( html ) label.htmlText = text;
			if ( !html ) label.text = text;
			label.build();
			label.setStyle();
			label.arrange();		
			return label;	
		}
	}
}
