package com.wezside.components.survey.form.item
{
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;
	import com.wezside.components.survey.form.FormEvent;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class CheckBox extends FormButton
	{
		override protected function stateChange( event:UIElementEvent ):void
		{
			if ( event.state.key == UIElementState.STATE_VISUAL_SELECTED )
			{
				if ( selected )
				{
					data.state = UIElementState.STATE_VISUAL_SELECTED;
				}
				else
				{
					state = UIElementState.STATE_VISUAL_UP;
					data.state = UIElementState.STATE_VISUAL_UP;
				}
				dispatchEvent( new FormEvent( FormEvent.ITEM_STATE_CHANGE, true ) );
			}
		}

		override public function build():void
		{
			super.build();
			if ( data.suffix ) text = data.suffix;
		}
	}
}