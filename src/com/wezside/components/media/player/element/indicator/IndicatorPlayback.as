package com.wezside.components.media.player.element.indicator
{
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.media.IMedia;

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
			if ( width == 0 ) width = 200;
			if ( bar ) bar.graphics.clear();
			bar = new Sprite();
			bar.graphics.beginFill( 0xffffff );
			bar.graphics.drawRect(0, 0, 2, 20 );
			bar.graphics.endFill();
			addChild( bar );
			mouseChildren = false;
			mouseEnabled = false;
			super.build();
		}
			
		override public function update( media:IMedia ):void
		{
			super.update( media );
			bar.x = media.currentTime / media.totalTime * width;
		}
			
		override public function set state( value:String ):void
		{
			super.state = value;			
		}		
	}
}
