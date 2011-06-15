package com.wezside.component.survey.data 
{
	import com.wezside.component.survey.form.FormItem;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.style.IStyleManager;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormGroupData implements IFormGroupData 
	{
		
		private var _items:Collection = new Collection();
		private var _id:String;
		private var _parent:IFormData;
		private var _valid:Boolean;
		private var _isInteractive:Boolean;
		private var _styleManager:IStyleManager;
		private var _styleNameCollection:ICollection;
		private var _formItemsNS:Namespace = new Namespace( "", "com.wezside.components.survey.form.item" );
		private var _layoutDecorators:ICollection;
		private var _ignoreList:ICollection;

		public function addItemData( item:IFormItemData ):void
		{
			_items.addElement( item );
		}
		
		public function removeItemData( id:String ):IFormItemData
		{
			var arr:Array = _items.removeElement( "id", id );
			return arr.length == 0 ? null : arr[0];
		}
		
		public function getItemData( id:String ):IFormItemData
		{
			return _items.find( "id", id ) as IFormItemData;
		}
		
		public function getItemDataByIndex( index:uint ):IFormItemData
		{
			return _items.getElementAt( index );
		}
		
		public function getItemAnswerData():ICollection
		{
			var answers:ICollection = new Collection();
			var it:IIterator = _items.iterator();
			while ( it.hasNext() )
			{
				var itemData:IFormItemData = it.next() as IFormItemData;
				if ( itemData.valid && itemData.type != FormItem.ITEM_TYPE_STATIC_TEXT
									&& itemData.type != FormItem.ITEM_CALL_TO_ACTION )
				{
					Collection( answers ).addElement( itemData );
				}
			}
			it.purge();
			return answers;
		}
		
		public function hasOnlyMetaData():Boolean 
		{
			var hasOnlyMeta:Boolean = true;
			var it:IIterator = _items.iterator();
			while ( it.hasNext() )
			{
				var itemData:IFormItemData = it.next() as IFormItemData;

				if ( itemData.type != FormItem.ITEM_CALL_TO_ACTION   )
				{
					
					hasOnlyMeta = false;
				}
			}
			it.purge();				
			it = null;		
			return hasOnlyMeta;
		}		
		
		public function reset():void
		{
			var it:IIterator = _items.iterator();
			var item:IFormItemData;
			while ( it.hasNext() )
			{
				item = it.next() as IFormItemData;
				item.reset();
			}
			it.purge();
			it = null;
			item = null;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function get valid():Boolean
		{
			return _valid;
		}
		
		public function get isInteractive():Boolean
		{
			return _isInteractive;
		}
		
		public function set id( value:String ):void
		{
			_id = value;
		}
		
		public function set valid( value:Boolean ):void
		{
			_valid = value;
		}
		
		public function set isInteractive( value:Boolean ):void
		{
			_isInteractive = value;
		}
		
		public function get parent():IFormData
		{
			return _parent;
		}
		
		public function set parent(value:IFormData):void
		{
			_parent = value;
		}
		
		public function debug():void
		{
			Tracer.output( true, "\t\tGROUP : " + _id + " | Styles [" + styleNameCollection + "]" + " | Ignore [" + ignoreList + "]", "" );
			var iterator:IIterator = _items.iterator();
			while ( iterator.hasNext())
			{
				var formData:IFormItemData = iterator.next() as IFormItemData;
				formData.debug();
			}		
			iterator.purge();			
		}
		
		public function purge():void
		{
		}
		
		public function get iterator():IIterator
		{
			return _items.iterator( );
		}
		
		public function get items():Collection
		{
			return _items;
		}
		
		public function set items( value:Collection ):void
		{
			_items = value;
		}
		
		public function get styleManager():IStyleManager
		{
			return _styleManager;
		}
		
		public function get styleNameCollection():ICollection
		{
			return _styleNameCollection;
		}
		
		public function set styleManager( value:IStyleManager ):void
		{
			_styleManager = value;
		}
		
		public function set styleNameCollection( value:ICollection ):void
		{
			_styleNameCollection = value;
		}
		
		public function get formItemNS():Namespace
		{
			return _formItemsNS;
		}
		
		public function set formItemNS( value:Namespace ):void
		{
			_formItemsNS = value;
		}
		
		public function get layoutDecorators():ICollection
		{
			return _layoutDecorators;
		}
		
		public function set layoutDecorators(value:ICollection):void
		{
			_layoutDecorators = value;
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
