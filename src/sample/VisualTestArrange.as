package sample 
{
	import sample.style.LatinStyle;

	import com.wezside.component.UIElement;
	import com.wezside.component.decorators.layout.PaddedLayout;
	import com.wezside.component.decorators.layout.VerticalLayout;
	import com.wezside.component.decorators.shape.ShapeRectangle;
	import com.wezside.component.text.Label;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;





	/**
	 * @author Wesley.Swanepoel
	 */
	public class VisualTestArrange extends UIElement 
	{
		
		private var label:Label;
		private var timer:Timer;
		

		public function VisualTestArrange()
		{
			super( );
			
			background = new ShapeRectangle( this );
			background.colours = [ 0, 0 ];
			background.alphas = [ 0.01, 0.05 ];
			background.borderColor = 1;
			background.borderThickness = 1;
			background.borderAlpha = 1;

			layout = new PaddedLayout( this ); 
			layout.bottom = 15;
			layout.left = 15;
			layout.top = 15;
			layout.right = 15;
			
			layout = new VerticalLayout( this.layout );
			layout.verticalGap = 5;
			
			styleManager = new LatinStyle();
			styleManager.addEventListener( Event.COMPLETE, styleReady );			
		}

		private function styleReady( event:Event ):void 
		{			
			label = new Label();
			label.text = "UIElement Button Example";
			label.styleName = "labelButton";
			label.styleManager = styleManager;
			label.width = 300;
			label.selectable = false;
			label.build();
			label.setStyle();
			label.arrange();
			addChild( label );
			
			label = new Label();
			label.text = "Child UIElement";
			label.styleName = "packageLabelButton";
			label.styleManager = styleManager;
			label.width = 300;
			label.selectable = false;
			label.build();
			label.setStyle();
			label.arrange();
			addChild( label );
			
			label = new Label();
			label.text = "Child UIElement";
			label.styleName = "packageLabelButton";
			label.styleManager = styleManager;
			label.width = 300;
			label.selectable = false;
			label.build();
			label.setStyle();
			label.arrange();
			addChild( label );
			
			build();
			arrangeOnTimeout( null );
			timer = new Timer( 3000, 100 );
			timer.addEventListener( TimerEvent.TIMER, arrangeOnTimeout );
			timer.start();
		}

		private function arrangeOnTimeout( event:TimerEvent ):void 
		{
			trace( "Arrange." + width, height );

			arrange();
		}
	}
}
