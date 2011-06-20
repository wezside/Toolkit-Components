
package com.wezside.component.media.player.element.control
{
	import com.wezside.component.IUIDecorator;
	import com.wezside.component.UIElementState;
	import com.wezside.component.control.Button;
	import com.wezside.component.decorator.interactive.InteractiveSelectable;
	import com.wezside.component.media.player.Player;
	import com.wezside.component.media.player.element.ControlElement;
	import com.wezside.component.media.player.event.PlayerControlEvent;

	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

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
			button.addEventListener( MouseEvent.CLICK, click );
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
		
		private function click( event:MouseEvent ):void
		{
			selected = event.currentTarget.stateManager.compare( UIElementState.STATE_VISUAL_SELECTED );
			event.currentTarget.dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true, false, selected ));
		}
	}
}

