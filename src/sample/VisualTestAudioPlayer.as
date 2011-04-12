package sample
{
	import com.wezside.components.media.player.element.decorator.control.SkipToEndButton;
	import com.wezside.components.decorators.layout.HorizontalLayout;
	import com.wezside.components.decorators.layout.VerticalLayout;
	import com.wezside.components.media.player.Player;
	import com.wezside.components.media.player.display.PlayerDisplay;
	import com.wezside.components.media.player.element.PlayerControl;
	import com.wezside.components.media.player.element.PlayerControlEvent;
	import com.wezside.components.media.player.element.PlayerPlayList;
	import com.wezside.components.media.player.element.decorator.control.PauseButton;
	import com.wezside.components.media.player.element.decorator.control.PlayButton;
	import com.wezside.components.media.player.element.decorator.control.SkipToStartButton;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.components.media.player.resource.MediaResource;
	import com.wezside.data.collection.Collection;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
			control.layout = new HorizontalLayout( control );
			control.decorate( PlayButton );
			control.decorate( PauseButton );
			control.decorate( SkipToStartButton );
			control.decorate( SkipToEndButton );
			control.addEventListener( PlayerControlEvent.CLICK, controlClick );
			control.build();
			control.setStyle();
			control.arrange();
			
			display = new PlayerDisplay();
			display.addMediaType( Player.FLV );
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
			video.autoPlay = true;
			
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
		}

		private function controlClick( event:PlayerControlEvent  ):void
		{
			trace( "PlayerControl", event.target.id, "clicked." );
			if ( event.target.id == "pause" )
				player.pause();
				
			if ( event.target.id == "play" )
				player.play();
				
			if ( event.target.id == "rewind" )
				player.seek( 0 );
				
			if ( event.target.id == "ff" )
				player.seek( player.totalTime );

		}		
	}
}
