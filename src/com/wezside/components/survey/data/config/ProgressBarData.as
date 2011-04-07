package com.wezside.components.survey.data.config 
{
	import com.wezside.data.IDeserializable;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ProgressBarData implements IDeserializable 
	{
		public var id:String;
		public var items:ICollection;
		
		public function item( id:String ):ProgressBarItem
		{
			return items ? items.find( "id", id ) as ProgressBarItem : null;
		}
		
		public function hasFormID( progressBarItem : ProgressBarItem, id : String ) : Boolean 
		{
			var forms : String = progressBarItem.formID.toLowerCase();
			return ( forms.indexOf( id.toLowerCase() ) > -1 );
		}
	}
}