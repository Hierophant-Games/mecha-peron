package states 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class Logo extends FlxState
	{
		private const LogoSeconds:Number = 0.1;
		private var _timer:Number = 0;
		
		override public function create():void
		{
			var text:FlxText = new FlxText(0, Game.ScreenHeight / 2 - 16, Game.ScreenWidth, Game.Strings.languageXML.Intro);
			text.setFormat(null, 16, 0xffffff, "center");
			add(text);
		}
		
		override public function update():void
		{
			_timer += FlxG.elapsed;
			
			if (_timer > LogoSeconds)
			{
				trace("logo ended")
				FlxG.state = new MainMenu();
			}
			
			super.update();
		}
	}
}