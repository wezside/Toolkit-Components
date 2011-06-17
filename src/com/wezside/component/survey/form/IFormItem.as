package com.wezside.component.survey.form 
{
	import com.wezside.component.IUIElement;
	import com.wezside.component.survey.data.IFormItemData;
	import com.wezside.data.collection.ICollection;

	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IFormItem extends IUIElement
	{
		function get id():String;
		function get type():String;

		function get value():String;
		function set value( value:String ):void;

		function get selected():Boolean;
		function set selected( value:Boolean ):void;

		function get data():IFormItemData;
		function set data( value:IFormItemData ):void;

		function get debug():Boolean;
		function set debug( value:Boolean ):void;

		function get valid():Boolean;
		function set valid( value:Boolean ):void;

		function activate():void;		function deactivate():void;
		function setDataCollection( collection:ICollection ):void
	}
}
