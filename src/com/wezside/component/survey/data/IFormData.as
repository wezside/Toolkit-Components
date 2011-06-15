package com.wezside.component.survey.data 
{
	import com.wezside.data.collection.ICollection;
	import com.wezside.data.iterator.IIterator;
	import com.wezside.utilities.manager.style.IStyleManager;

	public interface IFormData 
	{
		function get id():String;	
		function set id(value:String):void;		
		
		function get type():String;	
		function set type(value:String):void;

		function get valid():Boolean;
		function set valid( value:Boolean ):void;		

		function get styleManager():IStyleManager;
		function set styleManager( value:IStyleManager ):void;

		function get styleNameCollection():ICollection;
		function set styleNameCollection( value:ICollection ):void;
		
		function get layoutDecorators():ICollection;
		function set layoutDecorators( value:ICollection ):void;

		function get ignoreList():ICollection;
		function set ignoreList( value:ICollection ):void;

		function get responseGroupings():ICollection;
		function set responseGroupings( value:ICollection ):void;
			
		function get iterator():IIterator;	
		
		function addFormGroupData( group:IFormGroupData ):void;
		function getFormGroupData( id:String ):IFormGroupData;
		function removeFormGroupData( group:IFormGroupData ):void;
		
		function get lastGroupID():String;		
		function hasResponseGroupings( id:String ):Boolean;
				
		function debug():void;		
		function purge():void;

		function getResponseItemIds( groupID:String, id:String ):Number;
	}
}
