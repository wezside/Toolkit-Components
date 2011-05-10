package com.wezside.components.media.player.element.indicator
{
	import com.wezside.components.decorators.layout.PaddedLayout;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElement;
	import com.wezside.components.decorators.shape.ShapeRectangle;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.event.PlayerControlEvent;
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
		private var container:UIElement;
		
		
		public function IndicatorProgress( decorated:IUIDecorator )
		{
			super( decorated );
		}
			
		override public function build():void
		{									
			
			container = new UIElement();
			container.layout = new PaddedLayout( container );
			container.layout.top = padding[0];
			container.layout.right = padding[1];
			container.layout.bottom = padding[2];
			container.layout.left = padding[3];
			
			bar = new UIElement();
			bar.background = new ShapeRectangle( bar );
			bar.background.width = width;
			bar.background.height = height;
			bar.background.colours = barColors;
			bar.background.alphas = [ 1, 1 ];
			bar.build();
			bar.setStyle();
			bar.arrange();
			bar.mouseEnabled = false;
			bar.mouseChildren = false;
			container.addChild( bar );
						
			progress = new Sprite();
			progress.graphics.beginFill( progressFillColor, progressFillAlpha );
			progress.graphics.drawRect( 0, 0, width, height );
			progress.graphics.endFill();
			progress.addEventListener( MouseEvent.CLICK, click );
			progress.addEventListener( MouseEvent.ROLL_OVER, rollOver );
			progress.addEventListener( MouseEvent.ROLL_OUT, rollOut );
			container.addChild( progress );
						
			handle = new UIElement();
			handle.background = new ShapeRectangle( handle );
			handle.background.width = handleWidth;
			handle.background.height = height;
			handle.background.colours =handleColors;
			handle.background.alphas = handleAlphas;
			handle.build();
			handle.setStyle();
			handle.arrange();
			handle.visible = false;
			handle.mouseEnabled = false;
			handle.mouseChildren = false;
			container.addChild( handle );			
			
			playbackBar = new Sprite();
			playbackBar.graphics.beginFill( playbackBarColor, playbackBarAlpha );
			playbackBar.graphics.drawRect(0, 0, handleWidth, height );
			playbackBar.graphics.endFill();
			container.addChild( playbackBar );			
						
			container.build();
			container.setStyle();
			container.arrange();
			addChild( container );			
			
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
			trace( handle.x );
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
