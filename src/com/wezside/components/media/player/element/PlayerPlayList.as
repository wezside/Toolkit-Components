package com.wezside.components.media.player.element
{
	import com.wezside.components.UIElementState;
	import com.wezside.components.UIElementEvent;
	import com.wezside.components.decorators.layout.ILayout;
	import com.wezside.data.collection.Collection;
	import flash.text.TextFieldAutoSize;
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.components.text.Label;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerPlayList extends UIElement implements IPlayerPlayList
	{
		public var entries:ICollection = new Collection();
		
		private var label:Label;
		private var _autoSize:Boolean;
		private var _displayWidth:int;
		private var _displayHeight:int;
	
	
		override public function build():void
		{
			super.build();
						
			var it:IIterator = entries.iterator();
			var resource:IMediaResource;
			while ( it.hasNext() )
			{
				resource = it.next() as IMediaResource;
				label = new Label();
				label.font = "_sans";
				label.embedFonts = false;
				label.autoSize = TextFieldAutoSize.LEFT; 
				label.text = resource.title;
				label.textColorOver = 0xFFFFFF;
				label.build();
				label.setStyle();
				label.arrange();
				label.addEventListener( UIElementEvent.STATE_CHANGE, stateChange );
				label.activate();
				addChild( label );				
			}
			it.purge();
			it = null;
			resource = null;
			
		}
	
		override public function arrange():void
		{
			if ( _displayWidth != 0 && _displayHeight != 0 )
			{
				background.width = _displayWidth;
				background.height = _displayHeight;			
			}			
			super.arrange();
		}

		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize( value:Boolean ):void
		{
			_autoSize = value;
		}

		public function get displayWidth():int
		{
			return _displayWidth;
		}

		public function set displayWidth( value:int ):void
		{
			_displayWidth = value;	
		}

		public function get displayHeight():int
		{
			return _displayHeight;
		}

		public function set displayHeight( value:int ):void
		{
			_displayHeight = value;
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
		
		private function stateChange( event:UIElementEvent ):void
		{
			if ( event.state.key == UIElementState.STATE_VISUAL_CLICK )
			{
				
			}
		}		
	}
}
