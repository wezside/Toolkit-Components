
package com.wezside.component.media.player.element.control
{
	import com.wezside.component.IUIDecorator;
	import com.wezside.component.UIElementState;
	import com.wezside.component.control.Button;
	import com.wezside.component.media.player.Player;
	import com.wezside.component.media.player.element.ControlElement;
	import com.wezside.component.media.player.event.PlayerControlEvent;

	import flash.events.MouseEvent;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayPauseButton extends ControlElement
	{
		
		private var playButton:Button;
		private var pauseButton:Button;
				
		public function PlayPauseButton( decorated:IUIDecorator )
		{
			super( decorated );
		}

		override public function build():void
		{			
			playButton = new Button();
			playButton.styleName = styleName;
			playButton.styleManager = styleManager;
			playButton.autoSize = "left";
			playButton.text = data.play;
			playButton.id = "play";
			playButton.addEventListener( MouseEvent.CLICK, click );
			playButton.build();
			playButton.setStyle();
			playButton.arrange();
			playButton.activate();
			
			pauseButton = new Button();
			pauseButton.styleName = styleName;
			pauseButton.styleManager = styleManager;
			pauseButton.autoSize = "left";
			pauseButton.text = data.pause;
			pauseButton.id = "pause";
			pauseButton.addEventListener( MouseEvent.CLICK, click );
			pauseButton.build();
			pauseButton.setStyle();
			pauseButton.arrange();
			pauseButton.activate();
			pauseButton.visible = false;
			
			if ( super.state == Player.STATE_PLAY )
			{
				playButton.visible = false;
				playButton.deactivate();
				playButton.state = UIElementState.STATE_VISUAL_SELECTED;
				pauseButton.visible = true;
				pauseButton.activate();
				pauseButton.state = UIElementState.STATE_VISUAL_UP;
			}
			if ( super.state == Player.STATE_PAUSE )
			{
				playButton.visible = true;
				playButton.activate();
				playButton.state = UIElementState.STATE_VISUAL_UP;
				pauseButton.visible = false;
				pauseButton.deactivate();
				pauseButton.state = UIElementState.STATE_VISUAL_SELECTED;
			}
			addChild( pauseButton );			
			addChild( playButton );			
			
			width = pauseButton.width;
			height = pauseButton.height;
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
					playButton.visible = false;
					playButton.state = UIElementState.STATE_VISUAL_SELECTED;
					pauseButton.state = UIElementState.STATE_VISUAL_UP;
					pauseButton.visible = true;
					break;
				case Player.STATE_SKIP_TO_END:
				case Player.STATE_SKIP_TO_START:					
				case Player.STATE_PAUSE:
				case Player.STATE_RESET:
				default:	
					if ( playButton )
					{	
						playButton.state = "";
						playButton.activate();
						playButton.visible = true;			
						pauseButton.visible = false;
					}
					break;
			}
		}		

		private function click( event:MouseEvent ):void
		{
			event.currentTarget.dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true, false ));
		}	
	}
}