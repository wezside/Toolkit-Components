package com.wezside.component.survey.data.config.grouping
{
	import com.wezside.data.IDeserializable;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ResponseGroupData implements IDeserializable
	{
		public var id:String;
		public var responses:ICollection;
	}
}
