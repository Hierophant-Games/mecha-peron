package states 
{
	import menu.MenuEntry;
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class Help extends MenuBase
	{
		override public function create():void 
		{
			bgColor = 0xff000000;
			
			var text:String = new String();
			text = Game.Strings.languageXML.Help.Help1;
			text += "\n\n"
			text += Game.Strings.languageXML.Help.Help2;
			text += "\n\n"
			text += Game.Strings.languageXML.Help.Help3;
			
			add(new FlxText(20, 20, Game.ScreenWidth - 40, text));
			
			addMenuEntry(new MenuEntry(onBack, new FlxText(0, Game.ScreenHeight - 20, Game.ScreenWidth, Game.Strings.languageXML.Menu.Back).setFormat(null, 8, 0xffffff, "right")));
		}
		
		private function onBack():void
		{
			FlxG.state = new MainMenu(true);
		}
	}
}