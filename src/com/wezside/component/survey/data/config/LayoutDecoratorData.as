package com.wezside.component.survey.data.config 
{
	import com.wezside.data.IDeserializable;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class LayoutDecoratorData implements IDeserializable 
	{
		public var id:String;
		public var top:int;
		public var left:int;
		public var bottom:int;
		public var right:int;
		public var horizontalGap:int;
		public var verticalGap:int;		public var width:Number;		public var height:Number;
		public var horizontalFill:Boolean;
		public var verticalFill:Boolean;
		public var widthRatio:Number;
		public var heightRatio:Number;
		public var baseWidth:Number;
		public var baseHeight:Number;
		public var rows:Number;
		public var columns:Number;
	}
}
