package com.wezside.component.text
{
	import flash.geom.ColorTransform;
	import flash.text.engine.SpaceJustifier;
	import flash.text.engine.TextJustifier;
	import com.wezside.component.UIElement;
	import com.wezside.component.UIElementState;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.iterator.IIterator;

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

		private var format:ElementFormat;
		private var blockCollection:Collection;
		private var yOffset:int = 0;
		
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
		private var _textWidth:int = 100;
		private var _textHeight:int = 100;
						
						
		override public function construct():void
		{
			super.construct();
			blockCollection = new Collection();
			_align = LabelFTEAlign.LEFT;
			
			_fontDescription = new FontDescription();
			format = new ElementFormat( _fontDescription );
			_fontDescription = _fontDescription.clone();
			locale = "en";
		}
				
		override public function build():void
		{
			super.build();
			y = 0;
			if ( styleName && styleManager ) 
				format = styleManager.getElementFormat( styleName );
						
			
			var it:IIterator = blockCollection.iterator();
			var block:TextBlock;
			while ( it.hasNext() )
			{
				block = it.next() as TextBlock;
				
	            var textLine:TextLine = block.createTextLine( null, _textWidth );
				if ( _align == LabelFTEAlign.RIGHT || block.bidiLevel % 2 != 0 )
				{
		  			while ( textLine )
		            {					
		                textLine.x = _textWidth - textLine.width;
		                textLine.y = yOffset;
		                yOffset += ( _lineHeight ? _lineHeight : textLine.height ) + _lineSpacing;
		                addChild( textLine );
		                textLine = block.createTextLine( textLine, width ? width : _textWidth );
		            }				
				}
				else if ( align == LabelFTEAlign.CENTER )
				{				
		  			while ( textLine )
		            {					
		                textLine.x = ( _textWidth - textLine.width ) * 0.5;
		                textLine.y = yOffset;
		                yOffset += ( _lineHeight ? _lineHeight : textLine.height ) + _lineSpacing;
		                addChild( textLine );
		                textLine = block.createTextLine( textLine, width ? width : _textWidth );
		            }				
				}
				else 
				{				
		  			while ( textLine )
		            {					
		                textLine.x = 0;
		                textLine.y = yOffset;
		                yOffset += ( _lineHeight ? _lineHeight : textLine.height ) + _lineSpacing;
		                addChild( textLine );
		                textLine = block.createTextLine( textLine, width ? width : _textWidth );
		            }				
				}				
			}
			it.purge();
			it = null;
			block = null;				
		}
	
			
		override public function purge():void
		{
			super.purge();
			var it:IIterator = blockCollection.iterator();
			var block:TextBlock;
			while ( it.hasNext() )
			{
				block = it.next() as TextBlock;
			}
			it.purge();
			it = null;
			block = null;			
			if ( format ) format = null;
		}
		
		override public function set state( value:String ):void
		{
			super.state = value;
			
			var newColor:uint = 0;
			
			switch ( value )
			{
				case UIElementState.STATE_VISUAL_UP :
					newColor = textColorUp;					
					break;
				case UIElementState.STATE_VISUAL_OVER :
					newColor = textColorOver;
					break;
				case UIElementState.STATE_VISUAL_DOWN :
					newColor = textColorDown;
					break;
				case UIElementState.STATE_VISUAL_SELECTED :
					newColor = textColorSelected;
					break;
				case UIElementState.STATE_VISUAL_INVALID :
					newColor = textColorInvalid;
					break;
				case UIElementState.STATE_VISUAL_DISABLED :
					newColor = textColorDisabled;
					break;
			}
			
			var ct:ColorTransform = new ColorTransform();
			ct.color = newColor;
			
			var it:IIterator = blockCollection.iterator();
			var block:TextBlock;
			while ( it.hasNext() )
			{
				block = it.next() as TextBlock;
				
				var counter:int = 0;
				var textLine:TextLine = block.getTextLineAtCharIndex( 0 );
				while ( textLine )
	            {			
					textLine.transform.colorTransform = ct;
					counter++;					
					try
					{
	                	textLine = block.getTextLineAtCharIndex( counter );
					}
					catch( error:Error ) { textLine = null; }
	            }		
			}
			it.purge();
			it = null;
			block = null;
		}		
		
		public function addText( value:String, bidiLevel:int = 0, format:ElementFormat = null, justifier:TextJustifier = null ):void
		{		
  		    var block:TextBlock = new TextBlock(); 
			block.bidiLevel = bidiLevel;			
			block.textJustifier = justifier ? justifier : new SpaceJustifier( locale );
			
            var textElement:TextElement = new TextElement( value, format ? format : this.format );
			textElement.eventMirror = this;
			 
            block.content = textElement;
			blockCollection.addElement( block );
			this.format = this.format.clone();
		}
		
		public function get textWidth():int
		{
			return _textWidth;
		}
		
		public function set textWidth( value:int ):void
		{
			_textWidth = value;
		} 
		
		public function get textHeight():int
		{
			return _textHeight;
		}
		
		public function set textHeight( value:int ):void
		{
			_textHeight = value;
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
		
		public function get fontWeight():String
		{
			return fontDescription.fontWeight;
		}
		
		public function set fontWeight( value:String ):void
		{
			fontDescription.fontWeight = value;
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
			_fontDescription = value.clone();
		}
		
		public function get fontSize():Number
		{
			return format.fontSize;
		}
		
		public function set fontSize( value:Number ):void
		{
			format.fontSize = value;
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
