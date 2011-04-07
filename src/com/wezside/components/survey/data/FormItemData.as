package com.wezside.components.survey.data {
	import com.wezside.components.UIElementState;
	import com.wezside.data.collection.ICollection;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.style.IStyleManager;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormItemData implements IFormItemData {
		
		private var _id : String;
		private var _type : String;
		private var _value : String;
		private var _label : String;
		private var _sublabel : String;
		private var _maxLength : String;
		private var _prefix : String;
		private var _suffix : String;
		private var _styleName : String;
		private var _iconStyleName : String;
		private var _valid : Boolean;
		private var _state : String;
		private var _parent : IFormGroupData;
		private var _styleManager : IStyleManager;
		private var _styleNameCollection : ICollection;
		private var _customCollection : ICollection;
		private var _groupID:String;
		private var _ignoreList:ICollection;
		private var _formItemsNS:Namespace = new Namespace( "", "com.wezside.components.survey.form.item" );
		private var _className:String;
		
		public function get id() : String {
			return _id;
		}
		public function set id( value : String ) : void {
			_id = value;
		}
		
		public function get type() : String {
			return _type;
		}
		public function set type( value : String ) : void {
			_type = value;
		}
		
		public function get value() : String {
			return _value;
		}
		public function set value( newValue : String ) : void {
			_value = newValue;
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
		
		public function get prefix() : String {
			return _prefix;
		}
		public function set prefix( value : String ) : void {
			_prefix = value;
		}
		
		public function get suffix() : String {
			return _suffix;
		}
		public function set suffix( value : String ) : void {
			_suffix = value;
		}
		
		public function get styleName() : String {
			return _styleName;
		}
		public function set styleName( value : String ) : void {
			_styleName = value;
		}
		
		public function get iconStyleName() : String {
			return _iconStyleName;
		}
		public function set iconStyleName( value : String ) : void {
			_iconStyleName = value;
		}
		
		public function get valid() : Boolean {
			return _valid;
		}
		public function set valid( value : Boolean ) : void {
			_valid = value;
		}
		
		public function get state() : String {
			return _state;
		}
		public function set state( value : String ) : void {
			_state = value;
		}
		
		public function get parent() : IFormGroupData {
			return _parent;
		}
		public function set parent( value : IFormGroupData ) : void {
			_parent = value;
		}
		
		public function get styleManager() : IStyleManager {
			return _styleManager;
		}
		public function get styleNameCollection() : ICollection {
			return _styleNameCollection;
		}
		
		public function set styleManager( value : IStyleManager ) : void {
			_styleManager = value;
		}
		public function set styleNameCollection( value : ICollection ) : void {
			_styleNameCollection = value;
		}
		
		public function get groupID() : String {
			return _groupID;
		}
		public function set groupID( value : String ) : void {
			_groupID = value;
		}
		
		public function debug() : void {
			Tracer.output( true, "\t\t\t Item: " + _id + " | type: " + _type + " | Styles [" + styleNameCollection + "]" + " | Ignore [" + ignoreList + "]", "" );
			Tracer.output( true, "\t\t\t\t Label: " + _label, "" );
			Tracer.output( true, "\t\t\t\t SubLabel: " + _sublabel, "" );
		}
		
		public function purge() : void {
			//
		}
		
		public function purgeData() : void {
			_value = null;
			_valid = false;
			_state = UIElementState.STATE_VISUAL_UP;
		}

		public function get ignoreList():ICollection
		{
			return _ignoreList;
		}

		public function set ignoreList( value:ICollection ):void
		{
			_ignoreList = value;
		}

		public function get maxLength() : String {
			return _maxLength;
		}

		public function set maxLength(value : String) : void {
			_maxLength = value;
		}
				public function get formItemNS():Namespace
		{
			return _formItemsNS;
		}
		
		public function set formItemNS( value:Namespace ):void
		{
			_formItemsNS = value;
		}

		public function get className() : String {
			return _className;
		}

		public function set className(value : String) : void {
			_className = value;
		}

		public function get customCollection() : ICollection {
			return _customCollection;
		}

		public function set customCollection(value : ICollection) : void {
			_customCollection = value;
		}
	}
}