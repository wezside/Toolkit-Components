package com.wezside.components.survey.command
{
	import com.wezside.components.survey.SurveyEvent;
	import com.wezside.components.survey.data.IFormData;
	import com.wezside.components.survey.data.IFormGroupData;
	import com.wezside.components.survey.data.IFormItemData;
	import com.wezside.components.survey.data.IFormMetaData;
	import com.wezside.components.survey.data.ISurveyData;
	import com.wezside.components.survey.data.config.IgnoreData;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.command.Command;
	import com.wezside.utilities.command.CommandEvent;

	import flash.events.Event;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class ParseIgnoreCommand extends Command
	{
		private var data:*;
		private var ignoreList:ICollection;
		
		override public function execute( event:Event ):void
		{
			super.execute( event );
			data = SurveyEvent( event ).data;
			ignoreList = data.ignoreData as ICollection;
			
			var ignoreData:IgnoreData;
			var surveyData:ISurveyData = data.parser.data;
			var surveyIterator:IIterator = surveyData.iterator;			
			
			// Loop through Form Data and inject style names and set any layout decorators defined in config
			while ( surveyIterator.hasNext() )
			{
				var formData:IFormData = surveyIterator.next() as IFormData;
				ignoreData = ignoreList.find( "id", formData.id ) as IgnoreData;
				formData.ignoreList = ignoreData? ignoreData.ignoreItems : null;
				
				// Loop through Group Data and inject style names
				var formIterator:IIterator = formData.iterator;
				while ( formIterator.hasNext() )
				{
					var groupData:IFormGroupData = formIterator.next() as IFormGroupData;
					ignoreData = ignoreList.find( "id", groupData.id ) as IgnoreData;
					groupData.ignoreList = ignoreData? ignoreData.ignoreItems : null;
					
					// Loop through Form Items and inject style names
					var formItemData:IFormItemData;
					var groupIterator:IIterator = groupData.iterator;					
					while ( groupIterator.hasNext() )
					{						
						formItemData = groupIterator.next() as IFormItemData;
						ignoreData = ignoreList.find( "id", formItemData.id ) as IgnoreData;
						formItemData.ignoreList = ignoreData? ignoreData.ignoreItems : null;
					}
					groupIterator.purge();
				}
				formIterator.purge();
				
				// Loop through Meta data and inject style names
				var metaData:IFormMetaData;
				var metaIterator:IIterator = formData.metaIterator;
				while ( metaIterator.hasNext() )
				{
					metaData = metaIterator.next() as IFormMetaData;
					ignoreData = ignoreList.find( "id", metaData.id ) as IgnoreData;
					metaData.ignoreList = ignoreData? ignoreData.ignoreItems : null;						
				}
				metaIterator.purge();
				metaIterator = null;
			}			
			surveyIterator.purge();
			surveyIterator = null;						
			
			dispatchEvent( new CommandEvent( CommandEvent.COMPLETE, false, false, "", false ));	
		}
	}
}
