package  
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import game.Configuration;
	import org.flixel.*;
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
		public static const ZOOM:uint = 2;
		public static const VERSION:String = "v1.0";
		
		// only spanish, for our audience
		public static const ES_ONLY:Boolean = false;
		
		public static var Strings:GameStrings = new GameStrings();
		
		public function Game()
		{
			super(320, 240, Logo, ZOOM);
			
			Configuration.load();
			FlxG.maxElapsed = 1 / 60; // try to evade v-sync issues
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onStageResized);
		}
		
		private function onStageResized(e:Event):void
		{
			var dx:uint = Math.max(0, stage.stageWidth - FlxG.width * ZOOM);
			var dy:uint = Math.max(0, stage.stageHeight - FlxG.height * ZOOM);
			
			var screen:DisplayObject = stage.getChildAt(0);
			screen.x = dx / 2;
			screen.y = dy / 2;
		}
		
		private static var _previousState:FlxState;
		
		public static function get previousState():FlxState
		{
			return _previousState;
		}
		
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