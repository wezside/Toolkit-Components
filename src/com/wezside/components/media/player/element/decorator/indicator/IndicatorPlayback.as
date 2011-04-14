package com.wezside.components.media.player.element.decorator.indicator
{
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.media.player.element.decorator.ControlElement;

	import flash.display.Sprite;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class IndicatorPlayback extends ControlElement
	{
		private var bar:Sprite;
		
		
		public function IndicatorPlayback( decorated:IUIDecorator )
		{
			super( decorated );
		}
			
		override public function build():void
		{			
			bar = new Sprite();
			bar.graphics.beginFill( 0xffffff );
			bar.graphics.drawRect(0, 0, 2, 20 );
			bar.graphics.endFill();
			addChild( bar );
			super.build();
		}
			
		override public function update( media:IMedia ):void
		{
			super.update( media );
			
			bar.x = media.currentTime / media.totalTime * 200;
		}
	}
}
