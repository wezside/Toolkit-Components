package com.wezside.components.media.player.element.decorator
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.wezside.components.media.player.element.PlayerControlEvent;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;
	import com.wezside.components.control.Button;
	import com.wezside.components.media.player.Player;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PauseButton extends ControlElement
	{
		
		private var button:Button;

		
		public function PauseButton( decorated:IUIDecorator )
		{
			super( decorated );
		}

		override public function build():void
		{
			button = new Button();
			button.id = "pause";
			button.text = "PAUSE";
			button.build();
			button.setStyle();
			button.arrange();
			button.activate();
			button.addEventListener( UIElementEvent.STATE_CHANGE, click );
			addChild( button );	
			super.build();
		}

		override public function arrange():void
		{
			super.arrange();
		}
		
		override public function set state( value:String ):void
		{
			super.state = value;
			switch ( value )
			{
				case Player.STATE_PAUSE:
					button.deactivate();
					button.state = UIElementState.STATE_VISUAL_SELECTED;
					break;
				case Player.STATE_PLAY:
				default:
					button.activate();
					button.state = "";
					button.state = UIElementState.STATE_VISUAL_UP;
					break;
			}
		}
		
		private function click( event:UIElementEvent ):void
		{
			if ( event.state.key == UIElementState.STATE_VISUAL_CLICK )
			{
				event.currentTarget.dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true ));
			}
		}
	}
}
