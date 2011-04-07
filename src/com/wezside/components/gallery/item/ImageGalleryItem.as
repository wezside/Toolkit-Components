/*
	The MIT License

	Copyright (c) 2010 Wesley Swanepoel
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
 */
package com.wezside.components.gallery.item 
{
	import com.wezside.components.gallery.GalleryEvent;
	import com.wezside.utilities.logging.Tracer;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
	 * @author Wesley.Swanepoel
	 */
	public class ImageGalleryItem extends AbstractGalleryItem
	{

		
		public function ImageGalleryItem( type:String, debug:Boolean )
		{
			super( type, debug );			
		}				
		
		override public function load( url:String, livedate:Date, linkage:String = "", thumbWidth:int = 80, thumbHeight:int = 80 ):void
		{
			Tracer.output( debug, " ("+url+", " + livedate + ")", toString() );
			this.livedate = livedate;
			dispatchEvent( new GalleryEvent( GalleryEvent.ITEM_PROGRESS, false, false, 0 ));
			
			loader = new Loader( );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, complete );	
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progress );	
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, error );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.NETWORK_ERROR, error );
			loader.load( new URLRequest( url ));				
		}		

		
		protected function progress( event:ProgressEvent ):void
		{
			var percent:Number = ( event.bytesLoaded / event.bytesTotal ) * 100;
			dispatchEvent( new GalleryEvent( GalleryEvent.ITEM_PROGRESS, false, false, percent ));
		}

		protected function complete( event:Event ):void
		{
			var img:Bitmap = new Bitmap( event.currentTarget.content.bitmapData );
			img.smoothing = true;
			addChildAt( img, 0 );
			alpha = 0.5;
			dispatchEvent( new GalleryEvent( GalleryEvent.ITEM_LOAD_COMPLETE, false, false, this ));			
		}
		
		protected function error( event:IOErrorEvent ):void
		{
			Tracer.output( true, " ImageVideoWallItem.error(event) " + event.text, toString() );
			dispatchEvent( new GalleryEvent( GalleryEvent.ITEM_ERROR  ));
		}		
	}
}
