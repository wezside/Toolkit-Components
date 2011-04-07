package sample.survey.style {
	import flash.display.Sprite;
	import flash.text.Font;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ArialFont extends Sprite {
		
		[Embed( source="/../resource/font/arial.ttf", 
			fontWeight="normal", 
			fontStyle="regular",
			fontName="Arial", 
			// For Flex 4.1
			/*embedAsCFF="false", */ 
			mimeType="application/x-font-truetype",
			unicodeRange="U+0020-U+007F, U+00A0-U+00FF, U+0100-U+017F, U+0180-U+024F")]
		public static var Arial : Class;
		
		public function ArialFont() {
			Font.registerFont( Arial );
		}
	}
}