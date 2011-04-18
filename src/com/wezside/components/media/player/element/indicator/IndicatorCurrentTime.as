package com.wezside.components.media.player.element.indicator
{
	import com.wezside.components.IUIDecorator;
	import com.wezside.components.media.player.element.ControlElement;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.components.text.Label;
	import com.wezside.utilities.date.DateUtil;

	/**
	 * @author FChowdhury
	 */
	public class IndicatorCurrentTime extends ControlElement
	{

		private var label:Label;
		private var dateUtil:DateUtil;

		public function IndicatorCurrentTime( decorated:IUIDecorator )
		{
			super( decorated );
			dateUtil = new DateUtil();
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
			label.x = 5;
			label.build();
			label.setStyle();
			label.arrange();
			addChild( label );
			super.build();
		}

		override public function update( media:IMedia ):void
		{
			super.update( media );
			var milliseconds:Number = media.currentTime * 1000;
			var mins:String = dateUtil.minutesFromMilliseconds( milliseconds ).toString();
			var seconds:String = dateUtil.secondsFromMilliseconds( milliseconds ).toString();			
			label.text = formatDuration( mins, seconds );
			label.x = int( media.currentTime / media.totalTime * width ) + 5;			
		}

		private function formatDuration( mins:String, seconds:String ):String
		{
			if ( mins.length == 1 ) mins = "0" + mins;
			if ( seconds.length == 1 ) seconds = "0" + seconds;
			return mins + ":" + seconds;
		}
	}
}
