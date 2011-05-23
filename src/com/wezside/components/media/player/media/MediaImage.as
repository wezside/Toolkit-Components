package com.wezside.components.media.player.media
{
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.wezside.components.media.player.resource.IMediaResource;

	import flash.display.Loader;
	import flash.events.IOErrorEvent;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class MediaImage extends Media
	{
		private var loader:Loader;
		private var img:Bitmap;
		
			
		override public function load( resource:IMediaResource ):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			loader.load( new URLRequest( resource.uri ), resource.context );
		}
			
		override public function purge():void
		{
			super.purge();
		}
			
		override public function play():Boolean
		{
			return super.play();
		}
			
		override public function pause():void
		{
			super.pause();
		}

		private function loadComplete( event:Event ):void
		{
			img = event.currentTarget.content;
			addChild( img );
			dispatchMeta();
		}
		
		private function dispatchMeta():void
		{
			totalTime = 1;
			if ( !resource.meta ) resource.meta = new MediaMeta();
			resource.meta.duration = totalTime;
			resource.meta.totalduration = totalTime;
			resource.meta.starttime = currentTime;
			resource.meta.width = img ? img.width : 0;					
			resource.meta.height = img ? img.height : 0;					
			dispatchEvent( new  MediaEvent( MediaEvent.META, false, false, resource.meta ));	
		}
		
		private function errorHandler( event:IOErrorEvent ):void
		{
			error.addElement( ERROR_LOAD, event.text );
			trace( event.text );
		}		
	}
}
