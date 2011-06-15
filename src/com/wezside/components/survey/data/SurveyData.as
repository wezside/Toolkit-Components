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
		private var _component:ICollection;
		private var _customCSS:ICollection;
		private var _customForm:ICollection;
		private var _layout:ICollection;
		private var _metaData:ICollection;
		private var _progress:ICollection;
		private var _forms:Collection = new Collection();
		private var _ignoreList:ICollection;
		private var _responseGroupings:ICollection;

		public function getFormData( id:String ):IFormData
		{
			return _forms.find( "id", id ) as IFormData;
		}

		public function removeFormData( id:String ):void
		{
			_forms.removeElement( "id", id );
		}

		public function getFormGroupData( id:String ):IFormGroupData
		{
			var formIterator:IIterator = _forms.iterator();
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
			if ( _metaData ) _metaData.purge();
			if ( _progress ) _progress.purge();
			if ( _forms ) _forms.purge();
			if ( _ignoreList ) _ignoreList.purge();

			_component = null;
			_customCSS = null;
			_customForm = null;
			_layout = null;
			_metaData = null;
			_progress = null;
			_forms = null;
			_ignoreList = null;
		}

		public function addFormData( formData:IFormData ):void
		{
			_forms.addElement( formData );
		}

		public function get iterator():IIterator
		{
			return _forms.iterator();
		}

		public function debug():void
		{
			Tracer.output( true, " --------------------- SURVEY DATA ----------------------", getQualifiedClassName( this ) );
			var iterator:IIterator = _forms.iterator();
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

		public function get metaData():ICollection
		{
			return _metaData;
		}

		public function set metaData( value:ICollection ):void
		{
			_metaData = value;
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

		// Need to account for default values
		public function reset():void
		{
			var it:IIterator = _forms.iterator();
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
					var formItemIt:IIterator = formGroupData.iterator;
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
	}
}