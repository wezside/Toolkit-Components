package com.wezside.components.survey.data {
	import com.wezside.data.collection.ICollection;
	import com.wezside.utilities.manager.style.IStyleManager;

	/**
	 * @author Wesley.Swanepoel
	 */
	public interface IFormMetaData {
		
		function get data() : *;
		function set data( value : * ) : void;
		
		function get id() : String;
		function set id( value : String ) : void;
		
		function get label() : String;
		function set label( value : String ) : void;
		
		function get sublabel() : String;
		function set sublabel( value : String ) : void;
		
		function get styleManager() : IStyleManager;
		function set styleManager( value : IStyleManager ) : void;
		
		function get styleNameCollection() : ICollection;
		function set styleNameCollection( value : ICollection ) : void;
		
		function get ignoreList():ICollection;
		function set ignoreList( value:ICollection ):void;		
		
		function debug() : void;
	}
}