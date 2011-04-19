package com.wezside.components.media.player.display
{
	import com.wezside.components.decorators.shape.ShapeRectangle;
	import flash.display.DisplayObject;
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.data.collection.DictionaryCollection;
	import com.wezside.data.collection.IDictionaryCollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.imaging.Resizer;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerDisplay extends UIElement implements IPlayerDisplay 
	{
		
		private var _displayWidth:int;
		private var _displayHeight:int;
		private var _maintainAspectRatio:Boolean;
		
		private var resizer:Resizer;
		private var types:IDictionaryCollection;
				
		
		public function PlayerDisplay() 
		{
			resizer = new Resizer();
			types = new DictionaryCollection();	
			background = new ShapeRectangle( this );
			background.alphas = [ 1, 1 ];
			background.colours = [ 0, 0 ];
		}		
	
		/**
		 * The condition displayWidth and displayHeight properties need to be set 
		 * before the arrange should be called. This is to ensure the background get 
		 * the correct values.
		 */
		override public function arrange():void
		{
			if ( _displayWidth != 0 && _displayHeight != 0 )
			{
				background.width = _displayWidth;
				background.height = _displayHeight;
				super.arrange();
				var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
				var media:IMedia;			
				if ( maintainAspectRatio && ( displayWidth != originalWidth || displayHeight != originalHeight ))
				{
					if ( displayWidth > displayHeight )
					{
						while ( it.hasNext() )
						{
							media = it.next() as IMedia;
							if ( !media ) continue;
							resizer.resizeToWidth( media as DisplayObject, displayWidth );
							resizer.distribute( media as DisplayObject, displayHeight, Resizer.DISTRIBUTE_TO_HEIGHT );
						}
					}
					else
					{
						while ( it.hasNext() )
						{
							media = it.next() as IMedia;
							if ( !media ) continue;
							resizer.resizeToWidth( media as DisplayObject, displayHeight );
							resizer.distribute( media as DisplayObject, displayHeight, Resizer.DISTRIBUTE_TO_HEIGHT );
						}
					}
				}	
				it.purge();
				it = null;
				media = null;
			}
		}

		public function show():void
		{
		}

		public function hide():void
		{
		}		

		public function find( mediaType:String ):String
		{
			return types.getElement( mediaType );
		}
				
		public function addMediaType( id:String ):void
		{
			types.addElement( id, types.length ); 
		}
			
		override public function get width():Number
		{
			return _displayWidth ? _displayWidth : super.width;
		}
			
		override public function get height():Number
		{
			return _displayHeight ? _displayHeight : super.height;
		}
		
		public function get displayHeight():int
		{
			return _displayHeight;
		}
		
		public function set displayHeight( value:int ):void
		{
			_displayHeight = value;
			
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var media:IMedia;
			while ( it.hasNext() )
			{
				media = it.next() as IMedia;
				if ( !media ) continue;
				if ( !maintainAspectRatio ) media.height = value;
			}
			it.purge();
			it = null;
			media = null;
		}
		
		public function get displayWidth():int
		{
			return _displayWidth;
		}
		
		public function set displayWidth( value:int ):void
		{
			_displayWidth = value;
			
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var media:IMedia;
			while ( it.hasNext() )
			{
				media = it.next() as IMedia;
				if ( !media ) continue;
				if ( !maintainAspectRatio ) media.width = value;
			}
			it.purge();
			it = null;
			media = null;			
		}

		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}

		public function set maintainAspectRatio( value:Boolean ):void
		{
			_maintainAspectRatio = value;
		}

		public function get originalWidth():int
		{
			return resizer.originalWidth;
		}

		public function set originalWidth( value:int ):void
		{
			resizer.originalWidth = value;
		}

		public function get originalHeight():int
		{
			return resizer.originalHeight;
		}

		public function set originalHeight( value:int ):void
		{
			resizer.originalHeight = value;
		}

	}
}
