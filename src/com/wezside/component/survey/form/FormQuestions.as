package com.wezside.component.survey.form
{
	import com.wezside.component.UIElement;
	import com.wezside.component.decorators.layout.FillLayout;
	import com.wezside.data.iterator.IIterator;

	/**
	 * @author Sean Lailvaux
	 */
	public class FormQuestions extends UIElement
	{
		private var _formPadding:Array;

		override public function set width( value:Number ):void
		{
			// does nothing
		}

		override public function set height( value:Number ):void
		{
			// does nothing
		}

		override public function arrange():void
		{
			if ( !stage ) return;
	
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var child:*;
			var formGroup:IFormGroup;
			while ( it.hasNext() )
			{
				child = it.next();
				if ( child is IFormGroup )
				{
					formGroup = IFormGroup( child );
					if ( formGroup.layout is FillLayout )
					{
						if ( FillLayout( formGroup.layout ).widthRatio > 0 )
						{
							FillLayout( formGroup.layout ).baseWidth = stage.stageWidth - ( layout.left + layout.right + formPadding[1] + formPadding[3]  );
						}
						if ( FillLayout( formGroup.layout ).heightRatio > 0 )
						{
							FillLayout( formGroup.layout ).baseHeight = stage.stageHeight - ( layout.top + layout.bottom + formPadding[0] + formPadding[2]  );
						}
					}
					formGroup.arrange();
				}
			}

			if ( it ) it.purge();

			it = null;
			child = null;
			formGroup = null;
		}

		public function get formPadding():Array
		{
			return _formPadding;
		}

		public function set formPadding( value:Array ):void
		{
			_formPadding = value;
		}

		public function show( responseLevelID:String ):void
		{
			var it:IIterator = iterator( UIElement.ITERATOR_CHILDREN );
			var child:*;
			var formGroup:IFormGroup;

			while ( it.hasNext() )
			{
				child = it.next();
				if ( child is IFormGroup && IFormGroup( child ).data.id == responseLevelID )
				{
					formGroup = IFormGroup( child );
					UIElement( formGroup ).visible = false;
				}
			}
		}
	}
}