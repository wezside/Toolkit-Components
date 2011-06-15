package com.wezside.component.survey.data.config 
{
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.IDeserializable;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class CSSData implements IDeserializable 
	{		
		
		public var id:String;
		public var css:ICollection;		
		
		public function cssItem( id:String ):CSSDataItem
		{
			return css ? css.find( "id", id ) as CSSDataItem : null;
		}
	}
}
