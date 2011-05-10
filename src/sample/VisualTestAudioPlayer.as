package sample
{
	import com.wezside.components.media.player.event.PlaylistEvent;
	import com.wezside.components.decorators.layout.HorizontalLayout;
	import com.wezside.components.decorators.layout.PaddedLayout;
	import com.wezside.components.decorators.layout.VerticalLayout;
	import com.wezside.components.decorators.shape.ShapeRectangle;
	import com.wezside.components.media.player.Player;
	import com.wezside.components.media.player.PlayerAutoSizePolicy;
	import com.wezside.components.media.player.display.PlayerDisplay;
	import com.wezside.components.media.player.element.PlayerControl;
	import com.wezside.components.media.player.element.PlayerPlaylist;
	import com.wezside.components.media.player.element.control.MuteButton;
	import com.wezside.components.media.player.element.control.PauseButton;
	import com.wezside.components.media.player.element.control.PlayButton;
	import com.wezside.components.media.player.element.control.SkipToEndButton;
	import com.wezside.components.media.player.element.control.SkipToStartButton;
	import com.wezside.components.media.player.element.indicator.IndicatorProgress;
	import com.wezside.components.media.player.event.PlayerControlEvent;
	import com.wezside.components.media.player.resource.IMediaResource;
	import com.wezside.components.media.player.resource.MediaResource;
	import com.wezside.data.collection.Collection;
	import com.wezside.data.collection.ICollection;

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
		private var playlist:PlayerPlaylist;
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
			basic.element.height = 20;
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
			indicator.autoSize = true;
			indicator.layout = new HorizontalLayout( indicator );
			indicator.element = new IndicatorProgress( indicator );
			indicator.element.width = 200;
			indicator.element.height = 20;
			indicator.element.autoSize = true;
			indicator.element.flagForUpdate = true;
			indicator.element = new MuteButton( indicator.element );
			indicator.element.width = 200;
			indicator.addEventListener( PlayerControlEvent.CLICK, click );
			indicator.build();
			indicator.setStyle();
			indicator.arrange();
			
			// The FLV Display to use
			display = new PlayerDisplay();
			display.maintainAspectRatio = true;
			display.addMediaType( Player.FLV );
			display.addMediaType( Player.MP4 );
			display.build();
			display.setStyle();
			display.arrange();
			
			// The Playlist 
			playlist = new PlayerPlaylist();
			playlist.background = new ShapeRectangle( playlist );
			playlist.layout = new VerticalLayout( playlist );
//			playlist.itemClass = PlaylistItem;		// TODO: Make it easy to swap out classes for non CSS use cases
			playlist.entries = buildResources();
			playlist.addEventListener( PlaylistEvent.CLICK, playlistClick );
			playlist.build();
			playlist.setStyle();
			playlist.arrange();

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
			player.autoSizePolicy = PlayerAutoSizePolicy.STAGE;
			player.resources = playlist.entries;
			player.addChild( display );
			player.addChild( basic );
			player.addChild( indicator );
			player.addChild( playlist );
			player.build();
			player.setStyle();
			player.arrange();
			addChild( player );
		}

		private function playlistClick( event:PlaylistEvent ):void
		{
			player.play( "", event.data );
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
					player.volume( event.data ? 0 : player.currentVolume, 0 );
			}
			else if ( event.data && event.data.id == "progress" )
			{
				player.seek( event.data.seconds );
			}
		}		
		
		private function buildResources():ICollection
		{			
			var youtube:IMediaResource = new MediaResource();
			youtube.title = "Youtube";
			youtube.uri = "http://www.youtube.com/watch?v=CUPfQT4Dty0&feature=topvideos";
			
			var vimeo:IMediaResource = new MediaResource();
			vimeo.title = "Vimeo";
			vimeo.uri = "http://vimeo.com/3238824";
			vimeo.autoPlay = true;
			
			var audio:IMediaResource = new MediaResource();
			audio.bufferTime = 3000;
			audio.uri = "http://stage.wezside.co.za/dieantwoord/archive/music/2.mp3";
//			audio.artwork = "http://ecx.images-amazon.com/images/I/51Xy0lo%2BmEL._SS500_.jpg";
			audio.title = "Audio";
			audio.autoPlay = false;
			
			var video:IMediaResource = new MediaResource();
			video.title = "video";
			video.uri = "http://stage.wezside.co.za/media/Sucker Punch - Trailer HD.flv";
			video.autoPlay = true;
			video.bufferTime = 5;
			
			var videoMov:IMediaResource = new MediaResource();
			videoMov.title = "Video Mov";
			videoMov.uri = "http://stage.wezside.co.za/media/Sucker Punch - Trailer HD.mp4";
			videoMov.autoPlay = true;
			videoMov.bufferTime = 5;
			
			var video2:IMediaResource = new MediaResource();
			video2.title = "Video 2";
			video2.uri = "http://helpexamples.com/flash/video/water.flv";
			video2.bufferTime = 5;
			video2.autoPlay = true;
			
			var image:IMediaResource = new MediaResource();
			image.title = "Image";
			image.uri = "http://i.bnet.com/blogs/mona-lisa.jpg";		
			
			return new Collection([ youtube, vimeo, audio, video, image, video2, videoMov ]);	
		}
	}
}
