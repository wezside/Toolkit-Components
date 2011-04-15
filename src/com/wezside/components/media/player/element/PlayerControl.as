package com.wezside.components.media.player.element
{
	import com.wezside.components.UIElement;
	import flash.display.DisplayObject;

	
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerControl extends UIElement implements IPlayerControl 
	{
				
		private var _element:IControlElement;
		
				
		public function PlayerControl() 
		{
			_element = new ControlElement( this );
		}
			
		override public function build():void
		{
			super.build();
			_element.build();
		}
			
		override public function arrange():void
		{
			_element.arrange();
			super.arrange();
		}
				
		override public function set state( value:String ):void
		{
			super.state = value;
			_element.state = value;
		}
		
		public function get element():IControlElement
		{
			return _element;
		}
		
		public function set element( value:IControlElement ):void
		{
			_element = value;
		}

		/**
		 * <p>Applies a decorator to the PlayerControl class. It is used to build up the controls 
		 * for the media player. This will allow flexibility in setting up controls for media
		 * resources.</p>
		 * 
		 * <p>Because each controll element is different, a different method signature is used for each 
		 * element. This refers to the arguments that is allowed to be set. </p>
		 * 
		 * <p>Common parameters. The order is important. Should you need to skip a parameter make sure
		 * to pass null otherwise the wrong values will be used.</p>
		 * 
		 * @param args[0] The styleName value to be passed to the decorator
		 * @param args[1] Generic data object. Use this to pass additional data to a decorator like text
		 * @param args[2] Width of the Control Element 
		 * @param args[3] Height of the Control Element 
		 * @param args[4] Flag the Control Element to receive udpates via the update() method 
		 */
		public function decorate( Control:Class, ...args ):void
		{
			_element = new Control( this.element );
			_element.styleName = args[0];
			_element.styleManager = styleManager;
			_element.data = args[1];
			_element.width = args[2] ? args[2] : 0;
			_element.height = args[3] ? args[3] : 0;
			_element.flagForUpdate = args[4];
			addChild( _element as DisplayObject );
		}
	}
}
