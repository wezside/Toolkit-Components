package com.wezside.components.survey.ui {
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.Sprite;

	import com.wezside.components.UIElement;

	/**
	 * @author FChowdhury
	 */
	public class Preloader extends UIElement {
		private var _loader : Sprite;
		private const _speed : Number=2;
		private var _preloader:Sprite;
		private var _theStage:Stage;
		private var _background:Sprite;
		private var _isBackground:Boolean;
		public function Preloader() {
			super();
		}
		override public function build():void{
			if(_isBackground)
			{
				buildbackground();
			}
			buidloader();
			super.build();
		}

		private function buildbackground() : void {
			//Type of Gradient we will be using
			var fType:String = GradientType.LINEAR;
			//Colors of our gradient in the form of an array
			var colors:Array = [ 0x314c79, 0xa8c6de ];
			//Store the Alpha Values in the form of an array
			var alphas:Array = [ 0.7, 1 ];
			//Array of color distribution ratios.  
			//The value defines percentage of the width where the color is sampled at 100%
			var ratios:Array = [ 0, 255 ];
			//Create a Matrix instance and assign the Gradient Box
			var matr:Matrix = new Matrix();
			    matr.createGradientBox( 200, _theStage.stageHeight*0.5,  (Math.PI/180)*90, 0, 0 );
			//SpreadMethod will define how the gradient is spread. Note!!! Flash uses CONSTANTS to represent String literals
			var sprMethod:String = SpreadMethod.PAD;
			_background = new Sprite();
			_background.graphics.beginGradientFill( fType, colors, alphas, ratios, matr, sprMethod );
			_background.graphics.drawRect(0, 0, _theStage.stageWidth, _theStage.stageHeight);
			_background.graphics.endFill();
			addChild(_background);
		}

		private function buidloader() : void {
			if(!_preloader)
			{
				if(styleManager.hasAssetByName("PreLoader"))
				{
					_loader = Sprite(styleManager.getAssetByName("PreLoader"));
					addChild(_loader);
				
				}
			}else{
				
				_loader = _preloader;
				
				addChild(_loader);
				resize();
			}
		}
		public function start():void{
			if(_theStage)
			{
				_theStage.addEventListener(Event.ENTER_FRAME, spinLoader);
			}else{
				stage.addEventListener(Event.ENTER_FRAME, spinLoader);
			}
		}

		private function spinLoader(event : Event) : void {
			_loader.rotation+=_speed;
		}
		public function stop():void{
			stage.removeEventListener(Event.ENTER_FRAME, spinLoader);
		}

		public function get preloader() : Sprite {
			return _preloader;
		}

		public function set preloader(value : Sprite) : void {
			_preloader = value;
		}

		public function get theStage() : Stage {
			return _theStage;
		}

		public function set theStage(value : Stage) : void {
			_theStage = value;
		}


		public function get isBackground() : Boolean {
			return _isBackground;
		}

		public function set isBackground(value : Boolean) : void {
			_isBackground = value;
		}
		public function resize():void{
			if(_isBackground)
			{
				_background.width=_theStage.stageWidth ;
				_background.height=_theStage.stageHeight;
			}
			if(_loader)
			{
			_loader.x = int( _theStage.stageWidth * .5 );
			_loader.y = int( _theStage.stageHeight * .5 );
			}
		}
	}
}
