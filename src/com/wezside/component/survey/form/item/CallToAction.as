package com.wezside.component.survey.form.item
{
	import com.wezside.component.UIElementEvent;
	import com.wezside.component.UIElementState;
	import com.wezside.component.control.Button;
	import com.wezside.component.decorator.interactive.InteractiveSelectable;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.component.survey.form.FormEvent;
	import com.wezside.component.survey.form.IFormGroup;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class CallToAction extends Button implements IFormItem
	{
		private var _data:IFormItemData;

		override public function build():void
		{
			interactive = new InteractiveSelectable( this );

			if ( styleManager == null ) styleManager = _data.styleManager;
			styleName = getStyleName( data.id );

			text = _data.label;

			addEventListener( UIElementEvent.STATE_CHANGE, stateChange );
		}

		override public function setStyle():void
		{
			super.setStyle();
			iconStyleName = styleName + "Icon";
			super.build();
		}

		override public function purge():void
		{
			removeEventListener( UIElementEvent.STATE_CHANGE, stateChange );

			super.purge();

			_data = null;
		}

		private function stateChange( event:UIElementEvent ):void
		{
			if ( event.state.key == UIElementState.STATE_VISUAL_SELECTED )
			{
				dispatchEvent( new FormEvent( FormEvent.ITEM_STATE_CHANGE, true ) );
			}
		}

		override public function get id():String
		{
			return _data ? _data.id : "";
		}

		public function get value():String
		{
			return "N/A";
		}

		public function set value( value:String ):void
		{
			super.text = _data.label = value;
		}

		public function get type():String
		{
			return _data ? _data.type : "";
		}

		public function set type( value:String ):void
		{
		}

		public function get selected():Boolean
		{
			return false;
		}

		public function set selected( value:Boolean ):void
		{
		}

		public function get data():IFormItemData
		{
			return _data;
		}

		public function set data( value:IFormItemData ):void
		{
			_data = value;
		}

		public function get parentGroup():IFormGroup
		{
			return null;
		}

		public function set parentGroup( value:IFormGroup ):void
		{
		}

		public function get valid():Boolean
		{
			return true;
		}

		public function set valid( value:Boolean ):void
		{
		}

		protected function getStyleName( id:String ):String
		{
			var cssID:String;
			if ( _data && _data.styleNameCollection )
			{
				var cssDataItem:CSSDataItem = data.styleNameCollection.find( id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}

		public function setDataCollection( collection:ICollection ):void
		{
		}
	}
}
