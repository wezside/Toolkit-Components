package com.wezside.component.survey.data.config {
	import com.wezside.data.IDeserializable;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author fchowdhury
	 */
	public class MetaData implements IDeserializable {
		
		public var metaSettings : ICollection;		
		
		
		public function metaSetting( id : String ) : MetaSetting {
			return metaSettings ? metaSettings.find( "id", id ) as MetaSetting : null;
		}
	}
}