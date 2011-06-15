package com.wezside.component.survey.data.config
{
	import com.wezside.data.IDeserializable;
	import com.wezside.data.ItemData;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class IgnoreData implements IDeserializable
	{
		public var id:String;
		public var ignoreItems:ICollection;		
		
		public function ignoreItem( id:String ):ItemData
		{
			return ignoreItems ? ignoreItems.find( "id", id ) as ItemData : null;
		}		
	}
}
