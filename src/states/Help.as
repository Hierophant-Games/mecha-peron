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
	public class Help extends MenuBase
	{
		override public function create():void 
		{
			add(new FlxSprite(0, 0, Assets.SpriteMenuBG));
			
			var gameNameText:FlxText = new FlxText(2, 2, FlxG.width - 104, Game.Strings.languageXML.GameName);
			gameNameText.setFormat(null, 16);
			add(gameNameText);
			
			var text:String = new String();
			text = Game.Strings.languageXML.Help.Help1;
			text += "\n\n"
			text += Game.Strings.languageXML.Help.Help2;
			text += "\n\n"
			text += Game.Strings.languageXML.Help.Help3;
			
			add(new FlxText(20, 80, FlxG.width - 40, text));
			
			addMenuEntry(new MenuEntry(0, FlxG.height - 20, onBack, new FlxText(0, 0,FlxG.width - 10, Game.Strings.languageXML.Menu.Back).setFormat(null, 8, 0xffffff, "right")));
		}
		
		private function onBack():void
		{
			Game.goToPreviousState();
			FlxG.play(Assets.SfxConsoleBlip, Configuration.soundVolume);
		}
	}
}