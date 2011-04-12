package com.wezside.components.media.player.element.decorator
{
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
	}
}
