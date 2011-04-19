package sample
{
	import com.wezside.components.decorators.layout.HorizontalLayout;
	import com.wezside.components.decorators.layout.PaddedLayout;
	import com.wezside.components.decorators.layout.VerticalLayout;
	import com.wezside.components.decorators.shape.ShapeRectangle;
	import com.wezside.components.media.player.Player;
	import com.wezside.components.media.player.display.PlayerDisplay;
	import com.wezside.components.media.player.element.PlayerControl;
	import com.wezside.components.media.player.element.PlayerControlEvent;
	import com.wezside.components.media.player.element.PlayerPlayList;
	import com.wezside.components.media.player.element.control.MuteButton;
	import com.wezside.components.media.player.element.control.PauseButton;
	import com.wezside.components.media.player.element.control.PlayButton;
	import com.wezside.components.media.player.element.control.SkipToEndButton;
	import com.wezside.components.media.player.element.control.SkipToStartButton;
	import com.wezside.components.media.player.element.indicator.IndicatorPlayback;
	import com.wezside.components.media.player.element.indicator.IndicatorProgress;
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
		private var playlist:PlayerPlayList;
		private var display:PlayerDisplay;
		private var basic:PlayerControl;
		private var indicator:PlayerControl;
		
		public function VisualTestAudioPlayer() 
		{
			addEventListener( Event.ADDED_TO_STAGE, stageInit );	
		}

		private function stageInit( event:Event ):void
		{			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Basic controls
			basic = new PlayerControl();
			basic.autoSize = false;
			basic.layout = new HorizontalLayout( basic );
			basic.element = new PlayButton( basic );
			basic.element.data = "PLAY";
			basic.element = new PauseButton( basic.element );
			basic.element = new SkipToStartButton( basic.element );
			basic.element = new SkipToEndButton( basic.element );
			basic.addEventListener( PlayerControlEvent.CLICK, click );
			basic.build();
			basic.setStyle();
			basic.arrange();
			
			// Indicator control
			indicator = new PlayerControl();
			indicator.layout = new HorizontalLayout( indicator );
			indicator.autoSize = true;
			indicator.element = new IndicatorProgress( indicator );
			indicator.element.width = 200;
			indicator.element.autoSize = true;
			indicator.element = new MuteButton( indicator.element );
			indicator.element.width = 200;
			indicator.element.autoSize = false;
			indicator.element = new IndicatorPlayback( indicator.element );
			indicator.element.width = 2;
			indicator.element.autoSize = true;
			indicator.addEventListener( PlayerControlEvent.CLICK, click );
			indicator.build();
			indicator.setStyle();
			indicator.arrange();
			
			// The FLV Display to use
			display = new PlayerDisplay();
			display.maintainAspectRatio = false;
			display.addMediaType( Player.FLV );
			display.addMediaType( Player.MP4 );
			display.build();
			display.setStyle();
			display.arrange();
			
			// The Playlist 
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
			video.uri = "http://stage.wezside.co.za/media/Sucker Punch - Trailer HD.flv";
			video.autoPlay = true;
			video.bufferTime = 5;
			
			var videoMov:IMediaResource = new MediaResource();
			videoMov.uri = "http://stage.wezside.co.za/media/Sucker Punch - Trailer HD.mp4";
			videoMov.autoPlay = true;
			
			var video2:IMediaResource = new MediaResource();
			video2.uri = "http://helpexamples.com/flash/video/water.flv";
			video2.bufferTime = 5;
			video2.autoPlay = true;			
			
			var image:IMediaResource = new MediaResource();
			image.uri = "http://i.bnet.com/blogs/mona-lisa.jpg";
			
			// Build player component
			player = new Player();
			player.layout = new VerticalLayout( player );
			player.layout = new PaddedLayout( player.layout );
			player.layout.top = 10;
			player.layout.right = 10;
			player.layout.bottom = 10;
			player.layout.left = 10;			
			player.background = new ShapeRectangle( player );
			player.background.colours = [ 0x676968, 0x676968];
			player.background.alphas = [ 1, 1 ];
			player.autoSizePolicy = Player.AUTOSIZE_STAGE;
			player.resources = new Collection([ youtube, vimeo, audio, video, image, video2, videoMov ]);
			player.addChild( display );
			player.addChild( basic );
			player.addChild( indicator );
			player.addChild( playlist );
			player.build();
			player.setStyle();
			player.arrange();
			addChild( player );
			player.play( "Sucker Punch - Trailer HD.flv" );
		}

		private function click( event:PlayerControlEvent  ):void
		{
			if ( event.target.hasOwnProperty( "id" ))
			{
				if ( event.target.id == "pause" )
					player.pause();
					
				if ( event.target.id == "play" )
					player.play();
					
				if ( event.target.id == "rewind" )
					player.seek( 0 );
					
				if ( event.target.id == "ff" )
					player.seek( player.totalTime );
					
				if ( event.target.id == "mute" )
					player.volume( event.data ? 0 : player.currentVolume, 1 );
			}
			if ( event.data && event.data.id == "progress" )
			{
				trace( "Seek to position", event.data.seconds );
				player.seek( event.data.seconds );
			}
		}		
	}
}
