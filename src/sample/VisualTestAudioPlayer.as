package sample
{
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import com.wezside.components.decorators.layout.VerticalLayout;
	import com.wezside.components.media.player.Player;
	import com.wezside.components.media.player.display.IPlayerDisplay;
	import com.wezside.components.media.player.display.PlayerDisplay;
	import com.wezside.components.media.player.element.PlayerControl;
	import com.wezside.components.media.player.element.PlayerPlayList;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.components.media.player.resource.MediaResource;
	import com.wezside.data.collection.Collection;
	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 * @author Wesley.Swanepoel
	 */
	public class VisualTestAudioPlayer extends Sprite
	{
		private var player:Player;
		private var control:PlayerControl;
		private var playlist:PlayerPlayList;
		private var display:PlayerDisplay;
		
		public function VisualTestAudioPlayer() 
		{
			addEventListener( Event.ADDED_TO_STAGE, stageInit );	
		}

		private function stageInit( event:Event ):void
		{		
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			control = new PlayerControl();
			control.build();
			control.setStyle();
			control.arrange();			 
			
			display = new PlayerDisplay();
			display.mediaWidth = 550;
			display.mediaHeight= 400;
			display.build();
			display.setStyle();
			display.arrange();	
			
			playlist = new PlayerPlayList();
			playlist.build();
			playlist.setStyle();
			playlist.arrange();
			
			var youtube:IMediaResource = new MediaResource();
			youtube.uri = "http://www.youtube.com/watch?v=CUPfQT4Dty0&feature=topvideos";
			
			var vimeo:IMediaResource = new MediaResource();
			vimeo.uri = "http://vimeo.com/3238824";
			vimeo.autoPlay = true;
			
			var audio:IMediaResource = new MediaResource();
			audio.uri = "http://ff123.net/samples/unt_lame388.mp3";
			
			var video:IMediaResource = new MediaResource();
			video.uri = "http://helpexamples.com/flash/video/water.flv";
			
			var image:IMediaResource = new MediaResource();
			image.uri = "http://i.bnet.com/blogs/mona-lisa.jpg";
			
			player = new Player();
			player.layout = new VerticalLayout( player );
			player.resources = new Collection([ youtube, vimeo, audio, video, image ]);
			player.addChild( display );
			player.addChild( control );
			player.addChild( playlist );
			player.build();
			player.setStyle();
			player.arrange();
			addChild( player );
			
			player.play( "water.flv" );
			player.pause();
			player.pause();
		}
		
	}
}
