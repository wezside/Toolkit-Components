package com.wezside.components.survey.form.item
{
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;
	import com.wezside.components.decorators.layout.HorizontalLayout;
	import com.wezside.components.survey.form.FormEvent;
	import com.wezside.components.text.Label;

	import flash.filters.DropShadowFilter;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class RadioButton extends FormButton {
		
		private var _suffix : Label;
		
		
		override protected function stateChange( event : UIElementEvent ) : void {
			if ( event.state.key == UIElementState.STATE_VISUAL_SELECTED ) {
				if ( selected ) {
					dispatchEvent( new FormEvent( FormEvent.ITEM_STATE_CHANGE, true ) );
					deactivate();
				}
				else {
					deactivate();
					activate();
				}
				if ( data ) data.state = UIElementState.STATE_VISUAL_SELECTED;
			}
		}
		
		override public function build() : void {
			
			layout = new HorizontalLayout( this );
			layout.horizontalGap = 5;
			
			super.build();
			var df : DropShadowFilter = new DropShadowFilter(1, 150, 0x12315A, .6, 2, 2, 1, 3);
			if ( field ) field.filters = [df];
			if (data.suffix) {
				_suffix = new Label();
				_suffix.styleManager = styleManager;
				_suffix.styleName = "suffixLabel";
				_suffix.text = data.suffix;
				_suffix.setStyle();
				_suffix.build();
				_suffix.arrange();
				addChild( _suffix );
			}
		}
		
		override public function purge() : void {
			
			if ( _suffix ) _suffix.purge();
			
			super.purge();
			
			_suffix = null;
		}
	}
}