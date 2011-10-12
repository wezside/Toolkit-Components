package sample
{
	import flash.events.MouseEvent;
	import com.wezside.component.UIElement;
	import com.wezside.component.decorator.layout.VerticalLayout;
	import com.wezside.component.text.Label;
	import com.wezside.component.text.LabelFTE;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.TextRotation;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class VisualTLFLabel extends Sprite
	{
		
		private var label:Label;
		private var container:UIElement;
		private var tlf:LabelFTE;
		
		
		public function VisualTLFLabel()
		{
			addEventListener( Event.ADDED_TO_STAGE, stageInit );			
		}

		private function stageInit( event:Event ):void
		{
		
			container = new UIElement();
			container.layout = new VerticalLayout( container );
			container.layout.verticalGap = 20;
		
			// Add Normal label	
 			label = new Label();
 			label.border = true;
 			label.borderColor = 0x999999;
 			label.autoSize = TextFieldAutoSize.LEFT;
 			label.width = 199;
 			label.multiline = true;
 			label.wordWrap = true;
 			label.textColor = 0;
 			label.text = "Old skool Label. \nLorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent eu nunc non risus cursus pellentesque dapibus eget elit. Duis venenatis libero tempus sapien eleifend vel placerat augue feugiat. ";
 			label.build();
 			label.setStyle();
 			label.arrange();
			container.addChild( label );			

						
			tlf = new LabelFTE();
			
			// Font Description settings
			tlf.fontPosture = FontPosture.NORMAL;
			tlf.fontLookup = FontLookup.DEVICE;
			tlf.renderingMode = RenderingMode.NORMAL;
			tlf.fontWeight = FontWeight.NORMAL;
			tlf.cffHinting = CFFHinting.NONE;
			
			// Element Format settings
			tlf.fontSize = 20;
			tlf.textColor = 0;
			tlf.textRotation = TextRotation.ROTATE_0;
			tlf.baselineShift = 0;			
			tlf.textWidth = 400;
			
			tlf.textColorOver = 0xff0000;
			tlf.locale = "en";
			tlf.addText( "Praesent eu nunc non risus cursus pellentesque dapibus eget elit." );
			tlf.locale = "el";
			tlf.addText( "Ματ με άτομο εντυπωσιακό, τον θέμα διαφορά αν. " );
			tlf.locale = "ar";
			var textStr:String = "دي الذئاب الجزء فقبسنتىوزكجقئت~٩٦٣م غغغفففقفيلييثث٣١الخامس";
			tlf.addText(  textStr, 1 );
			tlf.build();
			tlf.setStyle();
			tlf.arrange();
						
			container.addChild( tlf );			
			container.build();
			container.setStyle();
			container.arrange();			
			addChild( container );
			
			tlf.activate();
			tlf.addEventListener( MouseEvent.CLICK, clickHandler );
			
		}

		private function clickHandler( event:MouseEvent ):void
		{
			trace( event.currentTarget );
		}
	}
}
