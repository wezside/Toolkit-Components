package com.wezside.components.survey
{
	import com.wezside.components.UIElementState;
	import com.wezside.components.survey.data.FormData;
	import com.wezside.components.survey.data.FormGroupData;
	import com.wezside.components.survey.data.FormItemData;
	import com.wezside.components.survey.data.FormMetaData;
	import com.wezside.components.survey.data.IFormData;
	import com.wezside.components.survey.data.IFormGroupData;
	import com.wezside.components.survey.data.IFormItemData;
	import com.wezside.components.survey.data.ISurveyData;
	import com.wezside.components.survey.data.SurveyData;
	import com.wezside.components.survey.form.FormItem;

	import flash.events.EventDispatcher;

	/**
	 * @author dave.smith from Wesley.Swanepoel
	 * 
	 * Note:
	 * All forms groups and items are default isValid=true set in this class when building the dataset
	 * Except for items with a "submitable value" where isValid=false
	 */
	public class SurveyDataParser extends EventDispatcher
	{
		private var _locale:String;
		private var _dataprovider:XML;
		private var _data:ISurveyData;

		public function start():void
		{
			// Build survey data
			_data = new SurveyData();
			buildFormData( _data );
			dispatchEvent( new SurveyEvent( SurveyEvent.PARSER_COMPLETE ) );
		}

		/**
		 * Loop through the groups and start building the FormData that will hos the FormItemData.
		 */
		public function buildFormData( data:ISurveyData ):void
		{
			// trace(XML(_dataprovider));
			//			// The whole XML file/stream
			// trace("_dataprovider",XML(_dataprovider));
			var xmlString:String = _dataprovider.Templates.Template[0].text()[0];
			// The XML under the <Template> node
			var xml:XML = new XML( xmlString );
			// Loop through the template nodes children (<Template><forms><form>)
			var i:int;
			var len:int = xml.Form.length();
			for ( i = 0; i < len; ++i )
			{
				var formID:String = String( xml.Form[i].@id );
				var formData:IFormData = new FormData();
				formData.id = formID;
				formData.valid = true;
				setHeaders( xml.Form[i], formData );

				var groupXMLList:XMLList = xml.Form[i].children();
				formData = buildGroupData( groupXMLList, formData );
				data.addFormData( formData );
			}
		}

		private function setHeaders( node:XML, formData:IFormData ):void
		{
			var headingID:String = "";
			var regex:RegExp = /'\w+'/;
			headingID = String( node.@content );
			var result:Array = headingID.match( regex );

			if ( result )
			{
				headingID = result[0].toString().substring( 1, result[0].toString().length - 1 );
			}
			else
			{
				headingID = node.@id;
			}

			formData.heading = _dataprovider.Contents..Article.( @id == headingID ).Resource.( @id == "FormTitle").text();
			formData.subheading = _dataprovider.Contents..Article.( @id == headingID ).Resource.( @id == "FormSubTitle").text();
			formData.body = _dataprovider.Contents..Article.( @id == headingID ).Resource.( @id == "Description").text();

			formData.heading = ( formData.heading && formData.heading.length == 0 ) ? " " : formData.heading;
			formData.subheading = ( formData.subheading && formData.subheading.length == 0 ) ? " " : formData.subheading;
			formData.body = ( formData.body && formData.body.length == 0 ) ? " " : formData.body;
		}

		private function buildGroupData( groupXMLList:XMLList, parentFormData:IFormData ):IFormData
		{
			// Extract the form item IDs from the Template node
			var j:int;
			var len:int = groupXMLList.length();
			for ( j = 0; j < len; ++j )
			{
				// The individual "group" node (<Question> or <CallToAction>)
				var groupXML:XML = groupXMLList[j];
				var groupID:String = groupXML.@id;

				switch ( String( groupXML.name() ))
				{
					case "Question" :
						var questionData:IFormGroupData = new FormGroupData();
						questionData.parent = parentFormData;
						questionData.id = groupID;
						questionData.valid = true;
						questionData.isInteractive = false;
						questionData = getQuestionFormItems( groupID, questionData );
						parentFormData.addFormGroupData( questionData );
						// if the group has "submitable" elements then it is not valid by default
						if ( !questionData.valid ) parentFormData.valid = false;
						break;
					case "CallToAction" :
						var metaGroupData:IFormGroupData = new FormGroupData();
						metaGroupData.parent = parentFormData;
						metaGroupData.id = groupID;
						metaGroupData.valid = true;
						metaGroupData = getMetaFormItems( groupID, metaGroupData );
						metaGroupData.isInteractive = false;
						parentFormData.addFormGroupData( metaGroupData );
						break;
				}
			}

			return parentFormData;
		}

		public function getMetaFormItems( groupID:String, parentGroup:IFormGroupData ):IFormGroupData
		{
			// Handle ITEM DATA
			var item:IFormItemData = new FormItemData();
			item.id = groupID;
			item.label = getContent( groupID, "Title", "Content" );
			item.sublabel = getContent( groupID, "Description", "Content" );
			item.type = FormItem.ITEM_CALL_TO_ACTION;
			item.valid = true;
			item.state = UIElementState.STATE_VISUAL_UP;

			// Add data for display item
			parentGroup.addItemData( item );

			// Handle META DATA --> this data is stored at the level of the Formdata
			// Meta data refers to additional content relating to a form item or question
			var meta:FormMetaData = new FormMetaData();

			meta.id = item.id;
			meta.label = item.label;
			meta.sublabel = item.sublabel;
			meta.data = getContent( item.id, "Description", "Content" ).replace( /\r/gm, "" );

			// Store meta data at the formData level
			parentGroup.parent.addMetaData( meta );
			return parentGroup;
		}

		/**
		 * Create a colleciton of FormItemData from groups specified in buildFormData(). 
		 * Check if the question has any responses otherwise create a static form item.
		 */
		public function getQuestionFormItems( groupID:String, groupData:IFormGroupData ):IFormGroupData
		{
			// these are each indivdual forms.
			// The questions node (<questions><question>) eg: <Question id="MedicationBP"><Responses/><Question/>
			var xml:XMLList = _dataprovider.Questions.Question.( @id == groupID );
			var item:IFormItemData;

			if ( xml..Response.length() == 0 )
			{
				// Create data for static text field
				item = new FormItemData();
				item.id = xml.@id;
				item.groupID = groupID;
				item.state = UIElementState.STATE_VISUAL_UP;
				item.label = getContent( xml.@id, "QuestionLabel" );
				item.sublabel = getContent( xml.@id, "QuestionSubLabel" );
				item.type = FormItem.ITEM_TYPE_STATIC_TEXT;
				item.valid = true;

				groupData.addItemData( item );
			}
			else
			{
				// Create data for "question" static text field
				item = new FormItemData();
				item.id = xml.@id + "_QuestionLabel";
				item.groupID = groupID;
				item.state = UIElementState.STATE_VISUAL_UP;
				item.label = getContent( xml.@id, "QuestionLabel" );
				item.sublabel = getContent( xml.@id, "QuestionSubLabel" );
				item.type = FormItem.ITEM_TYPE_STATIC_TEXT;
				item.valid = true;
				groupData.addItemData( item );

				// Create data for each from item
				var i:int;
				var len:int = xml.length();
				for ( i = 0; i < len; ++i )
				{
					var list:XMLList = xml[i]..Response;

					var k:int;
					var kLen:int = list.length();

					for ( k = 0; k < kLen; ++k )
					{
						var type:String = "";

						var label:String = getContent( list[k].@id, "ResponseLabel", "Responses" );
						var suffix:String = getContent( list[k].@id, "ResponseSuffix", "Responses" );
						var maxLength:String = "-1";
						switch ( String( list[k].@type ) )
						{
							case "OpenEnded" :
								type = FormItem.ITEM_TEXT_INPUT;
								maxLength = list[k].@maxLength ? list[k].@maxLength : maxLength;
								break;
							case "DoNotKnow" :
								type = FormItem.ITEM_DO_NOT_KNOW;
								break;
						}

						item = new FormItemData();
						item.id = list[k].@id;
						item.maxLength = maxLength;
						item.groupID = groupID;
						item.state = UIElementState.STATE_VISUAL_UP;
						item.type = type == "" ? FormItem.ITEM_RADIO_BUTTON : type;
						item.label = label;
						item.suffix = suffix;
						item.valid = false;
						// default valid state of form Item with a submitable value is false
						groupData.addItemData( item );
						groupData.valid = false;
						// The parents of Items with a submitable value must also be isValid=false;
						groupData.isInteractive = true;
					}
				}
			}

			return groupData;
		}

		public function get dataprovider():XML
		{
			return _dataprovider;
		}

		public function set dataprovider( value:XML ):void
		{
			_dataprovider = value;
		}

		public function get data():ISurveyData
		{
			return _data;
		}

		public function get locale():String
		{
			return _locale;
		}

		public function set locale( value:String ):void
		{
			_locale = value;
		}

		public function getContent( articleID:String, resourceID:String, contentArticleID:String = "Questions" ):String
		{
			var xml:XMLList = getArticle( articleID, contentArticleID );

			var i:int;
			var len:int = xml.length();

			for ( i = 0; i < len; ++i )
			{
				var list:XMLList = xml[i].Article;
				var str:String = "";

				if ( list.length() > 1 )
				{
					str = list[0].Resource.( @id == resourceID ).text();
				}
				else
				{
					str = xml[i].(@id == articleID )..Resource.(@id == resourceID ).text();
				}

				// remove any newline carriage returns
				str = str.replace( /\n\r/g, "\n" );
				str = str.replace( /\r\n/g, "\n" );

				if ( str != "")
					return str;
			}
			return "";
		}

		public function getArticle( articleID:String, contentArticleID:String = "Questions" ):XMLList
		{
			return XMLList( _dataprovider.Contents.Content.(@culture == _locale).Article.( @id == contentArticleID )..Article.( @id == articleID ) );
		}

		/**
		 * Article[@id='Common']//Article[@id='Yes']//Resource[@id='ResponseLabel']
		 * Article.(@id=='Common').Article.(@id=='Yes').Resource.(@id=='ResponseLabel')
		 */
		public function translateXPathtoE4X( str:String ):String
		{
			var p1:RegExp = /\[@/g;
			var p2:RegExp = /\='/g;
			var p3:RegExp = /']/g;
			var p4:RegExp = /\//g;
			return str.replace( p1, ".(@" ).replace( p2, "=='" ).replace( p3, "')" ).replace( p4, "." );
		}

		public function debug( debug:Boolean = true ):void
		{
			if ( debug ) _data.debug();
		}
	}
}
