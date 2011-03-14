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
		private var _difficultyLevel:int = 0;
		
		private const DIFFICULTY_LEVEL_COUNT:uint = 4;
		
		// times to switch difficulty level
		private var _timeThresholds:Array = new Array(15, 30, 60);
		
		// planes!
		private var _timesBetweenPlanes:Array = new Array(4, 3, 2, 1);
		private var _lastPlaneTime:Number = 0;
		private var _planeSpawnFunction:Function;
		
		// buildings!
		private var _timesBetweenBuildings:Array = new Array(10, 8, 6, 4);
		private var _lastBuildingTime:Number = 0;
		private var _buildingSpawnFunction:Function;
		
		public function AIDirector(level:FlxState, planeSpawnFunction:Function, buildingSpawnFunction:Function)
		{
			_level = level;
			_planeSpawnFunction = planeSpawnFunction;
			_buildingSpawnFunction = buildingSpawnFunction;
		}
		
		public function update():void
		{
			_levelTime += FlxG.elapsed;
			
			for (var i:int = _timeThresholds.length - 1; i >= 0; --i)
			{
				if (_levelTime > _timeThresholds[i])
				{
					if ((i + 1) != _difficultyLevel)
					{
						_difficultyLevel = i + 1;
						trace("New difficulty level: ", _difficultyLevel, _levelTime);
					}
					break;
				}
			}
			
			if ((_levelTime - _lastPlaneTime) > _timesBetweenPlanes[_difficultyLevel])
			{
				_lastPlaneTime = _levelTime;
				_planeSpawnFunction();
			}
			
			if ((_levelTime - _lastBuildingTime) > _timesBetweenBuildings[_difficultyLevel])
			{
				_lastBuildingTime = _levelTime;
				_buildingSpawnFunction();
			}
		}
	}
}