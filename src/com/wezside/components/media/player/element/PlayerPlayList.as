package com.wezside.components.media.player.element
{
	import com.wezside.data.collection.Collection;
	import flash.text.TextFieldAutoSize;
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.components.text.Label;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerPlayList extends UIElement implements IPlayerElement
	{
		public var entries:ICollection = new Collection();
		
		private var label:Label;
	
		override public function build():void
		{
			super.build();
						
			var it:IIterator = entries.iterator();
			var resource:IMediaResource;
			while ( it.hasNext() )
			{
				resource = it.next() as IMediaResource;
				label = new Label();
				label.autoSize = TextFieldAutoSize.LEFT; 
				label.text = resource.title;
				label.build();
				label.setStyle();
				label.arrange();
				addChild( label );				
			}
			it.purge();
			it = null;
			resource = null;
			
		}
	}
}
