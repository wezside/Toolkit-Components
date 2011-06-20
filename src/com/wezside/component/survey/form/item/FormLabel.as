package com.wezside.component.survey.form.item
{
	import com.wezside.component.UIElementState;
	import com.wezside.component.decorator.layout.VerticalLayout;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.component.text.Label;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormLabel extends Label implements IFormItem
	{
		private var _data:IFormItemData;
		private var sublabel:Label;

		public function FormLabel()
		{
			super();
			layout = new VerticalLayout( this );
		}

		override public function set width( value:Number ):void
		{
			if ( sublabel ) sublabel.width = value;
			super.width = value;
			arrange();
		}

		public function set subLabelText( value:String ):void
		{
			if ( value != null && value != "" && value != " " )
			{
				// should have a sub label
				if ( !sublabel ) createSubLabel();
				// update the sublabel copy
				sublabel.text = value;
				sublabel.setStyle();
				sublabel.arrange();
			}
			else if ( sublabel )
			{
				// remove sublabel
				removeChild( sublabel );
				sublabel.purge();
				sublabel = null;
			}
		}

		public function get subLabelText():String
		{
			return sublabel ? sublabel.text : "";
		}

		override public function build():void
		{
			super.build();

			if ( styleManager == null ) styleManager = _data.styleManager;
			if ( 	_data.sublabel && _data.sublabel != "" && _data.sublabel != " " )
			{
				createSubLabel();
			}

			state = UIElementState.STATE_VISUAL_UP;
			styleName = getStyleName( id );
			text = _data.label;
		}

		override public function purge():void
		{
			super.purge();

			sublabel = null;
			_data = null;
		}

		override public function arrange():void
		{
			if ( sublabel ) sublabel.arrange();
			super.arrange();
		}

		public function get id():String
		{
			return _data ? _data.id : "";
		}

		public function get type():String
		{
			return _data ? _data.type : "";
		}

		public function get value():String
		{
			return "N/A";
		}

		public function set value( value:String ):void
		{
			if ( _data ) _data.label = value;
			super.text = value;
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

		public function get valid():Boolean
		{
			return true;
		}

		public function set valid( value:Boolean ):void
		{
		}

		// Override not to do anything
		override public function activate():void
		{
		}

		protected function getStyleName( id:String ):String
		{
			var cssID:String;
			if ( _data && _data.styleNameCollection )
			{
				var cssDataItem:CSSDataItem = data.styleNameCollection.find( "id", id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}

		private function createSubLabel():void
		{
			sublabel = new Label();
			sublabel.styleManager = styleManager;
			sublabel.styleName = "FormSubLabel";
			sublabel.text = _data.sublabel;
			sublabel.build();
			sublabel.setStyle();
			sublabel.arrange();
			addChild( sublabel );
		}

		public function setDataCollection( collection:ICollection ):void
		{
		}
	}
}