package com.wezside.components.media.player.element
{
	import com.wezside.components.UIElement;
	import com.wezside.components.decorators.layout.HorizontalLayout;
	import com.wezside.components.decorators.layout.ILayout;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.ICollection;
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
		
		/**
		 * @inheritDoc
		 */
		public function set displayWidth( value:int ):void 
		{
			_displayWidth = value;
			
			// Get all non autoSize elements
			var w:Number = 0;
			
			// Only deduct the non-autosize elements width if the layout
			// is HorizontalLayout
			if ( hasLayoutDecorator( layout, HorizontalLayout ))
			{
				var it:IIterator = autoSizeElements( false ).iterator();
				var element:IControlElement;
				while ( it.hasNext() )
				{
					element = it.next() as IControlElement;
					w += element.width;
					w += layout.horizontalGap;
				}
				it.purge();
				it = null;
				element = null;
			}
			
			// Get all autoSize elements
			var remainingWidth:Number = _displayWidth - w;
			it = autoSizeElements( true ).iterator();
			while ( it.hasNext() )
			{
				element = it.next() as IControlElement;
				element.width = int( remainingWidth / it.length() );
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
			
			// Get all non autoSize elements
			var h:Number = 0;
			var it:IIterator = autoSizeElements( false ).iterator();
			var element:IControlElement;
			while ( it.hasNext() )
			{
				element = it.next() as IControlElement;
				h += element.height;
			}
			it.purge();
			it = null;
			element = null;
			
			// Get all autoSize elements
			var remainingHeight:Number = _displayHeight - h;
			it = autoSizeElements( true ).iterator();
			while ( it.hasNext() )
			{
				element = it.next() as IControlElement;
				element.height = int( remainingHeight / it.length() );
			}
			it.purge();
			it = null;
			element = null;	
		}

		public function hasLayoutDecorator( layout:ILayout, decorator:Class ):Boolean
		{
			if ( layout is decorator ) return true;
			var result:Boolean;
			var chainLayout:ILayout = layout.chain();
			if ( chainLayout )
				result = hasLayoutDecorator( chainLayout, decorator );
			else
				result = layout is decorator;
			return result;
		}
		
		private function autoSizeElements( value:Boolean ):ICollection
		{
			var collection:ICollection = new Collection();
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var element:IControlElement;
			while ( it.hasNext() )
			{
				element = it.next() as IControlElement;
				if ( element.autoSize == value ) collection.addElement( element );
			}
			it.purge();
			it = null;
			element = null;			
			return collection;
		}
	}
}
