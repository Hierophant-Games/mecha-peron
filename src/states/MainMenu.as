package states 
{
	import embed.Assets;
	import menu.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class MainMenu extends MenuBase
	{
		private var _gameNameText:FlxText;
		
		override public function create():void
		{
			_gameNameText = new FlxText(2, 2, FlxG.width / 2, Game.Strings.languageXML.GameName);
			_gameNameText.setFormat(null, 16);
			add(_gameNameText);
			
			initMenuEntries();
			
			FlxG.playMusic(Assets.LosMuchachos8Bit);
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
			addMenuEntry(new MenuEntry(onPlay, new FlxText(0, FlxG.height - 48, FlxG.width - 2, Game.Strings.languageXML.Menu.Play).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(onOptions, new FlxText(0, FlxG.height - 34, FlxG.width - 2, Game.Strings.languageXML.Menu.Options).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(onHelp, new FlxText(0, FlxG.height - 20, FlxG.width - 2, Game.Strings.languageXML.Menu.Help).setFormat(null, 8, 0xffffff, "right")));
		}
		
		private function onPlay():void
		{
			Game.setState(new MainLevel());
		}
		
		private function onOptions():void
		{
			trace("options");
		}
		
		private function onHelp():void
		{
			Game.setState(new Help());
		}
	}
}