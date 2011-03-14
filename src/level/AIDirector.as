package level 
{
	import org.flixel.*;
	
	/**
	 * Just a fancy name for a class that manages
	 * the procedural creation of the level
	 * @author Santiago Vilar
	 */
	public class AIDirector 
	{
		private var _level:FlxState;
		private var _levelTime:Number = 0;
		private var _difficultyLevel:int = -1;
		
		private const DIFFICULTY_LEVEL_COUNT:uint = 4;
		
		// times to switch difficulty level
		private var _timeThresholds:Array = new Array(10, 30, 60, 90);
		
		private var _timesBetweenPlanes:Array = new Array(2, 1.5, 1, 0);
		
		public function AIDirector(level:FlxState)
		{
			_level = level;
		}
		
		public function update():void
		{
			_levelTime += FlxG.elapsed;
			
			for (var i:int = DIFFICULTY_LEVEL_COUNT - 1; i >= 0; --i)
			{
				if (_levelTime > _timeThresholds[i])
				{
					if (i != _difficultyLevel)
					{
						_difficultyLevel = i;
						trace(_difficultyLevel, _levelTime);
					}
					break;
				}
			}
			
			
		}
	}
}