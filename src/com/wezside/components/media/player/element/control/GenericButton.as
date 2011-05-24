
package com.wezside.components.media.player.element.control
{
	import flash.text.TextFieldAutoSize;
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.UIElementState;
	import com.wezside.components.control.Button;
	import com.wezside.components.decorators.interactive.InteractiveSelectable;
	import com.wezside.components.media.player.Player;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.event.PlayerControlEvent;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class GenericButton extends ControlElement
	{
		
		private var button:Button;
		private var selected:Boolean;
		
		public function GenericButton( decorated:IUIDecorator )
		{
			super( decorated );
		}
		
			
		override public function build():void
		{
			super.build();
			
			button = new Button();
			button.interactive = new InteractiveSelectable( button );
			button.id = data;
			button.autoSize = TextFieldAutoSize.LEFT;
			button.text = data;
			button.styleName = styleName;
			button.styleManager = styleManager;
			button.build();
			button.setStyle();
			button.arrange();
			button.activate();
			button.state = defaultState;
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
					selected = false;
					break;
				case Player.STATE_RESET:
					if ( !selected )
					{
					button.state = ""; 
					button.state = UIElementState.STATE_VISUAL_UP;
					}
					break;
				case UIElementState.STATE_VISUAL_DISABLED:
					button.deactivate();
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
