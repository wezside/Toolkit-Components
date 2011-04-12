package com.wezside.components.media.player.element.decorator
{
	import com.wezside.components.decorators.interactive.InteractiveSelectable;
	import com.wezside.components.media.player.Player;
	import com.wezside.components.UIElementState;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.control.Button;

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
			trace( "build() PLAY" );
			button = new Button();
			button.interactive = new InteractiveSelectable( button );
			button.autoSize = "left";
			button.textColorSelected = 0xff0000;
			button.text = "PLAY";
			button.build();
			button.setStyle();
			button.arrange();
			button.activate();
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
			trace( "PlayButton state", value );
			switch ( value )
			{
				case Player.STATE_PLAY:
					button.deactivate();
					button.state = UIElementState.STATE_VISUAL_SELECTED;
					break;
				default:
					button.state = "";
					button.state = UIElementState.STATE_VISUAL_UP;
					break;
			}
		}

	}
}
