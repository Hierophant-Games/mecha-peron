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
		private const DISCLAIMER_TIME:Number = 4.0;
		private var _timer:Number = 0;
		
		override public function create():void
		{
			var disclaimerStr:String = Game.Strings.languageXML.Disclaimer.Title;
			disclaimerStr += "\n\n";
			disclaimerStr += Game.Strings.languageXML.Disclaimer.Description;
			
			var disclaimerText:FlxText = new FlxText(0, 0, FlxG.width, disclaimerStr);
			disclaimerText.setFormat(null, 16, 0xffffff, "center");
			disclaimerText.y = FlxG.height / 2 - disclaimerText.height / 2;
			add(disclaimerText);
			
			FlxG.playMusic(Assets.LosMuchachos8Bit);
		}
		
		override public function update():void
		{
			_timer += FlxG.elapsed;
			
			if (_timer > DISCLAIMER_TIME)
			{
				Game.setState(new MainMenu());
			}
			
			super.update();
		}
	}
}