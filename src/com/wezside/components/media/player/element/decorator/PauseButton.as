package com.wezside.components.media.player.element.decorator
{
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.control.Button;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class PauseButton extends ControlElement
	{
		
		private var button:Button;

		
		public function PauseButton( decorated:IUIDecorator )
		{
			super( decorated );
		}

		override public function build():void
		{
			trace( "build() PAUSE" );
			button = new Button();
			button.text = "PAUSE";
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
		}
	}
}
