package com.wezside.components.media.player.element.decorator.indicator
{
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.media.player.element.decorator.ControlElement;
	import com.wezside.components.text.Label;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class BufferIndicator extends ControlElement
	{
		
		private var label:Label;
				
				
		public function BufferIndicator( decorated:IUIDecorator )
		{
			super( decorated );
		}
			
		override public function build():void
		{
			
			label = new Label();
			label.build();
			label.setStyle();
			label.arrange();
			
			
			super.build();
		}
			
		override public function update( media:IMedia ):void
		{
			
			
			
		}
		
	}
}
