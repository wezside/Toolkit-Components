package com.wezside.component.survey.form.item
{
	import com.wezside.component.UIElementState;
	import com.wezside.component.survey.form.FormEvent;
	import com.wezside.utilities.observer.IObserverDetail;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class CheckBox extends FormButton
	{
		

		override public function build():void
		{
			super.build();
			if ( data.suffix ) text = data.suffix;
			setObserveState( UIElementState.STATE_VISUAL_UP, stateChangeUp );
		}
	
		override protected function stateChange( detail:IObserverDetail ):void
		{
			data.state = UIElementState.STATE_VISUAL_SELECTED;
			dispatchEvent( new FormEvent( FormEvent.ITEM_STATE_CHANGE, true ) );
		}

		private function stateChangeUp( detail:IObserverDetail ):void
		{
			state = UIElementState.STATE_VISUAL_UP;
			data.state = UIElementState.STATE_VISUAL_UP;
			dispatchEvent( new FormEvent( FormEvent.ITEM_STATE_CHANGE, true ) );
		}
	}
}