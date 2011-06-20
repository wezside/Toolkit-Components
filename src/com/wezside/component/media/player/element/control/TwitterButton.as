package com.wezside.component.media.player.element.control
{
	import com.wezside.component.IUIDecorator;
	import com.wezside.component.control.Button;
	import com.wezside.component.media.player.element.ControlElement;
	import com.wezside.component.media.player.event.PlayerControlEvent;

	import flash.events.MouseEvent;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class TwitterButton extends ControlElement
	{
		
		private var twitterButton:Button;
				
		public function TwitterButton( decorated:IUIDecorator )
		{
			super( decorated );
		}

		override public function build():void
		{			
			twitterButton = new Button();	
			twitterButton.id = "twitter";
			twitterButton.autoSkinSize = false;
			twitterButton.styleName = styleName;
			twitterButton.styleManager = styleManager;
			twitterButton.addEventListener( MouseEvent.CLICK, click );
			twitterButton.build();
			twitterButton.setStyle();
			twitterButton.arrange();
			twitterButton.activate();
			twitterButton.scaleX = twitterButton.scaleY = 0.4;
			addChild( twitterButton );
			
			twitterButton.y += 4;
			
			width = twitterButton.width;
			height = twitterButton.y + twitterButton.height;
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
					twitterButton.state = "";
					twitterButton.activate();
					break;
			}
		}		

		private function click( event:MouseEvent ):void
		{
			event.currentTarget.dispatchEvent( new PlayerControlEvent( PlayerControlEvent.CLICK, true, false ));
		}	
	}
}
