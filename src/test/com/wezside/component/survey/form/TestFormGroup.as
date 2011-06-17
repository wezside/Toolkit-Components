package test.com.wezside.component.survey.form
{
	import com.wezside.data.collection.Collection;
	import mockolate.mock;
	import mockolate.prepare;
	import mockolate.strict;
	import mockolate.verify;

	import com.wezside.component.UIElement;
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
	import com.wezside.component.survey.form.FormGroup;
	import com.wezside.component.survey.form.IFormGroup;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.component.survey.form.item.FormButton;
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.mapping.XMLDataMapper;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;

	import flash.events.Event;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class TestFormGroup
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
			Async.proceedOnEvent( this, prepare( IFormItem, IFormItemData, IFormGroupData, ICollection ), Event.COMPLETE );		
			 
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
				
		/**
		 * State verification test.
		 */ 
		[Test]
		public function testIFormGroup():void
		{
			mapper.deserialize( xml );			
			data = mapper.data as SurveyData;
			
			// Set up Collaborators
			FormButton;
			var formGroupData:IFormGroupData = new FormGroupData();
			formGroupData.items = data.getFormData( "EntryForm-1" ).getFormGroupData( "workoutType" ).items;
	
			// Set up SUT
			var group:IFormGroup = new FormGroup();
			group.data = formGroupData;
			group.build();
			group.setStyle();
			group.arrange();
			
			assertEquals( 4, group.iterator( UIElement.ITERATOR_CHILDREN ).length() );
		}
				
		/**
		 * Behaviour verification test.
		 */ 
		[Test]
		public function testIFormGroupBehaviour():void
		{
			mapper.deserialize( xml );			
			data = mapper.data as SurveyData;
			
			// Set up Collaborators
			FormButton;
			
			var items:ICollection = data.getFormData( "EntryForm-1" ).getFormGroupData( "workoutType" ).items.clone();
			var formGroupData:IFormGroupData = strict( IFormGroupData );
			
			// Expectations			
			mock( formGroupData ).getter( "formItemNS" ).returns( new Namespace( "formItem", "com.wezside.component.survey.form.item" ));
			mock( formGroupData ).getter( "ignoreList" ).returns( new Collection());
			mock( formGroupData ).setter( "items" ).arg( items );
			mock( formGroupData ).getter( "items" ).returns( items );
			mock( formGroupData ).getter( "styleNameCollection" );
			mock( formGroupData ).getter( "styleManager" );
			mock( formGroupData ).getter( "id" );
			
			formGroupData.items = items;
	
			// Set up SUT
			var group:IFormGroup = new FormGroup();
			group.data = formGroupData;
			group.build();
			group.setStyle();
			group.arrange();
			
			// Verify behaviour of Collaborator
			verify( formGroupData );
			
			// Assert
			assertEquals( 4, group.iterator( UIElement.ITERATOR_CHILDREN ).length() );			
		}
	}
}
