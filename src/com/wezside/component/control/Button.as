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
package com.wezside.component.control 
{
	import com.wezside.component.UIElement;
	import com.wezside.component.decorators.layout.Layout;
	import com.wezside.component.decorators.layout.PaddedLayout;
	import com.wezside.component.decorators.layout.RelativeLayout;
	import com.wezside.component.text.Label;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class Button extends Label 
	{

		private var _id:String;
		private var _icon:UIElement;
		private var _autoSkinSize:Boolean;
		private var _iconPlacement:String = Layout.PLACEMENT_CENTER;

		public function Button()
		{
			super( );			
			layout = new PaddedLayout( this );			
			_autoSkinSize = true;
			_icon = new Icon();
			_icon.layout = new PaddedLayout( _icon );
			addChild( _icon );
		}

		override public function build():void 
		{
			super.build( );
			_icon.build();
			_icon.setStyle();			
		}

		override public function arrange():void 
		{							
			// Apply icon layout decorators
			_icon.arrange();
			
			// Set the 9-grid placement to use
			layout = new RelativeLayout( this.layout );
			layout.placement = _iconPlacement;
			RelativeLayout( layout ).anchor = field;
			RelativeLayout( layout ).target = _icon;
						
			// Arrange the Label component to adjust the text field width and height based on the text
			super.arrange();	
			
			if ( _autoSkinSize )
			{
				skin.setSize( layout.width > 0 ? layout.width : width, layout.height > 0 ? layout.height : height );
			}
		}
		
		override public function set state( value:String ):void 
		{
			super.state = value;
			_icon.state = value;
		}
		
		override public function set debug(value:Boolean):void 
		{
			super.debug = value;
			_icon.debug = value;
		}

		public function get icon():UIElement
		{
			return _icon;
		}
		
		public function set icon( value:UIElement ):void
		{
			_icon = value;
		}
		
		public function get iconStyleName():String
		{
			return _icon.styleName;
		}
		
		public function set iconStyleName( value:String ):void
		{
			_icon.styleName = value;
			_icon.styleManager = styleManager;
		}
		
		public function set iconPlacement( value:String ):void
		{
			_iconPlacement = value;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id( value:String ):void
		{
			_id = value;
		}
		
		public function get autoSkinSize():Boolean
		{
			return _autoSkinSize;
		}
		
		public function set autoSkinSize( value:Boolean ):void
		{
			_autoSkinSize = value;
		}
	}
}

