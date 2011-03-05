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
			_gameNameText = new FlxText(2, 2, FlxG.width - 104, Game.Strings.languageXML.GameName);
			_gameNameText.setFormat(null, 16);
			add(_gameNameText);
			
			initMenuEntries();
			
			FlxG.mouse.load(Assets.SpriteCursor);
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
			addMenuEntry(new MenuEntry(0, FlxG.height - 48, onPlay, new FlxText(0, 0, FlxG.width - 2, Game.Strings.languageXML.Menu.Play).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(0, FlxG.height - 34, onOptions, new FlxText(0, 0, FlxG.width - 2, Game.Strings.languageXML.Menu.Options).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(0, FlxG.height - 20, onHelp, new FlxText(0, 0, FlxG.width - 2, Game.Strings.languageXML.Menu.Help).setFormat(null, 8, 0xffffff, "right")));
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