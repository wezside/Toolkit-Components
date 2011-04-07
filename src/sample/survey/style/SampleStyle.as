package sample.survey.style {
	import com.wezside.utilities.manager.style.StyleManager;

	import flash.system.ApplicationDomain;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class SampleStyle extends StyleManager {
		
		[Embed( source="/../resource/css/survey-style.css", mimeType="application/octet-stream")]
		public static var CSS : Class;
		
		[Embed( source="/../resource/swf/survey/arial-font.swf", mimeType="application/octet-stream" )]
		public static var ArialFont : Class;
		
		[Embed( source="/../resource/swf/survey/sample-library.swf", mimeType="application/octet-stream" )]
		public static var Library : Class;
		
		
		public function SampleStyle() {
			
			parseCSSByteArray( SampleStyle.CSS );
			
			parseFontLibrary( new ArialFont(), ApplicationDomain.currentDomain );
			parseLibrary( new Library(), ApplicationDomain.currentDomain );
			
			super();
		}
	}
}