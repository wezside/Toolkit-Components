package com.wezside.components.media.player.resource
{
	import flash.system.LoaderContext;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaResource implements IMediaResource
	{
		
		private var _data:*;
		private var _id:String;
		private var _uri:String;
		private var _type:String;
		private var _key:String;
		private var _clazz:Class;
		private var _xmlns:Namespace;
		private var _bytesTotal:Number;
		private var _bytesLoaded:Number;
		private var _context:LoaderContext;
		private var _autoPlay:Boolean;

		public function MediaResource() 
		{
			_autoPlay = false;
		}
		
		public function get type():String
		{
			return _type;
		}

		public function get uri():String
		{
			return _uri;
		}

		public function set type( value:String ):void
		{
			_type = value;
		}

		public function set uri( value:String ):void
		{
			_uri = value;
		}

		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}

		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}

		public function set bytesLoaded( value:Number ):void
		{
			_bytesLoaded = value;
		}

		public function set bytesTotal( value:Number ):void
		{
			_bytesTotal = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id( value:String ):void
		{
			_id = value;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data( value:* ):void
		{
			_data = value;			
		}

		public function get xmlns():Namespace
		{
			return _xmlns;
		}

		public function set xmlns( value:Namespace ):void
		{
			_xmlns = value;
		}

		public function get context():LoaderContext
		{
			return _context;
		}

		public function set context( value:LoaderContext ):void
		{
			_context = value;
		}

		public function get key():String
		{
			return _key;
		}

		public function set key( value:String ):void
		{
			_key = value;
		}

		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		public function set autoPlay( value:Boolean ):void
		{
			_autoPlay = value;
		}
	}
}
