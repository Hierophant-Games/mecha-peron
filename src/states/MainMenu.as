package states 
{
	import embed.Assets;
	import game.Configuration;
	import menu.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class MainMenu extends MenuBase
	{
		override public function create():void
		{
			var bg:FlxSprite = new FlxSprite(0, 0, Assets.SpriteMenuBG);
			add(bg);
			
			var gameNameText:FlxText = new FlxText(2, 2, FlxG.width - 104, Game.Strings.languageXML.GameName);
			gameNameText.setFormat(null, 16);
			add(gameNameText);
			
			add(new FlxText(2, FlxG.height - 20, 100, Game.VERSION));
			
			initMenuEntries();
			
			FlxG.mouse.show(Assets.SpriteCursor);
			
			FlxG.flash.start(0xff000000, 0.5);
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function initMenuEntries():void
		{
			addMenuEntry(new MenuEntry(0, FlxG.height - 62, onPlay, new FlxText(0, 0, FlxG.width - 2, Game.Strings.languageXML.Menu.Play).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(0, FlxG.height - 48, onOptions, new FlxText(0, 0, FlxG.width - 2, Game.Strings.languageXML.Menu.Options).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(0, FlxG.height - 34, onCredits, new FlxText(0, 0, FlxG.width - 2, Game.Strings.languageXML.Menu.Credits).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(0, FlxG.height - 20, onHelp, new FlxText(0, 0, FlxG.width - 2, Game.Strings.languageXML.Menu.Help).setFormat(null, 8, 0xffffff, "right")));
		}
		
		private function onPlay():void
		{
			FlxG.music.stop();
			FlxG.play(Assets.SfxBigExplosion, Configuration.soundVolume);
			FlxG.flash.start(0xffffffff, 1, onFlashComplete);
			
			add(new FlxSprite(0, 0).createGraphic(FlxG.width, FlxG.height, 0xff000000));
		}
		
		private function onFlashComplete():void
		{
			Game.setState(new MainLevel());
		}
		
		private function onOptions():void
		{
			Game.setState(new Options());
			FlxG.play(Assets.SfxConsoleBlip, Configuration.soundVolume);
		}
		
		private function onHelp():void
		{
			Game.setState(new Help());
			FlxG.play(Assets.SfxConsoleBlip, Configuration.soundVolume);
		}
		
		private function onCredits():void
		{
			Game.setState(new Credits());
			FlxG.play(Assets.SfxConsoleBlip, Configuration.soundVolume);
		}
	}
}