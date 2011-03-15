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
		private var _timeThresholds:Array = new Array(30, 60, 90);
		
		// planes!
		private var _timesBetweenPlanes:Array = new Array(6, 5, 3, 1);
		private var _lastPlaneTime:Number = 0;
		private var _planeSpawnFunction:Function;
		
		// buildings!
		private var _posBetweenBuildings:Array = new Array(500, 400, 300, 200);
		private var _lastBuildingPos:Number = 0;
		private var _buildingSpawnFunction:Function;
		
		public function AIDirector(level:FlxState, planeSpawnFunction:Function, buildingSpawnFunction:Function)
		{
			_level = level;
			_planeSpawnFunction = planeSpawnFunction;
			_buildingSpawnFunction = buildingSpawnFunction;
		}
		
		public function update(x:Number):void
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
			
			// planes
			if ((_levelTime - _lastPlaneTime) > _timesBetweenPlanes[_difficultyLevel])
			{
				_lastPlaneTime = _levelTime;
				_planeSpawnFunction();
			}
			
			// buildings
			if ((x - _lastBuildingPos) > _posBetweenBuildings[_difficultyLevel])
			{
				_lastBuildingPos = x;
				_buildingSpawnFunction();
			}
		}
	}
}