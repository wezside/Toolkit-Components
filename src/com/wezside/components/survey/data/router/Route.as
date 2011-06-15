package com.wezside.component.survey.data.router {
	import com.wezside.data.IDeserializable;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class Route implements IDeserializable {
		
		public var id : String;
		public var nextpath : String;
		public var routes : ICollection;
		
		
		public function route( id : String = "" ) : Route {
			return routes ? Route( routes.find( "id", id ) ) : null;
		}
		
		public function purge() : void {
			if ( routes ) routes.purge();
			routes = null;
		}
	}
}