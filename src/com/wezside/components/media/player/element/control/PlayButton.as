package com.wezside.components.media.player.element.control
{
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;
	import com.wezside.components.control.Button;
	import com.wezside.components.media.player.Player;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.element.PlayerControlEvent;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayButton extends ControlElement
	{
		
		private var button:Button;
		
				
		public function PlayButton( decorated:IUIDecorator )
		{
			super( decorated );
		}

		override public function build():void
		{			
			button = new Button();
			button.autoSize = "left";
			button.textColorSelected = 0xff0000;
			button.text = data;
			button.id = "play";
			button.addEventListener( UIElementEvent.STATE_CHANGE, click );
			button.build();
			button.setStyle();
			button.arrange();
			button.activate();
			if ( super.state == Player.STATE_PLAY )
			{
				button.deactivate();
				button.state = UIElementState.STATE_VISUAL_SELECTED;
			}
			addChild( button );			
			
			width = button.width;
			height = button.height;
			
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
				case Player.STATE_VOLUME: break;
				case Player.STATE_PLAY:
					button.deactivate();
					button.state = UIElementState.STATE_VISUAL_SELECTED;
					break;
				case Player.STATE_SKIP_TO_END:
				case Player.STATE_SKIP_TO_START:					
				case Player.STATE_PAUSE:
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
