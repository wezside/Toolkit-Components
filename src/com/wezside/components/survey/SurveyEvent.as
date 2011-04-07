package com.wezside.components.survey 
{
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class SurveyEvent extends Event 
	{
		// Navigation
		public static const NAVIGATE:String = "NAVIGATE";
		public static const SURVEY_END:String = "SURVEY_END";
		public static const CALL_TO_ACTION:String = "CALL_TO_ACTION";
		public static const SURVEY_RESTART:String = "SURVEY_RESTART";
		
		// Validation
		public static const VALIDATION_COMPLETE:String = "VALIDATION_COMPLETE";		
		
		// Intialization
		public static const LOAD_CONFIG:String = "LOAD_CONFIG";
		public static const LOAD_CONFIG_COMPLETE:String = "CONFIG_LOAD_COMPLETE";
		public static const LOAD_DATA:String = "LOAD_DATA";
		public static const LOAD_STYLE:String = "LOAD_STYLE";
		public static const CUSTOM_DATA:String = "CUSTOM_DATA";
		public static const PARSER_COMPLETE:String = "PARSER_COMPLETE";
		public static const PARSE_IGNORE:String = "PARSE_IGNORE";
		public static const UPDATE_NAVIGATION_STATE:String = "UPDATE_NAVIGATION_STATE";

		public var data:*;

		public function SurveyEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
		
		override public function clone():Event 
		{
			return new SurveyEvent( type, bubbles, cancelable, data );
		}
	}
}
