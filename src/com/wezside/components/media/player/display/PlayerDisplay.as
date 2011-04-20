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
		 * the correct values. This will happen when the Player class receives the
		 * current playing media resource's meta data.
		 */
		override public function arrange():void
		{
			if ( _displayWidth != 0 && _displayHeight != 0 )
			{
				background.width = _displayWidth;
				background.height = _displayHeight;				
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
							if ( media.height > displayHeight )
							{
								resizer.resizeToHeight( media as DisplayObject, displayHeight );
								resizer.distribute( media as DisplayObject, displayWidth, Resizer.DISTRIBUTE_TO_WIDTH );
							}
							resizer.distribute( media as DisplayObject, displayHeight, Resizer.DISTRIBUTE_TO_HEIGHT );
						}
					}
					else
					{
						while ( it.hasNext() )
						{
							media = it.next() as IMedia;
							if ( !media ) continue;
							resizer.resizeToHeight( media as DisplayObject, displayHeight );
							if ( media.width > displayWidth )
							{
								resizer.resizeToWidth( media as DisplayObject, displayWidth );
								resizer.distribute( media as DisplayObject, displayHeight, Resizer.DISTRIBUTE_TO_HEIGHT );
							}							
							resizer.distribute( media as DisplayObject, displayWidth, Resizer.DISTRIBUTE_TO_WIDTH );
						}
					}
				}
				it.purge();
				it = null;
				media = null;
				super.arrange();
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
				media.height = value;
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
				media.width = value;
			}
			it.purge();
			it = null;
			media = null;			
		}

		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}

		/**
		 * Set this property to true if the media display should resize keeping the aspect ratio 
		 * as it was. The media will only be resized to maintain its aspect ratio should either of 
		 * this display width or height proeprties be different to the media's original width and height. 
		 */
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
