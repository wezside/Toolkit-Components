package com.wezside.components.media.player.element.decorator.indicator
{
	import flash.display.Sprite;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElement;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.decorators.shape.ShapeRectangle;
	import com.wezside.components.media.player.element.decorator.ControlElement;
	import com.wezside.components.media.player.media.IMedia;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class IndicatorProgress extends ControlElement
	{
		
		private var handle:UIElement;
		private var progress:Sprite;
		private var bar:UIElement;
		
		
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
			addChild( progress );
						
			handle = new UIElement();
			handle.background = new ShapeRectangle( handle );
			handle.background.width = 20;
			handle.background.height = 20;
			handle.background.colours = [ 0, 0 ];
			handle.background.alphas = [ 1, 1 ];
			handle.build();
			handle.setStyle();
			handle.arrange();
			handle.addEventListener( UIElementEvent.STATE_CHANGE, stateChange );
//			addChild( handle );			
			
			width = progress.width;
			height = progress.height;
			
			super.build();
		}

		override public function purge(): void 
		{
			super.purge();
		}
		
		override public function update( media:IMedia ):void
		{
			progress.width = media.progress * 200;
			if ( progress.width >= 200 ) flagForUpdate = false;
		}
		
		private function stateChange( event:UIElementEvent ):void
		{
		}			
		
		
	}
}
