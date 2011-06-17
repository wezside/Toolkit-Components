package test.com.wezside.component.survey.form.item
{
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.prepare;

	import com.wezside.component.survey.data.FormData;
	import com.wezside.component.survey.data.FormGroupData;
	import com.wezside.component.survey.data.FormItemData;
	import com.wezside.component.survey.data.IFormGroupData;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.SurveyData;
	import com.wezside.component.survey.data.config.CSSData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.component.survey.data.config.LayoutData;
	import com.wezside.component.survey.data.config.LayoutDecoratorData;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.data.mapping.XMLDataMapper;

	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.object.nullValue;

	import flash.events.Event;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class TestFormItem
	{
		
		[Embed( source="/../resource/xml/survey.xml", mimeType="application/octet-stream")]
		public static var XMLData:Class;
		
		private var data:SurveyData;
		private var str:*;
		private var xmlData:*;
		private var mapper:XMLDataMapper;
		private var xml:XML;
		
		
		[Before(async, timeout=5000)]
		public function setUp():void
		{
			Async.proceedOnEvent( this, prepare( IFormItem, IFormItemData, IFormGroupData ), Event.COMPLETE );		
			 
			mapper = new XMLDataMapper();
			xmlData = new XMLData();
			str = xmlData.readUTFBytes( xmlData.length );
			xml = new XML( str );			 
			
			mapper.id = "survey.xml";
			mapper.addDataMap( SurveyData );		
			mapper.addDataMap( FormData, "form", "formData" );
			mapper.addDataMap( FormGroupData, "response", "groupsData" );
			mapper.addDataMap( FormItemData, "item", "items" );
			mapper.addDataMap( CSSData, "customCSS", "customCSS" );
			mapper.addDataMap( CSSDataItem, "css", "css" );
			mapper.addDataMap( LayoutData, "layout", "layout" );
			mapper.addDataMap( LayoutDecoratorData, "decorator", "decorators" );
		}
		
		[After]
		public function tearDown():void
		{
			xml = null;
			mapper.purge();
			mapper = null;
		}
		
		[Test]
		public function testIFormItem():void
		{
			mapper.deserialize( xml );			
			data = mapper.data as SurveyData;

			var itemData:IFormItemData = data.getFormData( "EntryForm-1" ).getFormGroupData( "workoutType" ).getItemData( "run" );
			
			// Set up SUT
			var item:IFormItem = nice( IFormItem );
			
			// Expectations
			mock( item ).setter( "data" ).arg( itemData );
			
			item.data = itemData;
			assertThat( item.data, nullValue() );						
		}
	}
}
