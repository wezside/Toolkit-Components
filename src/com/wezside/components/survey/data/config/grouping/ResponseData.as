package com.wezside.components.survey.data.config.grouping
{
	import com.wezside.data.IDeserializable;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ResponseData implements IDeserializable
	{
		public var id:String;		
		public var items:ICollection;		
	}
}
