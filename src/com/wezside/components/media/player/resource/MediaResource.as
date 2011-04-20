package com.wezside.components.media.player.resource
{
	import com.wezside.components.media.player.media.MediaMeta;
	import com.wezside.data.IDeserializable;

	import flash.system.LoaderContext;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaResource implements IMediaResource,IDeserializable
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
		private var _quality:int;
		private var _bufferTime:Number;
		private var _meta:MediaMeta;
		private var _title:String;

		public static const QUALITY_DEFAULT:int = 0;
		public static const QUALITY_LOW:int = 1;
		public static const QUALITY_MEDIUM:int = 2;
		public static const QUALITY_HIGH:int = 3;

		public function MediaResource() 
		{
			_autoPlay = false;
		}
		
		public function get type():String
		{
			return _type.toUpperCase();
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

		public function get quality():int
		{
			return _quality;
		}

		public function set quality( value:int ):void
		{
			_quality = value;
		}

		public function get bufferTime():Number
		{
			return _bufferTime;
		}

		public function set bufferTime( value:Number ):void
		{
			_bufferTime = value;
		}

		public function get meta():MediaMeta
		{
			return _meta;
		}

		public function set meta( value:MediaMeta ):void
		{
			_meta = value;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title( value:String ):void
		{
			_title = value;
		}
	}
}
