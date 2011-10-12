package sample
{
	import com.wezside.component.UIElement;
	import com.wezside.component.decorator.layout.VerticalLayout;
	import com.wezside.component.text.Label;
	import com.wezside.component.text.LabelFTE;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;

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
		
			// Add Normal label	
 			label = new Label();
 			label.border = true;
 			label.borderColor = 0x999999;
 			label.autoSize = TextFieldAutoSize.LEFT;
 			label.width = 199;
 			label.multiline = true;
 			label.wordWrap = true;
 			label.textColor = 0;
 			label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent eu nunc non risus cursus pellentesque dapibus eget elit. Duis venenatis libero tempus sapien eleifend vel placerat augue feugiat. ";
 			label.build();
 			label.setStyle();
 			label.arrange();
			container.addChild( label );			
			
			
			tlf = new LabelFTE();
//			tlf.width = 200;
			tlf.addText( "دي الذئاب الجزء فقبسنتىوزكجقئت~٩٦٣م غغغفففقفيلييثث٣١الخامس" );
//			tlf.addText( "ذلك بغزو تشيكوسلوفاكيا, ألمانيا الوزراء الإستسلام دار ما, بحشد جديدة الحرب، و بلا. وشعار المدن الأرضية دار بل. مارد وعزّزت بعد عن, وإقامة الشّعبين السوفييتي لم فعل, تم شيء الجبهة المناوشات. عل فصل سكان احداث, بل عليها فاتّبع وبغطاء وفي. عدد هو عقبت المناوشات." );
//			tlf.text = "Praesent eu nunc non risus cursus pellentesque dapibus eget elit.";
			tlf.build();
			tlf.setStyle();
			tlf.arrange();
						
			container.build();
			container.setStyle();
			container.arrange();
			
			addChild( container );
			addChild( tlf );
			
			
		}
	}
}
