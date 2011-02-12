package states 
{
	import menu.*;
	import player.*;
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class PlayerStats extends MenuBase 
	{
		private var _player:Player;
		
		public function PlayerStats(player:Player)
		{
			_player = player;
		}
		
		override public function create():void 
		{
			bgColor = 0xff000000;
			addMenuEntry(new MenuEntry(onBack, new FlxText(0, Game.ScreenHeight - 20, Game.ScreenWidth - 10, Game.Strings.languageXML.Menu.Back).setFormat(null, 8, 0xffffff, "right")));
			
			add(new FlxText(0, 0, Game.ScreenWidth, Game.Strings.languageXML.PlayerStats.Title));
		}
		
		private function onBack():void 
		{
			Game.goToPreviousState();
		}
	}
}