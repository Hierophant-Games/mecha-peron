package states 
{
	import org.flixel.*;
	import org.flixel.data.FlxKong;
	import embed.Assets;
	
	/**
	 * Displays Logo
	 * @author Santiago Vilar
	 */
	public class Logo extends FlxState
	{
		private const LOGO_TIME:Number = 2.0;
		private var _timer:Number = 0;
		
		override public function create():void
		{
			var logo:FlxSprite = new FlxSprite(0, 0, Assets.SpriteHierophantLogo);
			add(logo);
			
			var text:FlxText = new FlxText(0, FlxG.height - 32, FlxG.width, Game.Strings.languageXML.Intro);
			text.setFormat(null, 16, 0xdedede, "center");
			add(text);
			
			FlxG.flash.start(0xff000000, 0.5);
		}
		
		override public function update():void
		{
			// Initialize Kong API
			if (!FlxG.kong)
				(FlxG.kong = (parent.addChild(new FlxKong()) as FlxKong)).init();
			
			_timer += FlxG.elapsed;
			
			if (_timer > LOGO_TIME || FlxG.mouse.pressed())
			{
				FlxG.fade.start(0xff000000, 0.5, onFadeComplete);
			}
			
			super.update();
		}
		
		private function onFadeComplete():void
		{
			Game.setState(new SelectLanguage());
		}
	}
}