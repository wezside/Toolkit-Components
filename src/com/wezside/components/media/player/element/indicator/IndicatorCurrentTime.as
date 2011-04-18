package com.wezside.components.media.player.element.indicator
{
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.media.player.Player;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.components.text.Label;

	/**
	 * @author FChowdhury
	 */
	public class IndicatorCurrentTime extends ControlElement
	{

		private var label:Label;

		public function IndicatorCurrentTime( decorated:IUIDecorator )
		{
			super( decorated );
		}

		override public function build():void
		{
			if ( label ) label.purge();
			label = new Label();
			label.autoSize = "left";
			label.text = "00:00";
			label.textColor = 0xFF0000;
			label.width = width;
			label.height = height;
			label.x = 0;
			label.build();
			label.setStyle();
			label.arrange();
			addChild( label );
			
			super.build();
		}

		override public function set state( value:String ):void
		{
			super.state = value;
			switch ( value )
			{
				case Player.STATE_PLAY:
					break;
			}
		}

		override public function update( media:IMedia ):void
		{
			super.update( media );
			label.text = String( int(( media.currentTime ) * 100 ) / 100 );
			label.x = int( media.currentTime / media.totalTime * width );
		}
	}
}
