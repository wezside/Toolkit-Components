package sample.survey.command {
	import com.wezside.components.survey.SurveyDataParser;
	import com.wezside.components.survey.SurveyEvent;
	import com.wezside.components.survey.data.IFormItemData;
	import com.wezside.components.survey.data.ISurveyData;
	import com.wezside.components.survey.form.FormItem;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.command.Command;
	import com.wezside.utilities.command.CommandEvent;

	import flash.events.Event;

	/**
	 * @author Sean Lailvaux
	 */
	public class CustomDataCommand extends Command {
		
		private var parser 		: SurveyDataParser;
		private var surveyData 	: ISurveyData;
		
		
		override public function execute( event : Event ) : void {
			
			super.execute( event );
			
			parser = SurveyEvent( event ).data.parser;
			surveyData = parser.data;
			
			// tell the Survey Engine that the last Question 3 is a slider
			var it : IIterator;
			var item : IFormItemData;
			it = surveyData.getFormData( "Question3" ).getFormGroupData( "Question3" ).iterator;
			while ( it.hasNext() ) {
				item = it.next() as IFormItemData;
				if ( item.type != FormItem.ITEM_TYPE_STATIC_TEXT ) {
					item.type = FormItem.ITEM_SLIDER;
				}
			}
			it.purge();
			it = null;
			item = null;
			
			// populate the InfoCapture form data
			surveyData.getFormData( "InfoCapture" ).getFormGroupData( "InfoCapture" ).getItemData( "FirstName" ).value = parser.getContent( "FirstName", "ResponseValue", "Responses" );
			surveyData.getFormData( "InfoCapture" ).getFormGroupData( "InfoCapture" ).getItemData( "LastName" ).value = parser.getContent( "LastName", "ResponseValue", "Responses" );
			surveyData.getFormData( "InfoCapture" ).getFormGroupData( "InfoCapture" ).getItemData( "Email" ).value = parser.getContent( "Email", "ResponseValue", "Responses" );
			
			dispatchEvent( new CommandEvent( CommandEvent.COMPLETE, false, false, "" ) );
		}
	}
}