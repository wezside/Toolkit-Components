package com.wezside.components.media.player
{
	/**
	 * @author Wesley.Swanepoel
	 * 
	 * Robert Penner's equation extracted into a separate class so there is no dependancy 
	 * on the Greensock lib.
	 */
	public class Equations
	{
						
		/**
		 *  Robert Penner's equation. Cubic easing in/out - acceleration until halfway, then deceleration
		 *  @param t Current time
		 *  @param b Beginning value
		 *  @param c Change in value
		 *  @param d Duration
		 */
		public static function easeInOutCubic( t:Number, b:Number, c:Number, d:Number ):Number 
		{
			if (( t /= d*0.5 ) < 1) return c*0.5*t*t*t + b;
			return c*0.5*((t-=2)*t*t + 2) + b;
		}			
		
		/**
		 *  Robert Penner's equation. Linear motion equation.
		 *  @param t Current time
		 *  @param b Beginning value
		 *  @param c Change in value
		 *  @param d Duration
		 */
		public static function linearTween( t:Number, b:Number, c:Number, d:Number ):Number 
		{
			return c*t/d + b;
		}		
	}
}
