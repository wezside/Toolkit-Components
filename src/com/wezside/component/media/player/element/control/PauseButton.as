package com.wezside.component.media.player.element.control
{
	import com.wezside.component.IUIDecorator;
	import com.wezside.component.UIElementEvent;
	import com.wezside.component.UIElementState;
	import com.wezside.component.control.Button;
	import com.wezside.component.media.player.Player;
	import com.wezside.component.media.player.element.ControlElement;
	import com.wezside.component.media.player.event.PlayerControlEvent;

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
			button.text = "PAUSED";
			button.autoSize = "left";
			button.styleName = styleName;
			button.styleManager = styleManager;
			button.build();
			button.setStyle();
			button.arrange();
			button.activate();
			button.addEventListener( UIElementEvent.STATE_CHANGE, click );
			if ( super.state == Player.STATE_PAUSE )
			{
				button.deactivate();
				button.state = UIElementState.STATE_VISUAL_SELECTED;
			}			
			addChild( button );
			
			width = button.width;
			height = button.height;
			super.build();
		}
		
		override public function set state( value:String ):void
		{
			super.state = value;
			trace( "PauseButton", value );
			switch ( value )
			{
				case Player.STATE_VOLUME: break;
				case Player.STATE_PAUSE:
					button.deactivate();
					button.state = UIElementState.STATE_VISUAL_SELECTED;
					break;
				case Player.STATE_SKIP_TO_END:
				case Player.STATE_SKIP_TO_START:
				case Player.STATE_PLAY:
				case Player.STATE_RESET:
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
