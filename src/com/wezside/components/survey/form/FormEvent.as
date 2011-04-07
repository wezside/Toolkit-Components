package com.wezside.components.survey.form {
	import flash.events.Event;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class FormEvent extends Event {
		
		public static const ITEM_STATE_CHANGE 	: String = "ITEM_STATE_CHANGE";
		public static const TEXT_INPUT 			: String = "TEXT_INPUT";
		public static const FORM_FOCUS_IN 		: String = "FOCUS_IN";
		public static const FORM_FOCUS_OUT 		: String = "FOCUS_OUT";
		public static const HIDE_FORM_COMPLETE 	: String = "HIDE_FORM_COMPLETE";
		public static const HIDE_FORM 			: String = "HIDE_FORM";		public static const SHOW_FORM_COMPLETE 	: String = "SHOW_FORM_COMPLETE";		public static const SHOW_FORM 			: String = "SHOW_FORM";
		public static const RESIZE				: String = "MANUAL_RESIZE";
		public static const NAV_UPDATE			: String = "NAV_UPDATE";
		public static const SHOW_GROUPS_COMPLETE: String = "SHOW_GROUPS_COMPLETE";
		public static const HIDE_GROUPS_COMPLETE: String = "HIDE_GROUPS_COMPLETE";
		public static const BACKGROUND_RESIZED  : String = "BACKGROUND_RESIZED";
		
		private var _data : *;
		
		public function FormEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false, data : * = null ) {
			super( type, bubbles, cancelable );
			_data = data;
		}
		
		override public function clone() : Event {
			return new FormEvent( type, bubbles, cancelable, data );
		}		
		
		public function set data( value : * ) : void {
			_data = value;
		}
		
		public function get data() : * {
			return _data;
		}
	}
}