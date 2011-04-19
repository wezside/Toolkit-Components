package com.wezside.components.media.player.display
{
	import com.wezside.components.UIElement;
	import com.wezside.components.media.player.media.IMedia;
	import com.wezside.data.collection.DictionaryCollection;
	import com.wezside.data.collection.IDictionaryCollection;
	import com.wezside.data.iterator.IIterator;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerDisplay extends UIElement implements IPlayerDisplay 
	{
		
		private var _displayWidth:int;
		private var _displayHeight:int;
		private var types:IDictionaryCollection;
		private var _maintainAspectRatio:Boolean;
				
		
		public function PlayerDisplay() 
		{
			types = new DictionaryCollection();	
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

		public function set maintainAspectRatio( value:Boolean ):void
		{
			_maintainAspectRatio = value;
		}

	}
}
