package com.wezside.components.survey.form
{
	import com.wezside.components.decorators.shape.ShapeRectangle;
	import com.wezside.data.collection.ICollection;
	import com.wezside.components.UIElement;
	import com.wezside.components.decorators.layout.FillLayout;
	import com.wezside.components.decorators.layout.HorizontalLayout;
	import com.wezside.components.decorators.layout.ILayout;
	import com.wezside.components.decorators.layout.VerticalLayout;
	import com.wezside.components.survey.data.IFormData;
	import com.wezside.components.survey.data.IFormGroupData;
	import com.wezside.components.survey.data.config.CSSDataItem;
	import com.wezside.components.survey.data.config.LayoutDecoratorData;
	import com.wezside.components.text.Label;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.iterator.IIterator;

	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class Form extends UIElement implements IForm
	{
		public var heading:Label;
		public var subheading:Label;
		public var body:Label;
		
		private var _data:IFormData;
		private var _questions:FormQuestions;
		private var _groupCollection:ICollection;
		

		public function Form()
		{
			super();
			alpha = 0;
			visible = false;
			groupCollection = new Collection();
		}

		override public function build():void
		{
			if ( !styleManager ) styleManager = _data.styleManager;
			styleName = getStyleName( _data.id );

			// Create Form Elements
			if ( _data.heading )
				heading = createFormElement( _data.heading, "heading" );
			if ( _data.subheading )
				subheading = createFormElement( _data.subheading, "subheading" );

			if ( _data.body )
				body = createFormElement( _data.body, "body" );

			// Create Group UI elements
			createGroups();

			super.build();
		}

		override public function arrange():void
		{
			if ( heading ) heading.arrange();
			if ( subheading ) subheading.arrange();
			if ( body ) body.arrange();
			if ( questions ) questions.arrange();

			super.arrange();
		}

		override public function purge():void
		{
			if ( heading ) heading.purge();
			if ( subheading ) subheading.purge();
			if ( body ) body.purge();
			if ( _questions ) _questions.purge();

			super.purge();

			_data = null;
			_questions = null;
			heading = null;
			subheading = null;
			body = null;
		}

		public function getFormGroupByID( id:String ):IFormGroup
		{
			var iterator:IIterator = _questions.iterator( UIElement.ITERATOR_CHILDREN );
			while ( iterator.hasNext())
			{
				var item:* = iterator.next();
//				trace(IFormGroup( item ).data.id,id);
				if ( item is IFormGroup && IFormGroup( item ).data.id == id )
					return item as IFormGroup;
			}
			iterator.purge();
			return null;
		}

		public function show( direction:int = 0 ):void
		{
			alpha = 1;
			visible = true;
			dispatchEvent( new FormEvent( FormEvent.SHOW_FORM ) );
			showComplete();
		}

		public function hide( direction:int = 0 ):void
		{
			alpha = 0;
			visible = false;
			hideComplete();
		}

		public function resize():void
		{
			if ( questions )
			{
				_questions.formPadding = [ layout.top, layout.right, layout.bottom, layout.left ];
				_questions.resize();
			}

			// TODO look at this logic again, would these Labels always be the Questions width?
			if ( heading )
				heading.width = questions.width;
			if ( subheading )
				subheading.width = questions.width;
			if ( body )
				body.width = questions.width;
		}

		public function get data():IFormData
		{
			return _data;
		}

		public function set data( value:IFormData ):void
		{
			_data = value;
		}

		public function get questions():FormQuestions
		{
			return _questions;
		}

		public function set questions( value:FormQuestions ):void
		{
			_questions = value;
		}

		public function getUIItem( id:String ):IFormItem
		{
			var it:IIterator = _questions.iterator( UIElement.ITERATOR_CHILDREN );
			while ( it.hasNext() )
			{
				var groupUI:FormGroup = it.next() as FormGroup;
				var groupUIterator:IIterator = groupUI.iterator( UIElement.ITERATOR_CHILDREN );
				while ( groupUIterator.hasNext() )
				{
					var item:IFormItem = groupUIterator.next() as IFormItem;
					if ( item.id == id )
					{
						groupUIterator.purge();
						groupUIterator = null;

						it.purge();
						it = null;

						return item;
					}
				}
				groupUIterator.purge();
				groupUIterator = null;
			}
			it.purge();
			it = null;
			return null;
		}

		protected function createFormElement( text:String, styleName:String ):Label
		{
			var sn:String = getStyleName( styleName );
			var element:Label = new Label();
			element.autoSize = TextFieldAutoSize.LEFT;
			element.styleName = sn != "" ? sn : styleName;
			element.styleManager = styleManager;
			element.text = text;
			element.width = stage ? stage.stageWidth : 100;
			element.build();
			element.setStyle();
			element.arrange();
			addChild( element );
			return element;
		}

		protected function getStyleName( id:String ):String
		{
			var cssID:String;
			if ( _data && _data.styleNameCollection )
			{
				var cssDataItem:CSSDataItem = data.styleNameCollection.find( "id", id ) as CSSDataItem;
				cssID = cssDataItem ? cssDataItem.cssID : "";
			}
			return cssID ? cssID : "";
		}

		protected function getLayoutDecorator( formGroup:IFormGroup ):ILayout
		{
			if ( formGroup.data && formGroup.data.layoutDecorators )
			{
				var it:IIterator = formGroup.data.layoutDecorators.iterator();
				while ( it.hasNext() )
				{
					var decoratorData:LayoutDecoratorData = it.next() as LayoutDecoratorData;
					var clazz:Class = getDefinitionByName( "com.wezside.components.decorators.layout::" + decoratorData.id ) as Class;

					formGroup.layout = new clazz( formGroup.layout ) as ILayout;
					formGroup.layout.bottom = decoratorData.bottom;
					formGroup.layout.left = decoratorData.left;
					formGroup.layout.right = decoratorData.right;
					formGroup.layout.top = decoratorData.top;
					formGroup.layout.horizontalGap = decoratorData.horizontalGap;
					formGroup.layout.verticalGap = decoratorData.verticalGap;
					formGroup.layout.width = decoratorData.width;
					formGroup.layout.height = decoratorData.height;

					if ( formGroup.layout is FillLayout )
					{
						FillLayout( formGroup.layout ).horizontalFill = decoratorData.horizontalFill;
						FillLayout( formGroup.layout ).verticalFill = decoratorData.verticalFill;
						FillLayout( formGroup.layout ).widthRatio = decoratorData.widthRatio;
						FillLayout( formGroup.layout ).heightRatio = decoratorData.heightRatio;
						FillLayout( formGroup.layout ).baseWidth = decoratorData.baseWidth;
						FillLayout( formGroup.layout ).baseHeight = decoratorData.baseHeight;
					}
				}
				it.purge();
				it = null;
				return formGroup.layout;
			}
			return new HorizontalLayout( formGroup );
		}

		protected function createGroups():void
		{
			// Setup question UI container
			if ( !_questions )
				_questions = new FormQuestions();
			addChild( _questions );

			_questions.layout = new VerticalLayout( _questions.layout );
			_questions.styleManager = styleManager;
			_questions.styleName = getStyleName( data.id + "_questions" );

			// Loop through all the groupData objects and create new FormGroup container
			var groupIterator:IIterator = _data.iterator;
			while ( groupIterator.hasNext() )
			{
				var groupData:IFormGroupData = groupIterator.next() as IFormGroupData;
				var formGroup:FormGroup = new FormGroup();
//				formGroup.background = new ShapeRectangle( formGroup );
//				formGroup.background.alphas = [ 0.4, 0.4 ];
//				formGroup.background.colours = [ 0, 0 ];
//				formGroup.background.borderColor = 0xffffff;
//				formGroup.background.borderThickness = 1;
				
				formGroup.parentForm = this;
				formGroup.debug = debug;
				formGroup.data = groupData;
				formGroup.layout = getLayoutDecorator( formGroup );
				formGroup.styleManager = styleManager;
				formGroup.build();
				formGroup.setStyle();
				formGroup.arrange();

				if ( data.ignoreList && data.ignoreList.find( "id", groupData.id ))
				{
					formGroup.data.valid = true;
				}
				else
					_questions.addChild( formGroup as UIElement );
			}
			_questions.build();
			_questions.setStyle();
			_questions.arrange();
			groupIterator.purge();
		}

		protected function showComplete( event:Event = null ):void
		{
			alpha = 1;
			visible = true;
			dispatchEvent( new FormEvent( FormEvent.SHOW_FORM_COMPLETE ));
		}

		protected function hideComplete( event:Event = null ):void
		{
			alpha = 0;
			visible = false;
			dispatchEvent( new FormEvent( FormEvent.HIDE_FORM_COMPLETE ));
		}

		public function showGroups( item:IFormItem ):void
		{
		}
		
		public function hideGroups( item:IFormItem ):void
		{	
		}

		public function get groupCollection():ICollection
		{
			return _groupCollection;
		}

		public function set groupCollection( value:ICollection ):void
		{
			_groupCollection = value;
		}
	}
}