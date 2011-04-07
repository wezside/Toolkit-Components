package sample.survey.form {
	import com.wezside.components.survey.form.Form;

	/**
	 * @author Sean Lailvaux
	 */
	public class StartForm extends Form {
		
		
		override public function build() : void {
			
			layout.verticalGap = 20;
			
			super.build();
		}
		
		override public function arrange() : void {
			
			super.arrange();
			
			if ( stage ) {
				
				x = int( ( stage.stageWidth - width ) * .5 );
				y = int( ( stage.stageHeight - height ) * .5 );
			}
		}
	}
}