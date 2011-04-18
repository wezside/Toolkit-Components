package com.wezside.components.media.player.element.indicator
{
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.components.text.Label;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class IndicatorBuffer extends ControlElement
	{
		
		private var label:Label;
				
				
		public function IndicatorBuffer( decorated:IUIDecorator )
		{
			super( decorated );
		}
			
		override public function build():void
		{
			label = new Label();
			label.autoSize = "left";
			label.text = "";
			label.textColor = 0xffffff;
			label.build();
			label.setStyle();
			label.arrange();
			addChild( label );
			
			super.build();
		}
			
		override public function update( media:IMedia ):void
		{
			if ( media.buffering )
			{
				label.text = "Video is buffering";
			}
			else
				label.text = " ";			
		}		
	}
}
