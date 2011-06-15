package com.wezside.component.media.player.element.control
{
	import com.wezside.component.control.Button;
	import com.wezside.component.media.player.Player;
	import com.wezside.component.media.player.element.ControlElement;
	import com.wezside.component.media.player.event.PlayerControlEvent;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class SkipToEndButton extends ControlElement
	{
		private var button:Button;
		
		public function SkipToEndButton( decorated:IUIDecorator )
		{
			super( decorated );
		}
		
		override public function build():void
		{			
			button = new Button();
			button.autoSize = "left";
			button.textColorSelected = 0xff0000;
			button.text = "SKIP TO END";
			button.id = "ff";
			button.addEventListener( UIElementEvent.STATE_CHANGE, click );
			button.build();
			button.setStyle();
			button.arrange();
			button.activate();
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
				case Player.STATE_SKIP_TO_START:
				case Player.STATE_PLAY:
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
