package  
{
	import org.flixel.FlxGame;
	import states.Logo;
	import strings.GameStrings;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	[Frame(factoryClass="Preloader")]
	public class Game extends FlxGame
	{
		public static const ScreenWidth:uint = 320;
		public static const ScreenHeight:uint = 240;
		
		public static var Strings:GameStrings = new GameStrings();
		
		public function Game()
		{
			super(ScreenWidth, ScreenHeight, Logo, 2);
		}
	}
}