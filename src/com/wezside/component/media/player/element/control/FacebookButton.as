package com.wezside.component.media.player.element.control
{
	import flash.events.MouseEvent;
	import com.wezside.component.IUIDecorator;
	import com.wezside.component.UIElementEvent;
	import com.wezside.component.UIElementState;
	import com.wezside.component.control.Button;
	import com.wezside.component.media.player.element.ControlElement;
	import com.wezside.component.media.player.event.PlayerControlEvent;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class FacebookButton extends ControlElement
	{
		
		private var facebookbutton:Button;
				
		public function FacebookButton( decorated:IUIDecorator )
		{
			super( decorated );
		}

		override public function build():void
		{			
			facebookbutton = new Button();		
			facebookbutton.id = "facebook";
			facebookbutton.autoSkinSize = false;
			facebookbutton.styleName = styleName;
			facebookbutton.styleManager = styleManager;
			facebookbutton.addEventListener( MouseEvent.CLICK, click );
			facebookbutton.build();
			facebookbutton.setStyle();
			facebookbutton.arrange();
			facebookbutton.activate();
			facebookbutton.scaleX = facebookbutton.scaleY = 0.4;
			addChild( facebookbutton );
			
			facebookbutton.y += 4;
			
			width = facebookbutton.width;
			height = facebookbutton.y + facebookbutton.height;
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
				default:		
					facebookbutton.state = "";
					facebookbutton.activate();
					break;
			}
		}		

		private function click( event:MouseEvent ):void
		{
			event.currentTarget.dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true, false ));
		}	
	}
}

