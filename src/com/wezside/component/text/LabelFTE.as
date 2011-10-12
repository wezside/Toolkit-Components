package com.wezside.component.text
{
	import com.wezside.component.UIElement;

	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class LabelFTE extends UIElement
	{
		private var block:TextBlock;
		private var format:ElementFormat;
		
		private var _lineHeight:Number;
		private var _lineSpacing:Number = 2;
		private var _fontDescription:FontDescription;
		private var _textColorUp:uint;
		private var _textColorOver:uint;
		private var _textColorDown:uint;
		private var _textColorSelected:uint;
		private var _textColorDisabled:uint;
		private var _textColorInvalid:uint;

		private var _border:Boolean;
		private var _borderColor:uint;
		private var _align:String;
						
						
		override public function construct():void
		{
			super.construct();
			_fontDescription = new FontDescription();
			if ( styleName && styleManager ) format = styleManager.getElementFormat( styleName );
			else format = new ElementFormat(  )           
		}
				
		override public function build():void
		{
			super.build();									
			var xPos:int = 50;
			var yPos:int = 200;			
			block.bidiLevel = 1;
			
//			block.textJustifier = new SpaceJustifier( "ar", LineJustification.UNJUSTIFIED );
            var textLine:TextLine = block.createTextLine( null, width ? width : 300 );
  			while ( textLine )
            {
				
                textLine.x = xPos + 300 - textLine.width;
                textLine.y = yPos;
                yPos += ( _lineHeight ? _lineHeight : textLine.height ) + _lineSpacing;
                addChild( textLine );
                textLine = block.createTextLine( textLine, width ? width : 300 );
            }				
			block.releaseLineCreationData();
		}
			
		override public function purge():void
		{
			super.purge();
			if ( block )
			{
				block.releaseLineCreationData();
				block = null;
			}
			if ( format ) format = null;
		}
		
		public function addText( value:String ):void
		{		
  		    block = new TextBlock(); 
			block.bidiLevel = 3;
			
            var textElement:TextElement = new TextElement( value, format ); 
            block.content = textElement; 
		}
		
		public function get font():String
		{
			return fontDescription.fontName;
		}
		
		public function set font( value:String ):void
		{
			fontDescription.fontName = value;		
		}
		
		public function get fontPosture():String
		{
			return fontDescription.fontPosture;
		}
		
		public function set fontPosture( value:String ):void
		{
			fontDescription.fontPosture = value;
		}
		
		public function get fontLookup():String
		{
			return fontDescription.fontLookup;
		}
		
		public function set fontLookup( value:String ):void
		{
			fontDescription.fontLookup = value;
		}
		
		public function get renderingMode():String
		{
			return fontDescription.renderingMode;
		}
		
		public function set renderingMode( value:String ):void
		{
			fontDescription.renderingMode = value;
		}
		
		public function get cffHinting():String
		{
			return fontDescription.cffHinting;
		}
		
		public function set cffHinting( value:String ):void
		{
			fontDescription.cffHinting = value;
		}
		
		public function get fontDescription():FontDescription
		{
			return _fontDescription;
		}
		
		public function set fontDescription( value:FontDescription ):void
		{
			_fontDescription = value;
		}
		
		public function get fontSize():Number
		{
			return format.fontSize;
		}
		
		public function set fontSize( value:Number ):void
		{
			fontSize = value;
		}
		
		public function get textColor():uint
		{
			return format.color;
		}

		public function set textColor(value:uint):void
		{
			format.color = value;
			_textColorUp = value;
		}

		public function get textColorUp():uint
		{
			return _textColorUp;
		}

		public function set textColorUp(value:uint):void
		{
			_textColorUp = value;
			format.color = value;
		}

		public function get textColorOver():uint
		{
			return _textColorOver;
		}

		public function set textColorOver(value:uint):void
		{
			_textColorOver = value;
		}

		public function get textColorDown():uint
		{
			return _textColorDown;
		}

		public function set textColorDown(value:uint):void
		{
			_textColorDown = value;
		}

		public function get textColorSelected():uint
		{
			return _textColorSelected > 0 ? _textColorSelected : _textColorUp;
		}

		public function set textColorSelected(value:uint):void
		{
			_textColorSelected = value;
		}

		public function get textColorDisabled():uint
		{
			return _textColorDisabled;
		}

		public function set textColorDisabled(value:uint):void
		{
			_textColorDisabled = value;
		}

		public function get textColorInvalid():uint
		{
			return _textColorInvalid;
		}

		public function set textColorInvalid(value:uint):void
		{
			_textColorInvalid = value;
		}
		
		public function get textRotation():String
		{
			return format.textRotation;
		}
		
		public function set textRotation( value:String ):void
		{
			format.textRotation = value;
		}
		
		public function get dominantBaseline():String
		{
			return format.dominantBaseline;
		}
		
		public function set dominantBaseline( value:String ):void
		{
			format.dominantBaseline = value;
		}
		
		public function get alignmentBaseline():String
		{
			return format.alignmentBaseline;
		}
		
		public function set alignmentBaseline( value:String ):void
		{
			format.alignmentBaseline = value;
		}
		
		public function get baselineShift():Number
		{
			return format.baselineShift;
		}
		
		public function set baselineShift( value:Number ):void
		{
			format.baselineShift = value;
		}
		
		public function get kerning():String
		{
			return format.kerning;
		}
		
		public function set kerning( value:String ):void
		{
			format.kerning = value;
		}
				
		public function get trackingRight():Number
		{
			return format.trackingRight;
		}
		
		public function set trackingRight( value:Number ):void
		{
			format.trackingRight = value;
		}
				
		public function get trackingLeft():Number
		{
			return format.trackingLeft;
		}
		
		public function set trackingLeft( value:Number ):void
		{
			format.trackingLeft = value;
		}
		
		public function get locale():String
		{
			return format.locale;
		}
		
		public function set locale( value:String ):void
		{
			format.locale = value;
		}		
		
		public function get breakOpportunity():String
		{
			return format.breakOpportunity;
		}
		
		public function set breakOpportunity( value:String ):void
		{
			format.breakOpportunity = value;
		}
		
		public function get digitCase():String
		{
			return format.digitCase;
		}
		
		public function set digitCase( value:String ):void
		{
			format.digitCase = value;
		}
		
		public function get digitWidth():String
		{
			return format.digitWidth;
		}
		
		public function set digitWidth( value:String ):void
		{
			format.digitWidth = value;
		}
		
		public function get ligatureLevel():String
		{
			return format.ligatureLevel;
		}
		
		public function set ligatureLevel( value:String ):void
		{
			format.ligatureLevel = value;
		}
		
		public function get typographicCase():String
		{
			return format.typographicCase;
		}
		
		public function set typographicCase( value:String ):void
		{
			format.typographicCase = value;
		}
		
		public function get letterSpacing():Number
		{
			return format.trackingRight;
		}
		
		public function set letterSpacing( value:Number ):void
		{
			format.trackingRight = value;
		}

		public function get lineHeight():Number
		{
			return _lineHeight;
		}
		
		public function set lineHeight( value:Number ):void
		{
			_lineHeight = value;
		}
		
		public function get lineSpacing():Number
		{
			return _lineSpacing;
		}
		
		public function set lineSpacing( value:Number ):void
		{
			_lineSpacing = value;
		}
		
		public function get border():Boolean
		{
			return _border;
		}

		public function set border( value:Boolean ):void
		{
			_border = value;
		}

		public function get borderColor():uint
		{
			return _borderColor;
		}

		public function set borderColor(value:uint):void
		{
			_borderColor = value;
		}

		public function get align():String
		{
			return _align;
		}

		public function set align( value:String ):void
		{
			_align = value;
		}

	}
}
