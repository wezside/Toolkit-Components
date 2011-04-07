package sample.survey.form {
	import com.wezside.components.survey.form.Form;

	/**
	 * @author Sean Lailvaux
	 */
	public class SampleForm extends Form {
		
		public function set paddingTop( value : int ) : void {
			layout.top = value;
		}
		public function set paddingRight( value : int ) : void {
			layout.right = value;
		}
		public function set paddingBottom( value : int ) : void {
			layout.bottom = value;
		}
		public function set paddingLeft( value : int ) : void {
			layout.left = value;
		}
	}
}