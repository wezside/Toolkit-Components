package com.wezside.component.survey.form
{
	import com.wezside.component.survey.data.IFormGroupData;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.components.UIElement;
	import com.wezside.components.UIElementState;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.iterator.IIterator;

	import flash.utils.getDefinitionByName;



	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormGroup extends UIElement implements IFormGroup
	{
		
		public static const STATE_IGNORED:String = "STATE_IGNORED";
		public static const STATE_NORMAL:String = "STATE_NORMAL";
		public static const STATE_HIDDEN:String = "STATE_HIDDEN";
		public static const STATE_VISIBLE:String = "STATE_VISIBLE";
				
		private var _data:IFormGroupData;
		
		public function FormGroup() 
		{
			super();
			stateManager.addState( STATE_IGNORED );	
			stateManager.addState( STATE_NORMAL );	
			stateManager.addState( STATE_HIDDEN );	
			stateManager.addState( STATE_VISIBLE );	
		}

		override public function build():void
		{
			super.build();
			if ( !styleManager ) styleManager = _data.styleManager;
			styleName = getStyleName( _data.id );
			createItems();
		}
	
		override public function set state( value:String ):void
		{
			super.state = value;
			switch ( value )
			{
				case STATE_IGNORED: data.valid = true; break;
				case STATE_HIDDEN: visible = false; break;
				case STATE_VISIBLE: visible = true; break;
				case STATE_NORMAL:
				default: break; 
			}
		}

		override public function purge():void
		{
			var it:IIterator = iterator( ITERATOR_CHILDREN );
			while ( it.hasNext() )
			{
				UIElement( it.next() ).purge();
			}
			it.purge();
			it = null;
			super.purge();
			_data = null;
		}

		public function get data():IFormGroupData
		{
			return _data;
		}

		public function set data( value:IFormGroupData ):void
		{
			_data = value;
		}

		public function getItemByID( id:String ):IFormItem
		{
			var iterator:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			while ( iterator.hasNext())
			{
				var item:IFormItem = iterator.next() as IFormItem;
				if ( item.id == id ) return item as IFormItem;
			}
			return null;
		}

		public function get parentForm():IForm
		{
			return null;
		}

		public function set parentForm( value:IForm ):void
		{
		}

		protected function getStyleName( id:String ):String
		{
			var cssID:String = id;
			if ( _data && _data.styleNameCollection )
			{
				var cssDataItem:CSSDataItem = _data.styleNameCollection.find( "id", id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}

		/**
		 *  Note on valid
		 *  this determines whether data within a group is valid for form submission
		 * Therefore the if the group does not contain any data to submit (it contains static text) 
		 * then it's valid state should be true
		 */
		private function createItems():void
		{
			var groupIterator:IIterator;
			var itemData:IFormItemData;
			var formItem:IFormItem;

			var sliderData:Collection = new Collection();
			var hasSliderData:Boolean = false;

			// Loop through all the itemData objects
			groupIterator = _data.iterator;
			while ( groupIterator.hasNext())
			{
				itemData = IFormItemData( groupIterator.next() );

				if ( itemData.type == FormItem.ITEM_SLIDER )
				{
					// found a slider item, so add it to the
					// sliderData and make sure all is valid
					_data.valid = true;
					itemData.valid = sliderData.length == 0;

					sliderData.addElement( itemData );
					hasSliderData = true;
				}
				else
				{
					formItem = getFormItem( itemData.type );
					formItem.data = itemData;
					formItem.debug = false;
					formItem.styleManager = styleManager;
					formItem.build();
					formItem.setStyle();
					formItem.arrange();
					
					// Static text and CTAs have no data to submit so do not need a validation check
					if ( formItem.type == FormItem.ITEM_TYPE_STATIC_TEXT || formItem.type == FormItem.ITEM_CALL_TO_ACTION )
						formItem.valid = true;

					if ( itemData.state == UIElementState.STATE_VISUAL_DISABLED )
						formItem.deactivate();
					else
						formItem.activate();

					itemData.state = ( itemData.state == null ) ? UIElementState.STATE_VISUAL_UP : itemData.state;
					formItem.state = itemData.state;

					if ( _data.ignoreList && _data.ignoreList.find( "id", formItem.id ))
					{
						formItem.valid = true;
						formItem.data.valid = true;
					}
					else
					{						
						addChild( formItem as UIElement );
					}
				}
			}
			groupIterator.purge();
			groupIterator = null;

			// TODO: Need another way of allowing for custom form items to be added.
			/*
			if ( hasSliderData > 0 )
			{
				// add a slider
				var slider:Slider = Slider( getFormItem( FormItem.ITEM_SLIDER ) );
				slider.sliderData = sliderData;
				slider.debug = false;
				slider.valid = true;
				slider.styleManager = styleManager;
				slider.build();
				slider.setStyle();
				slider.arrange();
				addChild( slider as UIElement );

				slider = null;
			}
			sliderData = null;
			 * 
			 */
		}

		private function getFormItem( type:String ):IFormItem
		{
			var clazz:Class = getFormClass( type );
			var item:IFormItem = new clazz() as IFormItem;
			return item;
		}

		private function getFormClass( className:String ):Class
		{
			return getDefinitionByName( _data.formItemNS + "::" + className ) as Class;
		}
	}
}
