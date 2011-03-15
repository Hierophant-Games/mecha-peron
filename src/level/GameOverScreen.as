package level 
{
	import menu.*;
	import org.flixel.*;
	import states.*;
	import embed.Assets;
	/**
	 * ...
	 * @author 
	 */
	public class GameOverScreen extends FlxGroup
	{
		private var _menu:MenuBase;
		
		private var _background:FlxSprite;
		
		private var _score:FlxText;
		private var _scoreLine:FlxText;
		
		private var _tryAgain:FlxButton;
		private var _gotoMainMenu:FlxButton;
		
		private const MENU_DELAY:Number = 2.0;
		private var _timer:Number = 0;
		
		private const FALLING:Number = 0;
		private const PREMENU:Number = 1;
		private const SHOWMENU:Number = 2;
		private var _state:Number = FALLING;
		
		private const WIDTH:Number = 150;
		
		public function GameOverScreen(score:String) 
		{
			y = -FlxG.height;
			
			_background = new FlxSprite();
			_background.createGraphic(150, FlxG.height, 0xff000000);
			_background.x = FlxG.width - FlxG.scroll.x - WIDTH + 1; // +1 because fuck you
			add(_background);
			
			_scoreLine = new FlxText(_background.x, 20, WIDTH, Game.Strings.languageXML.GameOver.ScoreLine);
			_scoreLine.setFormat(null, 16, 0xffffff, "center");
			add(_scoreLine);
			
			_score = new FlxText(_background.x, 100, WIDTH, score);
			_score.setFormat(null, 24, 0xffffff, "center");
			add(_score);
			
			_menu = new MenuBase();
			
			var tryAgainText:FlxText = new FlxText(0, 0, WIDTH, Game.Strings.languageXML.GameOver.TryAgain);
			tryAgainText.setFormat(null, 20, 0xffffff, "center");
			_menu.addMenuEntry(new MenuEntry(_background.x, 180, onTryAgain, tryAgainText));
			
			var mainMenuText:FlxText = new FlxText(0, 0, WIDTH, Game.Strings.languageXML.GameOver.MainMenu);
			mainMenuText.setFormat(null, 18, 0xffffff, "center");
			_menu.addMenuEntry(new MenuEntry(_background.x, 210, onMainMenu, mainMenuText));
			
			_menu.visible = false;
			add(_menu.defaultGroup);
		}
		
		public function start():void
		{
			acceleration.y = 20;
		}
		
		override public function update():void
		{
			switch(_state)
			{
				case FALLING:
					if (y >= 0)
					{
						acceleration.y = 0;
						velocity.y = 0;
						y = 0;
						
						_timer = MENU_DELAY;
						_state = PREMENU;
					}					
					break;
				case PREMENU:
					if ((_timer -= FlxG.elapsed) <= 0)
					{
						_state = SHOWMENU;
						_menu.visible = true;
						FlxG.mouse.show(Assets.SpriteCursor);
					}
					break;
				case SHOWMENU:
					_menu.update();
					break;
			}
			
			super.update();
		}
		
		private function onTryAgain():void
		{
			Game.setState(new MainLevel());
		}
		
		private function onMainMenu():void
		{
			Game.setState(new MainMenu());
		}
	}

}