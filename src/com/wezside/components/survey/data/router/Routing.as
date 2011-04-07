package com.wezside.components.survey.data.router 
{
	import com.wezside.data.IDeserializable;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class Routing implements IDeserializable
	{
		
		public var routes:ICollection;		
		
		public function route( id:String = "" ):Route
		{
			return routes ? Route( routes.find( "id", id )) : null;
		}
		
		public function purge():void
		{
			if ( routes ) routes.purge();
			routes = null;
		}
	}
}