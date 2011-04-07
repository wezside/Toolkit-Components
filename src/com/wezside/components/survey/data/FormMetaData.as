package com.wezside.components.survey.data {
	import com.wezside.data.collection.ICollection;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.style.IStyleManager;

	/**
	 * @author Wesley.Swanepoel
	 * 
	 * Refers to any additional content that a Form might have.
	 * This can be anything to additional text to media assets.  
	 */
	public class FormMetaData implements IFormMetaData {
		
		private var _data : *;
		private var _id : String;
		private var _label : String;
		private var _sublabel : String;
		private var _styleManager : IStyleManager;
		private var _styleNameCollection:ICollection;
		private var _ignoreList:ICollection;
		
		
		public function get data() : * {
			return _data;
		}
		public function set data( value : * ) : void {
			_data = value;
		}
		
		public function get id() : String {
			return _id;
		}
		public function set id( value : String ) : void {
			_id = value;
		}
		
		public function get label() : String {
			return _label;
		}
		public function set label( value : String ) : void {
			_label = value;
		}
		
		public function get sublabel() : String {
			return _sublabel;
		}
		public function set sublabel( value : String ) : void {
			_sublabel = value;
		}
		
		public function get styleManager() : IStyleManager {
			return _styleManager;
		}
		public function set styleManager( value : IStyleManager ) : void {
			_styleManager = value;
		}
		
		public function get styleNameCollection() : ICollection {
			return _styleNameCollection;
		}
		public function set styleNameCollection( value : ICollection ) : void {
			_styleNameCollection = value;
		}
		
		
		public function debug() : void {
			Tracer.output( true, "\t\tMETA id: " + _id + " | " + " | Styles [" + styleNameCollection + "]" + " | Ignore [" + ignoreList + "]", "" );
		}

		public function get ignoreList():ICollection
		{
			return _ignoreList;
		}

		public function set ignoreList( value:ICollection ):void
		{
			_ignoreList = value;
		}
	}
}
