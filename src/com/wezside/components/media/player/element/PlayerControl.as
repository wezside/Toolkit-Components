package com.wezside.components.media.player.element
{
	import com.wezside.components.UIElement;
	import com.wezside.data.iterator.IIterator;

	import flash.display.DisplayObject;

	
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerControl extends UIElement implements IPlayerControl 
	{
				
		private var _displayWidth:int;
		private var _element:IControlElement;
		private var _displayHeight:int;
		private var _autoSize:Boolean;
		
		
				
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
			super.arrange();
			_element.arrange();
		}
				
		override public function set state( value:String ):void
		{
			super.state = value;
			_element.state = value;
		}
		
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		/**
		 * This flag will opt in or opt out of resizing. If true the width and height values
		 * will be determined by the Player's autoSizePolicy property. 
		 * <br>
		 * @param value The flag value indicating if auto sizing should occur for the decorator 
		 * IControlElements applied to this PlayerControl instance
		 * @see com.wezside.components.media.player.Player Player Class
		 */
		public function set autoSize( value:Boolean ):void
		{
			_autoSize = value;
		}
		
		public function get element():IControlElement
		{
			return _element;
		}
		
		public function set element( value:IControlElement ):void
		{
			_element = value;
			addChild( _element as DisplayObject );
		}
		
		public function set displayWidth( value:int ):void 
		{
			_displayWidth = value;
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var element:IControlElement;
			while ( it.hasNext() )
			{
				element = it.next() as IControlElement;
				trace( element, element.autoSize );
				if ( element.autoSize ) element.width = value;
			}
			it.purge();
			it = null;
			element = null;
		}
		
		public function get displayWidth():int
		{
			return _displayWidth;
		}
		
		public function get displayHeight():int
		{
			return _displayHeight;
		}
		
		public function set displayHeight( value:int ):void
		{
			_displayHeight = value;
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var element:IControlElement;
			while ( it.hasNext() )
			{
				element = it.next() as IControlElement;
				if ( element.autoSize ) element.height = value;
			}
			it.purge();
			it = null;
			element = null;
		}

		public function hasLayoutDecorator( clazz:Class ):void
		{
		}
	}
}
