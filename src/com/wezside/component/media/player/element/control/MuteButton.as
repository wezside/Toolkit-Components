package com.wezside.component.media.player.element.control
{
	import com.wezside.component.control.Button;
	import com.wezside.component.media.player.Player;
	import com.wezside.component.media.player.element.ControlElement;
	import com.wezside.component.media.player.event.PlayerControlEvent;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;
	import com.wezside.components.decorators.interactive.InteractiveSelectable;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MuteButton extends ControlElement
	{
		
		private var button:Button;
		private var selected:Boolean;
		
		public function MuteButton( decorated:IUIDecorator )
		{
			super( decorated );
		}
		
			
		override public function build():void
		{
			super.build();
			
			button = new Button();
			button.interactive = new InteractiveSelectable( button );
			button.id = "mute";
			button.text = "MUTE";
			button.autoSize = "left";
			button.styleName = styleName;
			button.styleManager = styleManager;
			button.build();
			button.setStyle();
			button.arrange();
			button.deactivate();
			button.state = UIElementState.STATE_VISUAL_DISABLED;
			button.addEventListener( UIElementEvent.STATE_CHANGE, click );
			addChild( button );
			
			width = button.width;
			height = button.height;			
		}
		
		override public function set state( value:String ):void
		{
			super.state = value;
			switch ( value )
			{
				case Player.STATE_PLAY:
					button.activate();
					button.state = UIElementState.STATE_VISUAL_UP;
					break;
			}
		}		
		
		private function click( event:UIElementEvent ):void
		{
			if ( event.state.key == UIElementState.STATE_VISUAL_SELECTED )
			{
				selected = event.currentTarget.stateManager.compare( UIElementState.STATE_VISUAL_SELECTED );
				event.currentTarget.dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true, false, selected ));
			}
		}
	}
}
