/**
 * Copyright (c) 2011 Wesley Swanepoel
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.wezside.components.text 
{
	import flash.text.TextFieldType;
	import flash.events.Event;
	import flash.events.FocusEvent;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class InputField extends Label
	{
		private var _defaultText:String = "";

		public function InputField()
		{
			super( );
			field.type = TextFieldType.INPUT;
		}
	
		override public function activate():void 
		{
			field.addEventListener( Event.CHANGE, changeHandler );			
			field.addEventListener( FocusEvent.FOCUS_IN, focusIn );
			field.addEventListener( FocusEvent.FOCUS_OUT, focusOut );			
		}

		override public function deactivate():void 
		{
			field.removeEventListener( Event.CHANGE, changeHandler );			
			field.removeEventListener( FocusEvent.FOCUS_IN, focusIn );			
			field.removeEventListener( FocusEvent.FOCUS_OUT, focusOut );
		}
				
		override public function purge() : void {
			
			if ( field ) deactivate();
			super.purge();			
			field = null;
		}		
		
		public function setFocus():void
		{
			if ( field && field.stage )
			{
				field.setSelection( 0, field.length );	
				if ( field.text == " " ) field.text = "";
				field.stage.focus = field;	
			}
		}		
			
		override public function get text():String
		{
			return field.text;
		}
		
		public function get defaultText():String
		{
			return _defaultText;
		}
		
		public function set defaultText( value:String ):void
		{
			_defaultText = value;
		}
		
		public function get editable():Boolean
		{
			return field.type == TextFieldType.INPUT;
		}
		
		public function set editable( value:Boolean ):void
		{
			field.type =  value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		}

		protected function changeHandler( event:Event = null ):void 
		{
		}

		protected function focusIn( event:Event = null ):void 
		{
			if ( field.text == _defaultText ) field.text = " ";
			setFocus();			
		}	
		
		protected function focusOut(event:FocusEvent):void 
		{
			if ( field.text == "" || field.text == " " ) field.text = _defaultText;
		}		
	}
}
