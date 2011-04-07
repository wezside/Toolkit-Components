package test
{
	import test.com.wezside.components.control.TestButton;
	import test.com.wezside.components.gallery.TestGallery;
	/**
	 * Project type: Flex 4
	 *  -target-player={playerVersion}
		-library-path+="{flexSDK}/frameworks/locale/en_US"
		-default-size=1000,600
		-static-link-runtime-shared-libraries
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite
	{
		public var testButton:TestButton;
		public var testGallery:TestGallery;		
	}
}