package test.com.wezside.component.survey.form.item
{
	import com.wezside.component.survey.form.IFormItem;
	import mockolate.prepare;

	import org.flexunit.async.Async;

	import flash.events.Event;
	/**
	 * @author Wesley.Swanepoel
	 */
	public class TestFormItem
	{
		
		[Before(async, timeout=5000)]
		public function setUp():void
		{
			 Async.proceedOnEvent( this, prepare( IFormItem ), Event.COMPLETE );		
		}
		
		[After]
		public function tearDown():void
		{
		
		}
		
		[Test]
		public function testname():void
		{
		
		}
		
	}
}
