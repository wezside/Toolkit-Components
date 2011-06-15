package com.wezside.component.survey.data 
{
	import com.wezside.data.collection.ICollection;
	import com.wezside.utilities.manager.style.IStyleManager;

	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IFormItemData 
	{
		function get id():String;
		function set id( value:String ):void;	
		
		function get groupID():String;
		function set groupID( value:String ):void;
		
		function get type():String;
		function set type( value:String ):void;	
		
		function get value():String;
		function set value( value:String ):void;	
		
		function get defaultValue():String;
		function set defaultValue( value:String ):void;
		
		function get label():String
		function set label( value:String ):void
		
		function get sublabel():String
		function set sublabel( value:String ):void
		
		function get prefix():String
		function set prefix( value:String ):void
		
		function get suffix():String
		function set suffix( value:String ):void
		
		function get styleName():String;
		function set styleName( value:String ):void;
		
		function get iconStyleName():String;
		function set iconStyleName( value:String ):void;
		
		function get valid():Boolean;
		function set valid( value:Boolean ):void;	
		
		function get styleManager():IStyleManager;
		function set styleManager( value:IStyleManager ):void;
		
		function get styleNameCollection():ICollection;
		function set styleNameCollection( value:ICollection ):void;
		
		function get ignoreList():ICollection;
		function set ignoreList( value:ICollection ):void;
		
		function get state():String;
		function set state( value:String ):void;
		
		function get parent():IFormGroupData;
		function set parent( value:IFormGroupData ):void;
		
		function reset():void 
		function debug():void 
		function purge():void 
	}
}