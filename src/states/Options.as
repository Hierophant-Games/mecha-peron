package states 
{
	import embed.Assets;
	import flash.events.MouseEvent;
	import game.Configuration;
	import menu.*;
	import org.flixel.*;
	
	/**
	 * Options state. To set those values for the game...
	 * @author Santiago Vilar
	 */
	public class Options extends MenuBase 
	{
		private const BAR_WIDTH:Number = 200;
		private const BAR_HEIGHT:Number = 10;
		private const BAR_COLOR:uint = 0xffcccccc;
		
		private const SLIDE_WIDTH:Number = 10;
		private const SLIDE_HEIGHT:Number = 10;
		private const SLIDE_COLOR:uint = 0xffffffff;
		
		private const MUSIC_POS_Y:Number = 100;
		private const SOUND_POS_Y:Number = 160;
		
		private var _musicBar:FlxSprite;
		private var _soundBar:FlxSprite;
		
		private var _musicSlide:FlxSprite;
		private var _soundSlide:FlxSprite;
		
		override public function create():void
		{
			var gameNameText:FlxText = new FlxText(2, 2, FlxG.width - 104, Game.Strings.languageXML.GameName);
			gameNameText.setFormat(null, 16);
			add(gameNameText);
			
			add(new FlxText(10, MUSIC_POS_Y - 20, 200, Game.Strings.languageXML.Options.MusicVolume));
			add(new FlxText(10, SOUND_POS_Y - 20, 200, Game.Strings.languageXML.Options.SoundVolume));
			
			_musicBar = new FlxSprite(10, MUSIC_POS_Y);
			_musicBar.createGraphic(BAR_WIDTH, BAR_HEIGHT, BAR_COLOR);
			
			_musicSlide = new FlxSprite(10, MUSIC_POS_Y);
			_musicSlide.createGraphic(SLIDE_WIDTH, SLIDE_HEIGHT, SLIDE_COLOR);
			
			_soundBar = new FlxSprite(10, SOUND_POS_Y);
			_soundBar.createGraphic(BAR_WIDTH, BAR_HEIGHT, BAR_COLOR);
			
			_soundSlide = new FlxSprite(10, SOUND_POS_Y);
			_soundSlide.createGraphic(SLIDE_WIDTH, SLIDE_HEIGHT, SLIDE_COLOR);
			
			add(_musicBar);
			add(_musicSlide);
			add(_soundBar);
			add(_soundSlide);
			
			loadConfig();
			
			// add back
			addMenuEntry(new MenuEntry(0, FlxG.height - 20, onBack, new FlxText(0, 0, FlxG.width - 10, Game.Strings.languageXML.Menu.Back).setFormat(null, 8, 0xffffff, "right")));
		}
		
		override public function update():void
		{
			if (FlxG.mouse.pressed())
			{
				moveSlideInBar(_musicBar, _musicSlide, saveMusicVolume);
				moveSlideInBar(_soundBar, _soundSlide, saveSoundVolume);
			}
			
			super.update();
		}
		
		private function moveSlideInBar(bar:FlxSprite, slide:FlxSprite, saveMethod:Function):void
		{
			if (bar.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y))
			{
				var posX:Number = FlxG.mouse.x - bar.x;
				if (posX > bar.width - slide.width)
					posX = bar.width - slide.width;
				var volume:Number = posX / (bar.width - slide.width);
				saveMethod(volume);
				
				slide.x = posX + bar.x;
			}
		}
		
		private function saveMusicVolume(volume:Number):void
		{
			FlxG.music.volume = volume;
			Configuration.musicVolume = volume;
			
		}
		
		private function saveSoundVolume(volume:Number):void
		{
			FlxG.play(Assets.SfxConsoleBlip, volume);
			Configuration.soundVolume = volume;
		}
		
		private function loadConfig():void
		{
			Configuration.load();
			updateBar(_musicBar, _musicSlide, Configuration.musicVolume);
			updateBar(_soundBar, _soundSlide, Configuration.soundVolume);
		}
		
		private function updateBar(bar:FlxSprite, slide:FlxSprite, volume:Number):void
		{
			slide.x = bar.x + (bar.width - slide.width) * volume;
		}
		
		private function onBack():void
		{
			// save here... too slow to do it as the slider goes
			Configuration.save();
			Game.goToPreviousState();
			FlxG.play(Assets.SfxConsoleBlip, Configuration.soundVolume);
		}
	}
}