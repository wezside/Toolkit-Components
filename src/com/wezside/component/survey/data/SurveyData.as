package com.wezside.component.survey.data
{
	import com.wezside.data.IDeserializable;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.logging.Tracer;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class SurveyData implements ISurveyData, IDeserializable
	{
		
		private var _layout:ICollection;
		private var _progress:ICollection;
		private var _component:ICollection;
		private var _customCSS:ICollection;
		private var _customForm:ICollection;
		private var _ignoreList:ICollection;
		private var _responseGroupings:ICollection;
		private var _formData:ICollection = new Collection();

		
		public function getFormData( id:String ):IFormData
		{
			return _formData.find( "id", id ) as IFormData;
		}

		public function removeFormData( id:String ):void
		{
			_formData.removeElement( "id", id );
		}

		public function getFormGroupData( id:String ):IFormGroupData
		{
			var formIterator:IIterator = _formData.iterator();
			while ( formIterator.hasNext() )
			{
				var formData:IFormData = formIterator.next() as IFormData;
				var groupIterator:IIterator = formData.iterator;
				while ( groupIterator.hasNext() )
				{
					var groupData:IFormGroupData = groupIterator.next() as IFormGroupData;
					if ( groupData.id == id )
					{
						groupIterator.purge();
						formIterator.purge();
						return groupData;
					}
				}
				groupIterator.purge();
			}
			formIterator.purge();
			return null;
		}

		public function purgeData():void
		{
			if ( _component ) _component.purge();
			if ( _customCSS ) _customCSS.purge();
			if ( _customForm ) _customForm.purge();
			if ( _layout ) _layout.purge();
			if ( _progress ) _progress.purge();
			if ( _formData ) _formData.purge();
			if ( _ignoreList ) _ignoreList.purge();

			_component = null;
			_customCSS = null;
			_customForm = null;
			_layout = null;
			_progress = null;
			_formData = null;
			_ignoreList = null;
		}

		public function addFormData( formData:IFormData ):void
		{
			_formData.addElement( formData );
		}

		public function get iterator():IIterator
		{
			return _formData.iterator();
		}

		public function debug():void
		{
			Tracer.output( true, " --------------------- SURVEY DATA ----------------------", getQualifiedClassName( this ) );
			var iterator:IIterator = _formData.iterator();
			while ( iterator.hasNext())
			{
				var formData:IFormData = iterator.next() as IFormData;
				formData.debug();
			}
			iterator.purge();
			trace( "\r" );
			Tracer.output( true, " --------------------- END ----------------------", getQualifiedClassName( this ) );
		}

		public function get component():ICollection
		{
			return _component;
		}

		public function set component( value:ICollection ):void
		{
			_component = value;
		}

		public function get customCSS():ICollection
		{
			return _customCSS;
		}

		public function set customCSS( value:ICollection ):void
		{
			_customCSS = value;
		}

		public function get customForm():ICollection
		{
			return _customForm;
		}

		public function set customForm( value:ICollection ):void
		{
			_customForm = value;
		}

		public function get layout():ICollection
		{
			return _layout;
		}

		public function set layout( value:ICollection ):void
		{
			_layout = value;
		}

		public function get progress():ICollection
		{
			return _progress;
		}

		public function set progress( value:ICollection ):void
		{
			_progress = value;
		}

		public function get ignoreList():ICollection
		{
			return _ignoreList;
		}

		public function set ignoreList( value:ICollection ):void
		{
			_ignoreList = value;
		}

		public function reset():void
		{
			var it:IIterator = _formData.iterator();
			var formData:IFormData;
			while ( it.hasNext() )
			{
				formData = it.next() as IFormData;
				formData.valid = false;
				var itFormGroup:IIterator = formData.iterator;
				var formGroupData:IFormGroupData;
				while ( itFormGroup.hasNext() )
				{
					formGroupData = itFormGroup.next() as IFormGroupData;
					formGroupData.valid = false;
					var formItemIt:IIterator = formGroupData.items.iterator();
					var formItemData:IFormItemData;
					while ( formItemIt.hasNext() )
					{
						formItemData = formItemIt.next() as IFormItemData;
						formItemData.valid = false;
						formItemData.value = "";
						// Default Value
					}
					formItemIt.purge();
					formItemIt = null;
					formItemData = null;
				}
				itFormGroup.purge();
				itFormGroup = null;
				formGroupData = null;
			}
			it.purge();
			it = null;
			formData = null;
		}

		public function get responseGroupings():ICollection
		{
			return _responseGroupings;
		}

		public function set responseGroupings( value:ICollection ):void
		{
			_responseGroupings = value;
		}

		public function get formData():ICollection
		{
			return _formData;
		}

		public function set formData( value:ICollection ):void
		{
			_formData = value;
		}
	}
}