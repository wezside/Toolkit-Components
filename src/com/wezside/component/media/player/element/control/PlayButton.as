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
			button.styleName = styleName;
			button.styleManager = styleManager;
			button.autoSize = "left";
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
//					button.deactivate();
					button.state = UIElementState.STATE_VISUAL_SELECTED;
					break;
				case Player.STATE_SKIP_TO_END:
				case Player.STATE_SKIP_TO_START:					
				case Player.STATE_PAUSE:
				case Player.STATE_RESET:
				default:					
					button.state = UIElementState.STATE_VISUAL_SELECTED;
					button.activate();
					break;
			}
		}

		private function click( event:UIElementEvent ):void
		{
			trace( event.state.key );
			if ( event.state.key == UIElementState.STATE_VISUAL_CLICK )
			{
				event.currentTarget.dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true ));
			}
		}
	}
}
