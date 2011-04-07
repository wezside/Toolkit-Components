package com.wezside.components.survey.data 
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
		
		function get body():String;		
		function set body(value:String):void;		

		function get cta():String;		
		function set cta(value:String):void;

		function get heading():String;		
		function set heading(value:String):void;	

		function get subheading():String;		
		function set subheading(value:String):void;		

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
		function get metaIterator():IIterator;
		
		function addMetaData( meta:IFormMetaData ):void;
		function getMetaData( id:String ):IFormMetaData;
		function getMetaDataByIndex( index:uint ):IFormMetaData;
		function get numMeta():uint
		
		function addFormGroupData( group:IFormGroupData ):void;
		function getFormGroupData( id:String ):IFormGroupData;
		function removeFormGroupData( group:IFormGroupData ):void;
		function get lastGroupID():String;
		
		function isResponseGrouping( id:String ):Boolean;
		function getResponseParentId( id:String ):String;
		function hasResponseGrouping( id:String ):Boolean;
		function getResponseItemIds( groupId:String,responseId:String,otherItems:Boolean=false ):ICollection;
		function hasAssociatedGrouping( id:String, formItemID:String ):Boolean;
		function getNestedGroupItems(groupid:String,itemCollection:ICollection):ICollection;
		function getItemsByGroupId(groupid : String, itemCollection : ICollection) : void;		
		function debug():void;		
		function purge():void;

	}
}
