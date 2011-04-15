package com.wezside.components.media.player.element.indicator
{
	import com.wezside.components.media.player.element.PlayerControlEvent;
	import flash.events.MouseEvent;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElement;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.decorators.shape.ShapeRectangle;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.media.IMedia;
	import flash.display.Sprite;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class IndicatorProgress extends ControlElement
	{
		
		private var handle:UIElement;
		private var progress:Sprite;
		private var bar:UIElement;
		private var media:IMedia;
		
		
		public function IndicatorProgress( decorated:IUIDecorator )
		{
			super( decorated );
		}
			
		override public function build():void
		{						
			bar = new UIElement();
			bar.background = new ShapeRectangle( bar );
			bar.background.width = 200;
			bar.background.height = 20;
			bar.background.colours = [ 0xff0000, 0xff0000 ];
			bar.background.alphas = [ 1, 1 ];
			bar.build();
			bar.setStyle();
			bar.arrange();
			addChild( bar );
						
			progress = new Sprite();
			progress.graphics.beginFill( 0, 1 );
			progress.graphics.drawRect( 0, 0, 200, 20 );
			progress.graphics.endFill();
			progress.addEventListener( MouseEvent.CLICK, click );
			addChild( progress );		
			
			width = progress.width;
			height = progress.height;
			
			super.build();
		}

		private function click( event:MouseEvent ):void
		{
			if ( media )
			{
				var seconds:Number = event.localX / 200 * media.totalTime;
				trace( "click ", media, seconds );
				dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true, false, { id: "progress", seconds: seconds }));
			}
		}

		override public function purge(): void 
		{
			super.purge();
		}
		
		override public function update( media:IMedia ):void
		{
			trace( "media.progress", media.progress );
			this.media = media;
			progress.width = media.progress * 200;
			if ( progress.width >= 200 ) flagForUpdate = false;
		}
	}
}
