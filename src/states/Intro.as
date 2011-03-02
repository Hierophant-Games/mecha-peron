package states 
{
	import embed.Assets;
	import org.flixel.*;
	
	/**
	 * Intro sequence
	 * @author Santiago Vilar
	 */
	public class Intro extends FlxState 
	{
		private const DISCLAIMER_TIME:Number = 5;
		private const NOT_TIME:Number = 2;
		private var _timer:Number = 0;
		
		private var _step:uint = 0;
		
		private var _disclaimerText:FlxText;
		private var _notText:FlxText;
		
		override public function create():void
		{
			var disclaimerStr:String = Game.Strings.languageXML.Disclaimer.Title;
			disclaimerStr += "\n\n";
			disclaimerStr += Game.Strings.languageXML.Disclaimer.Description;
			
			_disclaimerText = new FlxText(0, 0, FlxG.width, disclaimerStr);
			_disclaimerText.setFormat(null, 16, 0xffffff, "center");
			_disclaimerText.y = FlxG.height / 2 - _disclaimerText.height / 2;
			add(_disclaimerText);
			
			_notText = new FlxText(0, 0, FlxG.width, Game.Strings.languageXML.Disclaimer.Not);
			_notText.setFormat(null, 16, 0xffffff, "center");
			_notText.y = FlxG.height - _notText.height - 10;
			
			FlxG.playMusic(Assets.LosMuchachos8Bit);
		}
		
		override public function update():void
		{
			_timer += FlxG.elapsed;
			
			switch (_step)
			{
				case 0:
				{
					if (_timer > DISCLAIMER_TIME || FlxG.mouse.justPressed())
					{
						_step++;
						_timer = 0;
						add(_notText);
					}
					break;
				}
				case 1:
				{
					if (_timer > NOT_TIME || FlxG.mouse.justPressed())
					{
						_step++;
						FlxG.fade.start(0xff000000, 0.5, onFadeComplete);
					}
					break;
				}
			}
			
			super.update();
		}
		
		private function onFadeComplete():void
		{
			Game.setState(new MainMenu());
		}
	}
}