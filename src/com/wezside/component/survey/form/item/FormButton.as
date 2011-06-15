package com.wezside.component.survey.form.item
{
	import com.wezside.component.UIElementEvent;
	import com.wezside.component.UIElementState;
	import com.wezside.component.control.Button;
	import com.wezside.component.decorators.interactive.InteractiveSelectable;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.component.survey.form.IFormGroup;
	import com.wezside.component.survey.form.IFormItem;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormButton extends Button implements IFormItem {
		
		private var _data : IFormItemData;
		
		
		override public function build() : void {
			
			interactive = new InteractiveSelectable( this );
			
			if ( styleManager == null ) styleManager = _data.styleManager;
			styleName = getStyleName( _data.id );
			
			text = _data.label;
			
			addEventListener( UIElementEvent.STATE_CHANGE, stateChange );
		}
		
		override public function setStyle() : void {
			super.setStyle();
			iconStyleName = styleName + "Icon";
			super.build();
		}
		
		override public function purge() : void {
			removeEventListener( UIElementEvent.STATE_CHANGE, stateChange );
			super.purge();
			_data = null;
		}
		
		public function showValid( value : Boolean ) : void {
			// NOT REQUIRED FOR THIS IMPLEMENTATION
		}
		
		override public function get id() : String { return _data ? _data.id : ""; }
		public function get type() : String { return _data ? _data.type : ""; }
		
		public function get value() : String { return "N/A"; }
		public function set value( value : String ) : void {
			super.text = _data.label = value;
		}
		
		public function get selected() : Boolean {
			return stateManager.compare( UIElementState.STATE_VISUAL_SELECTED );
		}
		public function set selected( value : Boolean ) : void {
			if ( stateManager.compare( UIElementState.STATE_VISUAL_SELECTED ) ) {
				valid = false;
				_data.state = UIElementState.STATE_VISUAL_UP;
			}
		}
		
		public function get data() : IFormItemData { return _data; }
		public function set data( value : IFormItemData ) : void { _data = value; }
		
		public function get parentGroup() : IFormGroup { return null; }
		public function set parentGroup( value : IFormGroup ) : void { }
		
		public function get valid() : Boolean { return _data.valid; }
		public function set valid( value : Boolean ) : void {
			
			if ( _data.valid ) {
				// Check if state that is showing is INVALID_STATE - If it is turn it off
				if ( stateManager.compare( UIElementState.STATE_VISUAL_INVALID )) {
					state = UIElementState.STATE_VISUAL_INVALID;
					state = UIElementState.STATE_VISUAL_UP;
				}
				// Check if state that is showing is SELECTED - If it is turn it off
				if ( stateManager.compare( UIElementState.STATE_VISUAL_SELECTED )) {
					state = UIElementState.STATE_VISUAL_SELECTED;
					state = UIElementState.STATE_VISUAL_UP;
					_data.valid=false;
				}
			}
			else {
				// Data entry is not valid
				// Check if current visual state is INVALID
				if ( stateManager.compare( UIElementState.STATE_VISUAL_INVALID )) {
					// Do nothing
				}
				else {
					state = UIElementState.STATE_VISUAL_INVALID;
					
				}
			}
		}
		
		protected function getStyleName( id : String ) : String {
			var cssID : String;
			if ( _data && _data.styleNameCollection ) {
				var cssDataItem : CSSDataItem = data.styleNameCollection.find( "id", id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}
		
		protected function stateChange( event : UIElementEvent ) : void {
			//
		}
	}
}