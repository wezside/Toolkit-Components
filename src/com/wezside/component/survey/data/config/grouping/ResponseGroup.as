package com.wezside.component.survey.data.config.grouping
{
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.IDeserializable;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ResponseGroup implements IDeserializable
	{
		
		public var id:String;
		
		public var items:ICollection;
	}
}
