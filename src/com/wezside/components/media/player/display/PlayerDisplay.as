package com.wezside.components.media.player.display
{
	import com.wezside.components.UIElement;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerDisplay extends UIElement implements IPlayerDisplay 
	{
		
		private var _mediaWidth:int;
		private var _mediaHeight:int;
		
		public function get mediaWidth():int
		{
			return _mediaWidth;
		}

		public function set mediaWidth( value:int ):void
		{
			_mediaWidth = value;
		}

		public function get mediaHeight():int
		{
			return _mediaHeight;
		}

		public function set mediaHeight( value:int ):void
		{
			_mediaHeight = value;
		}
			
	}
}
