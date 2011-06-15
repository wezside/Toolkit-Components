package com.wezside.component.survey.data 
{
	import com.wezside.component.survey.data.config.grouping.ResponseGroupData;
	import com.wezside.data.ItemData;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.logging.Tracer;
	import com.wezside.utilities.manager.style.IStyleManager;

	public class FormData extends Object implements IFormData 
	{
		private var _id:String;
		private var _type:String;
		private var _body:String;
		private var _cta:String;
		private var _heading:String;
		private var _subheading:String;
		private var _valid:Boolean;
		
		private var _metaData:Collection = new Collection();
		private var _groupsData:Collection = new Collection( );
		private var _styleManager:IStyleManager;
		private var _styleNameCollection:ICollection;
		private var _layoutDecorators:ICollection;
		private var _ignoreList:ICollection;
		private var _responseGroupings:ICollection;


		public function addFormGroupData( group:IFormGroupData ):void
		{
			_groupsData.addElement( group );
		}
		public function removeFormGroupData( group:IFormGroupData ):void
		{
			_groupsData.removeElement( "id",group.id );
		}
		public function getFormGroupData( id:String ):IFormGroupData
		{
			return _groupsData.find( "id", id ) as IFormGroupData;
		}

		/**
		 * Return the last group id in the current form. In a paging navigational system, this 
		 * lookup is needed to establish the next form to show. By retrieving the last group 
		 * ID in the current form, it means the next time router.next() is called, the return 
		 * value will be the first group in the next form. This new ID can then be used to lookup
		 * the form ID in order to page to this new form.
		 */
		public function get lastGroupID():String 
		{
			
			var groupData:IFormGroupData = getLastItem( _groupsData.length - 1 );
			return groupData ? groupData.id : null;
			return null;
		}		
		
		private function getLastItem( indx:int ):IFormGroupData
		{
			if (_groupsData.getElementAt( indx ).hasOnlyMetaData() ==false )
			{
				
				return _groupsData.getElementAt( indx );
			}
			else
			{
				if ( indx > 0 )
					getLastItem( --indx );
			}
			
			return _groupsData.getElementAt( indx );
		}

		public function hasResponseGroupings( id:String ):Boolean
		{
			var hasGrouping:Boolean = false;
			var it:IIterator = responseGroupings.iterator();
			var group:ResponseGroupData;
			while ( it.hasNext() )
			{
				group = it.next() as ResponseGroupData;
				var itemsIt:IIterator = group.responses.iterator();
				var item:ItemData;
				while ( itemsIt.hasNext() )
				{
					item = itemsIt.next() as ItemData;
					if ( id == item.id )
					{
						hasGrouping = true;
						break;
					}
				}
				itemsIt.purge();
				itemsIt = null;
				item = null;
				if ( hasGrouping ) break;
			}
			it.purge();
			it = null;
			group = null;
			return hasGrouping;
		}

		public function purge():void
		{
			if ( _metaData ) _metaData.purge();
			if ( _groupsData ) _groupsData.purge();
			if ( _styleNameCollection ) _styleNameCollection.purge();
			if ( _layoutDecorators ) _layoutDecorators.purge();
			if ( _ignoreList ) _ignoreList.purge();
			
			_metaData = null;
			_groupsData = null;
			_styleNameCollection = null;
			_layoutDecorators = null;
			_ignoreList = null;
			
			_styleManager = null;
		}

		public function get id():String
		{
			return _id;
		}

		public function get body():String
		{
			return _body;
		}

		public function get cta():String
		{
			return _cta;
		}

		public function get heading():String
		{
			return _heading;
		}

		public function get subheading():String
		{
			return _subheading;
		}

		public function get valid():Boolean
		{
			return _valid;
		}

		public function get numMeta():uint
		{
			if ( _metaData && _metaData.iterator() ) return _metaData.iterator().length();
			return 0;
		}

		public function set id( value:String ):void
		{
			_id = value;
		}

		public function set body( value:String ):void
		{
			_body = value;
		}

		public function set cta( value:String ):void
		{
			_cta = value;
		}

		public function set heading( value:String ):void
		{
			_heading = value;
		}

		public function set subheading( value:String ):void
		{
			_subheading = value;
		}

		public function set valid( value:Boolean ):void
		{
			_valid = value;
		}
		
		public function debug():void
		{
			trace("\r");
			Tracer.output( true, "\tFORM ID : " + _id + " | Group #" + _groupsData.length + " | Styles [" + styleNameCollection + "]" + " | Ignore [" + ignoreList + "]", "");
			var formData:IFormGroupData;
			var it:IIterator = _groupsData.iterator();
			while ( it.hasNext())
			{
				formData = it.next() as IFormGroupData;
				formData.debug();
			}		
			it.purge();
			it = null;
			formData = null;
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
		
		public function get iterator():IIterator
		{
			return _groupsData.iterator( );
		}
		
		public function get groupsData():Collection
		{
			return _groupsData;
		}
		
		public function set groupsData( value:Collection ):void
		{
			_groupsData = value;
		}
		
		public function get metaIterator():IIterator
		{
			return _metaData.iterator( );
		}
		
		public function get layoutDecorators():ICollection
		{
			return _layoutDecorators;
		}
		
		public function set layoutDecorators( value:ICollection ):void
		{
			_layoutDecorators = value;
		}
		
		public function get type() : String {
			
			return _type;
		}
		
		public function set type(value : String) : void {
			_type = value;
		}

		public function get ignoreList():ICollection
		{
			return _ignoreList;
		}

		public function set ignoreList( value:ICollection ):void
		{
			_ignoreList = value;
		}

		public function get responseGroupings():ICollection
		{
			return _responseGroupings;
		}

		public function set responseGroupings( value:ICollection ):void
		{
			_responseGroupings = value;
		}

		public function reset():void
		{
			var it:IIterator = _groupsData.iterator();
			var groupData:IFormGroupData;
			while ( it.hasNext() )
			{
				groupData = it.next() as IFormGroupData;
				groupData.reset();
			}
			it.purge();
			it = null;
			groupData = null;
		}

		public function getResponseItemIds( groupID:String, id:String ):Number
		{
			return 0;
		}
	}
}
