package com.wezside.components.media.player.element.indicator
{
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElement;
	import com.wezside.components.decorators.shape.ShapeRectangle;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.element.PlayerControlEvent;
	import com.wezside.components.media.player.media.IMedia;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class IndicatorProgress extends ControlElement
	{
		
		private var handle:UIElement;
		private var progress:Sprite;
		private var bar:UIElement;
		private var media:IMedia;
		private var seconds:Number;
		private var playbackBar:Sprite;
		
		
		public function IndicatorProgress( decorated:IUIDecorator )
		{
			super( decorated );
		}
			
		override public function build():void
		{									
			bar = new UIElement();
			bar.background = new ShapeRectangle( bar );
			bar.background.width = width;
			bar.background.height = 20;
			bar.background.colours = [ 0x1c1c1c, 0x1c1c1c ];
			bar.background.alphas = [ 1, 1 ];
			bar.build();
			bar.setStyle();
			bar.arrange();
			bar.mouseEnabled = false;
			bar.mouseChildren = false;
			addChild( bar );
						
			progress = new Sprite();
			progress.graphics.beginFill( 0x73141B, 1 );
			progress.graphics.drawRect( 0, 0, width, 20 );
			progress.graphics.endFill();
			progress.addEventListener( MouseEvent.CLICK, click );
			progress.addEventListener( MouseEvent.ROLL_OVER, rollOver );
			progress.addEventListener( MouseEvent.ROLL_OUT, rollOut );
			addChild( progress );
						
			handle = new UIElement();
			handle.background = new ShapeRectangle( handle );
			handle.background.width = 2;
			handle.background.height = 20;
			handle.background.colours = [ 0x676968, 0x676968];
			handle.background.alphas = [ 1, 1 ];
			handle.build();
			handle.setStyle();
			handle.arrange();
			handle.visible = false;
			handle.mouseEnabled = false;
			handle.mouseChildren = false;
			addChild( handle );			
			
			playbackBar = new Sprite();
			playbackBar.graphics.beginFill( 0xFFFFFF );
			playbackBar.graphics.drawRect(0, 0, 2, 20 );
			playbackBar.graphics.endFill();
			addChild( playbackBar );			
						
			super.build();
		}
	
		override public function arrange():void
		{
			super.arrange();
			bar.background.width = width;
			bar.background.arrange();
			progress.width = width;
		}

		override public function purge(): void 
		{
			super.purge();
		}
		
		override public function update( media:IMedia ):void
		{
			this.media = media;
			progress.width = media.progress * width;
			if ( progress.width >= width ) flagForUpdate = false;
			playbackBar.x = media.currentTime / media.totalTime * width;			
		}
	
		override public function set state( value:String ):void
		{
			super.state = value;
		}

		private function rollOut( event:MouseEvent ):void
		{
			progress.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			progress.addEventListener( MouseEvent.ROLL_OVER, rollOver );	
			handle.visible = false;
		}

		private function rollOver( event:MouseEvent ):void
		{
			event.currentTarget.removeEventListener( MouseEvent.ROLL_OVER, rollOver );	
			event.currentTarget.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );	
			handle.visible = true;
		}

		private function mouseMove( event:MouseEvent ):void
		{
			handle.x = int( event.localX * progress.scaleX );
		}

		private function click( event:MouseEvent ):void
		{
			if ( media )
			{
				seconds = event.localX  * progress.scaleX / width * media.totalTime;
				handle.visible = true;
				handle.x = int( event.localX  * progress.scaleX );
				dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true, false, { id: "progress", seconds: seconds }));
			}
		}
	}
}
