package com.wezside.component.survey.form.item
{
	import com.wezside.component.UIElementState;
	import com.wezside.component.decorator.layout.HorizontalLayout;
	import com.wezside.component.survey.form.FormEvent;
	import com.wezside.component.text.Label;
	import com.wezside.utilities.observer.IObserverDetail;

	import flash.filters.DropShadowFilter;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class RadioButton extends FormButton
	{
		private var _suffix:Label;

		override public function build():void
		{
			layout = new HorizontalLayout( this );
			layout.horizontalGap = 5;

			super.build();
			var df:DropShadowFilter = new DropShadowFilter( 1, 150, 0x12315A, .6, 2, 2, 1, 3 );
			if ( field ) field.filters = [ df ];
			if (data.suffix)
			{
				_suffix = new Label();
				_suffix.styleManager = styleManager;
				_suffix.styleName = "suffixLabel";
				_suffix.text = data.suffix;
				_suffix.setStyle();
				_suffix.build();
				_suffix.arrange();
				addChild( _suffix );
			}
			
			setObserveState( UIElementState.STATE_VISUAL_UP, stateChangeUp );
		}
		
		override protected function stateChange( detail:IObserverDetail ):void
		{
			dispatchEvent( new FormEvent( FormEvent.ITEM_STATE_CHANGE, true ) );
			deactivate();
			if ( data ) data.state = UIElementState.STATE_VISUAL_SELECTED;
		}


		override public function purge():void
		{
			if ( _suffix ) _suffix.purge();
			super.purge();
			_suffix = null;
		}		

		private function stateChangeUp( detail:IObserverDetail ):void
		{
			deactivate();
			activate();
		}		
	}
}