package com.wezside.components.media.player.element.indicator
{
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.components.text.Label;

	/**
	 * @author FChowdhury
	 */
	public class IndicatorTotalTime extends ControlElement
	{
		private var label:Label;
		private static const DEFAULT_TOTAL_TIME:String = "00:00";

		public function IndicatorTotalTime( decorated:IUIDecorator )
		{
			super( decorated );
		}

		override public function build():void
		{
			label = new Label();
			label.autoSize = "left";
			label.text = DEFAULT_TOTAL_TIME;
			label.build();
			label.setStyle();
			label.arrange();
			addChild( label );
			super.build();
			label.width = width;
			label.height = height;
			label.x = 200;
		}

		override public function update( media:IMedia ):void
		{
			super.update( media );
			setTotalTime( String( media.totalTime ) );
		}

		private function setTotalTime( value:String ):void
		{
			label.text = value;
		}
	}
}
