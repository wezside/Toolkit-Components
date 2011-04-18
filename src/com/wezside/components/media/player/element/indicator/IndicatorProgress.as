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
		private var seconds : Number;
		
		
		public function IndicatorProgress( decorated:IUIDecorator )
		{
			super( decorated );
		}
			
		override public function build():void
		{						

			trace( "width", width );
			if ( bar ) bar.purge();
			bar = new UIElement();
			bar.background = new ShapeRectangle( bar );
			bar.background.width = width;
			bar.background.height = 20;
			bar.background.colours = [ 0xff0000, 0xff0000 ];
			bar.background.alphas = [ 1, 1 ];
			bar.build();
			bar.setStyle();
			bar.arrange();
			bar.mouseEnabled = false;
			bar.mouseChildren = false;
			addChild( bar );
						
			if ( progress )
			{
				progress.removeEventListener( MouseEvent.CLICK, click );
				progress.removeEventListener( MouseEvent.ROLL_OVER, rollOver );
				progress.removeEventListener( MouseEvent.ROLL_OUT, rollOut );
				progress.graphics.clear();
				progress = null;
			}
			progress = new Sprite();
			progress.graphics.beginFill( 0, 1 );
			progress.graphics.drawRect( 0, 0, width, 20 );
			progress.graphics.endFill();
			progress.addEventListener( MouseEvent.CLICK, click );
			progress.addEventListener( MouseEvent.ROLL_OVER, rollOver );
			progress.addEventListener( MouseEvent.ROLL_OUT, rollOut );
			addChild( progress );
						
			if ( handle ) handle.purge();
			handle = new UIElement();
			handle.background = new ShapeRectangle( handle );
			handle.background.width = 2;
			handle.background.height = 20;
			handle.background.colours = [ 0xffee00, 0xffee00 ];
			handle.background.alphas = [ 1, 1 ];
			handle.build();
			handle.setStyle();
			handle.arrange();
			handle.visible = false;
			handle.mouseEnabled = false;
			handle.mouseChildren = false;
			addChild( handle );			
						
			super.build();
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
			handle.x = int( event.localX );
		}

		private function click( event:MouseEvent ):void
		{
			if ( media )
			{
				seconds = event.localX / width * media.totalTime;
				handle.visible = true;
				handle.x = int( event.localX );
				dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true, false, { id: "progress", seconds: seconds }));
			}
		}
	}
}
