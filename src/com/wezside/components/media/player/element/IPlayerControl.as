package com.wezside.components.media.player.element
{
	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IPlayerControl extends IPlayerElement
	{
		
		function get autoSize():Boolean;
		function set autoSize( value:Boolean ):void;
		function get displayWidth():int;
		/**
		 * <p>The displayWidth property is set by the Player class upon receiving the Meta info 
		 * for the specific media element. In order to accurately determine the autosize width of 
		 * any IPlayerControl elements (IControlElement) we divide the collection by autoSize 
		 * is true and false respectively.</p><br>
		 * <p>The algorithm that achieves this works as follows:<br>
		 * <b>1. </b> Determine what the remaining width is after all non-autosize element's width were deducted<br>
		 * <b>2. </b> Set each autosize true element width = to the remainder width calculated above divided by
		 * the total autosize true elements so each element get an equal share of the remainder width<br>  
		 */
		function set displayWidth( value:int ):void;
		function get displayHeight():int;
		function set displayHeight( value:int ):void;	
	}
}
