package com.wezside.components.survey.data 
{

	/**
	 * @author Wesley.Swanepoel
	 */
	public class RiskFactorItemData extends FormItemData
	{
		private var _toolTipTitle:String;
		private var _toolTipBody:String;
		private var _riskFactorLevel: String;
		private var _riskFactorLabel: String;
		private var _weight : Number;
		public function get toolTipTitle() : String {
			return _toolTipTitle;
		}
		
		public function set toolTipTitle(value : String) : void {
			_toolTipTitle = value;
		}
		
		public function get toolTipBody() : String {
			return _toolTipBody;
		}
		
		public function set toolTipBody(value : String) : void {
			_toolTipBody = value;
		}
		
		public function get riskFactorLevel() : String {
			return _riskFactorLevel;
		}
		
		public function set riskFactorLevel(value : String) : void {
			_riskFactorLevel = value;
		}
		
		public function get weight() : Number {
			return _weight;
		}
		
		public function set weight(value : Number) : void {
			_weight = value;
		}
		
		public function get riskFactorLabel() : String {
			return _riskFactorLabel;
		}
		
		public function set riskFactorLabel(value : String) : void {
			_riskFactorLabel = value;
		}
	}
}
