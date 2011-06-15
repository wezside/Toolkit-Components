package com.wezside.component.survey.form.item
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.wezside.component.UIElement;
	import com.wezside.component.UIElementState;
	import com.wezside.component.survey.data.FormItemData;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.component.survey.data.config.CSSDataItem;
	import com.wezside.component.survey.form.FormEvent;
	import com.wezside.component.survey.form.FormItem;
	import com.wezside.component.survey.form.IFormItem;
	import com.wezside.component.text.Label;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.iterator.IIterator;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Sean Lailvaux
	 */
	public class Slider extends UIElement implements IFormItem
	{
		// Error messages
		private const DATA_ERROR:String = "Data not found on Slider component";
		private const SLIDER_ERROR:String = "Slider asset not found";
		private const HANDLE_ERROR:String = "Slider asset does not contain a Handle";
		private const TRACK_ERROR:String = "Slider asset does not contain a Track";
		private var slider:Sprite;
		private var labels:Sprite;
		private var icons:MovieClip;
		private var handle:Sprite;
		private var track:Sprite;
		private var mouseIsDown:Boolean;
		private var leftLimit:int;
		private var rightLimit:int;
		private var handleOffset:int;
		private var valueID:int;
		private var _sliderData:Collection;
		private var outOfBounds:Boolean;
		private var _data:IFormItemData;

		override public function build():void
		{
			mouseIsDown = false;

			if ( _sliderData == null )
			{
				throw new Error( DATA_ERROR );
			}

			if ( styleManager == null )
			{
				styleManager = IFormItemData( _sliderData.getElementAt( 0 ) ).styleManager;
			}

			slider = Sprite( styleManager.getAssetByName( "Slider" ) );
			if ( slider == null )
			{
				throw new Error( SLIDER_ERROR );
			}

			// optional MovieClip
			icons = MovieClip( slider.getChildByName( "icons" ) );

			leftLimit = 0;
			rightLimit = int( slider.width );

			buildHandle();
			buildTrack();
			buildLabels();

			valueID = 0;
			updateValue( 0, false );

			addChild( slider ) ;

			super.build();

			if ( stage )
			{
				onAddedToStage( null );
			}
			else
			{
				addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			}
		}

		public function superBuild():void
		{
			super.build();
		}

		override public function purge():void
		{
			if ( handle )
			{
				TweenLite.killTweensOf( handle );
				handle.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			}

			if ( track )
			{
				track.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			}

			if ( stage )
			{
				stage.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
				stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			}

			if ( labels )
			{
				labels.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );

				var label:Label;
				while ( labels.numChildren > 0 )
				{
					label = Label( labels.getChildAt( 0 ) );
					label.purge();
					labels.removeChild( label );
				}
				label = null;

				removeChild( labels );
			}

			super.purge();

			slider = null;
			labels = null;
			icons = null;
			handle = null;
			track = null;

			_sliderData = null;
		}

		public function get id():String
		{
			return _data ? _data.id : "";
		}

		public function get type():String
		{
			return FormItem.ITEM_SLIDER;
		}

		public function get value():String
		{
			return data.value;
		}

		public function set value( value:String ):void
		{
			_data.value;
		}

		public function get selected():Boolean
		{
			return true;
		}

		public function set selected( value:Boolean ):void
		{
		}

		public function get data():IFormItemData
		{
			return _sliderData ? IFormItemData( _sliderData.getElementAt( int( valueID - 1 ) ) ) : null;
		}

		public function set data( value:IFormItemData ):void
		{
			_data = value;
		}

		public function get sliderData():Collection
		{
			return _sliderData;
		}

		public function set sliderData( value:Collection ):void
		{
			_sliderData = value;
		}

		public function get valid():Boolean
		{
			return true;
		}

		public function set valid( value:Boolean ):void
		{
		}

		protected function getStyleName( id:String ):String
		{
			var cssID:String;
			if ( data && data.styleNameCollection )
			{
				var cssDataItem:CSSDataItem = data.styleNameCollection.find( "id", id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}

		private function buildHandle():void
		{
			handle = Sprite( slider.getChildByName( "handle" ) );
			if ( handle == null ) throw new Error( HANDLE_ERROR );
			handle.buttonMode = true;
			handle.mouseChildren = false;
			handle.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}

		private function buildTrack():void
		{
			track = Sprite( slider.getChildByName( "track" ) );
			if ( track == null ) throw new Error( TRACK_ERROR );
			track.buttonMode = true;
			track.mouseChildren = false;
			track.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}

		private function buildLabels():void
		{
			labels = new Sprite();
			labels.buttonMode = true;
			labels.mouseChildren = false;
			labels.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );

			// build the labels based on the data
			var i:int;
			var len:int = _sliderData.length;

			var section:int = rightLimit / len;
			for ( i = 0; i < len; ++i )
			{
				var label:Label = new Label();
				label.styleManager = styleManager;
				label.styleName = "Slider";
				label.build();
				label.multiline = true;
				label.wordWrap = true;
				label.setStyle();
				label.text = FormItemData( _sliderData.getElementAt( i ) ).label;
				label.width = section;
				label.height = int( label.textHeight ) + 6;
				label.x = i * section;
				labels.addChild( label );
			}

			labels.y = slider.height;
			addChild( labels );
		}

		private function onAddedToStage( event:Event ):void
		{
			if ( !stage.hasEventListener( MouseEvent.MOUSE_MOVE ) )
			{
				stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			}
		}

		private function onMouseOver( event:MouseEvent ):void
		{
			outOfBounds = false;
			stage.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
		}

		private function onMouseDown( event:MouseEvent ):void
		{
			if ( event.target == handle )
			{
				handleOffset = handle.mouseX;
				if ( stage )
				{
					mouseIsDown = true;
					stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
				}
			}
			else
			{
				updateValue( mouseX, false );
			}
		}

		private function onMouseMove( event:MouseEvent ):void
		{
			var newValueID:int = valueID;

			if ( mouseIsDown )
			{
				handle.x = mouseX - handleOffset;
				if ( handle.x < leftLimit ) handle.x = leftLimit;
				if ( handle.x > rightLimit ) handle.x = rightLimit;
				newValueID = getNewValueID( handle.x );
			}

			if ( newValueID != valueID )
			{
				valueID = newValueID;
				updateUI();
			}
			else
			{
				updateLabelStyles();
			}

			event.updateAfterEvent();
		}

		private function onMouseUp( event:MouseEvent ):void
		{
			if ( stage )
			{
				mouseIsDown = false;
				stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			}
			updateValue( handle.x );
		}

		private function updateValue( position:int, bounce:Boolean = true ):void
		{
			var newValueID:int = getNewValueID( position );
			var section:int = rightLimit / _sliderData.length;
			var xPos:int = int( section * newValueID - section * .5 );

			if ( newValueID != valueID )
			{
				valueID = newValueID;
				updateUI();
			}

			TweenLite.killTweensOf( handle );
			if ( bounce )
			{
				TweenLite.to( handle, .5, { x:xPos, ease:Elastic.easeOut } );
			}
			else
			{
				TweenLite.to( handle, .2, { x:xPos, ease:Circ.easeInOut } );
			}
		}

		private function updateData():void
		{
			var collectionIt:IIterator = sliderData.iterator();
			while ( collectionIt.hasNext() )
			{
				var itemData:IFormItemData = collectionIt.next() as IFormItemData;
				itemData.valid = false;
			}
			collectionIt.purge();
			collectionIt = null;
			data.valid = true;
		}

		private function getNewValueID( currentPosition:int ):int
		{
			var i:int;
			var len:int = _sliderData.length;
			var newValueID:int = len;
			var section:int = rightLimit / len;
			for ( i = 0; i < len; ++i )
			{
				if ( currentPosition < section * (i + 1) )
				{
					newValueID = i + 1;
					break;
				}
			}
			return newValueID;
		}

		private function updateUI():void
		{
			if ( icons ) icons.gotoAndStop( valueID );
			updateLabels();
			updateData();
			dispatchEvent( new FormEvent( FormEvent.ITEM_STATE_CHANGE, true ) );
		}

		private function updateLabels():void
		{
			var i:int;
			var len:int = labels.numChildren;
			for ( i = 0; i < len; ++i )
			{
				Label( labels.getChildAt( i ) ).state = UIElementState.STATE_VISUAL_UP;
			}
			Label( labels.getChildAt( (valueID - 1) ) ).state = UIElementState.STATE_VISUAL_SELECTED;
		}

		private function updateLabelStyles():void
		{
			if ( outOfBounds ) return;

			var i:int;
			var len:int;

			if ( mouseY < 0 || mouseY > height )
			{
				outOfBounds = true;
				// clear all
				len = labels.numChildren;
				for ( i = 0; i < len; ++i )
				{
					if ( i + 1 != valueID )
					{
						Label( labels.getChildAt( i ) ).state = UIElementState.STATE_VISUAL_UP;
					}
				}

				if ( !stage.hasEventListener( MouseEvent.MOUSE_OVER ) )
				{
					stage.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
				}

				return;
			}

			var overValue:int = getNewValueID( mouseX );

			len = labels.numChildren;
			for ( i = 0; i < len; ++i )
			{
				if ( i + 1 != valueID && i + 1 != overValue )
				{
					Label( labels.getChildAt( i ) ).state = UIElementState.STATE_VISUAL_UP;
				}
			}
			if ( overValue != valueID )
			{
				Label( labels.getChildAt( (overValue - 1) ) ).state = UIElementState.STATE_VISUAL_OVER;
			}
		}
	}
}