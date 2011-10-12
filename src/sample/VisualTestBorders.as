package sample
{
	import com.wezside.component.decorator.shape.ShapeRectangle;
	import com.wezside.component.UIElement;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class VisualTestBorders extends UIElement
	{
		
		public function VisualTestBorders()
		{			
			background = new ShapeRectangle( this );
			background.topLeftRadius = 40;
			background.topRightRadius = 40;
			background.width = 200;
			background.height = 200;
			background.colours = [ 0xcccccc, 0x343434 ];
			background.alphas = [ 1, 1 ];
			background.borderThickness = 2;
			background.borderColor = 0;
			
			
			build();
			setStyle();
			arrange();
			
		}
		
	}
}


