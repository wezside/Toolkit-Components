package com.wezside.component.survey.form
{
	import com.wezside.component.UIElement;
	import com.wezside.component.UIElementState;
	import com.wezside.component.survey.data.IFormGroupData;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
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
				case STATE_HIDDEN:  visible = false; break;
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
		 * The Law of Life for form items are shown below in the switch statement. Validation settings 
		 * are important to take note of as it will only be set if of specific type. The activation or 
		 * deactivation of form items are solely the responsibility of the form item and dictated by 
		 * the item's data state value. Thus no activate() or deactivate() is called upon creation but 
		 * rather the state is set from the data object.
		 *
		 * Grouped data here refers to a form item which requires multiple IFormItemData objects in order
		 * to function correctly. A prime example of this is a slider component which has different data 
		 * intervals.  
		 */
		private function createItems():void
		{
			if ( !_data.items ) return;
			
			var groupIterator:IIterator;
			var itemData:IFormItemData;
			var formItem:IFormItem;
			
			var groupedIndex:int = -1;
			var groupedData:Collection = new Collection();

			groupIterator = _data.items.iterator();
			while ( groupIterator.hasNext())
			{
				itemData = IFormItemData( groupIterator.next() );

				switch ( itemData.type )
				{
					case FormItem.ITEM_GROUP:
					case FormItem.ITEM_SLIDER: 	groupedData.addElement( itemData );
												groupedIndex = groupIterator.index() - 1;
												break;
												
					case FormItem.ITEM_CALL_TO_ACTION:												
					case FormItem.ITEM_TYPE_STATIC_TEXT: formItem.valid = true; 
														 break;
					
																
					default: 	buildFormItem( formItem, itemData.type, itemData );
								break;								
				}
			}
			groupIterator.purge();
			groupIterator = null;

			if ( groupedData.length > 0 )
			{
				formItem = buildFormItem( formItem, itemData.type, itemData, groupedIndex );
				formItem.setDataCollection( groupedData );
			}
			groupedData.purge();
			groupedData = null;
		}
		
		private function buildFormItem( formItem:IFormItem, type:String, itemData:IFormItemData, index:int = -1 ):IFormItem
		{
			formItem = getFormItem( type );
			formItem.data = itemData;
			formItem.debug = false;
			formItem.styleManager = styleManager;
			formItem.build();
			formItem.setStyle();
			formItem.arrange();		
			itemData.state = ( itemData.state == null ) ? UIElementState.STATE_VISUAL_UP : itemData.state;
			formItem.state = itemData.state;
			if ( _data.ignoreList && _data.ignoreList.find( "id", formItem.id ))
			{
				formItem.valid = true;
				formItem.data.valid = true;
			}
			else
			{						
				if ( index > numChildren ) index = numChildren - 1;
				index != -1 ? addChildAt( formItem as UIElement, index ) : addChild( formItem as UIElement );
			}			
			return formItem;
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
