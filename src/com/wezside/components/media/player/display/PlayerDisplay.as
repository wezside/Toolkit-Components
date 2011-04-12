package com.wezside.components.media.player.display
{
	import com.wezside.components.UIElement;
	import com.wezside.data.collection.DictionaryCollection;
	import com.wezside.data.collection.IDictionaryCollection;
	
	/**
	 * @author Wesley.Swanepoel
	 */
	public class PlayerDisplay extends UIElement implements IPlayerDisplay 
	{
		
		private var types:IDictionaryCollection;
				
		
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
			return super.width;
		}
			
		override public function get height():Number
		{
			return 250;
		}

	}
}
