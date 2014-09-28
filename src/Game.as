package  
{
	import flash.events.KeyboardEvent;
	import game.Configuration;
	import org.flixel.*;
	import states.Logo;
	import strings.GameStrings;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	[SWF(width = "960", height = "720", backgroundColor = "#000000")]
	[Frame(factoryClass="Preloader")]
	public class Game extends FlxGame
	{
		public static const VERSION:String = "v1.0";
		
		public static var Strings:GameStrings = new GameStrings();
		
		public function Game()
		{
			super(320, 240, Logo, 3);
			
			Configuration.load();
			FlxG.maxElapsed = 1 / 60; // try to evade v-sync issues
		}
		
		private static var _previousState:FlxState;
		
		public static function setState(newState:FlxState):void 
		{
			_previousState = FlxG.state;
			FlxG.state = newState;
		}
		
		public static function goToPreviousState():void
		{
			var currentState:FlxState = FlxG.state;
			FlxG.state = _previousState;
			_previousState = currentState;
		}
		
		override protected function onKeyUp(event:KeyboardEvent):void 
		{
			// disable console in release
			if (!FlxG.debug && ((event.keyCode == 192) || (event.keyCode == 220))) //FOR ZE GERMANZ
			{
				return;
			}
			super.onKeyUp(event);
		}
	}
}