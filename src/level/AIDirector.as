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
		private var _levelTime:Number = 0; // unused now
		private var _difficultyLevel:int = 0;
		
		private const DIFFICULTY_LEVEL_COUNT:uint = 4;
		
		// position to switch difficulty level
		private const POS_THRESHOLDS:Array = [1000, 2000, 3000];
		
		// planes!
		private const POS_BETWEEN_PLANES:Array = [200, 150, 100, 50];
		private var _lastPlanePos:Number = -150;
		private var _planeSpawnFunction:Function;
		private const PLANE_RANDOM_TWEAK:Number = 50; // px of randomness
		
		// buildings!
		private const POS_BETWEEN_BUILDINGS:Array = [400, 300, 250, 150];
		private var _lastBuildingPos:Number = 0;
		private var _buildingSpawnFunction:Function;
		private const BUILDING_RANDOM_TWEAK:Number = 50; // px of randomness
		
		// cannons!
		private const POS_BETWEEN_CANNONS:Array = [500, 300, 200, 100];
		private var _lastCannonPos:Number = 0;
		private var _cannonSpawnFunction:Function;
		private const CANNON_RANDOM_TWEAK:Number = 100; // px of randomness
		
		public function AIDirector(level:FlxState,
			planeSpawnFunction:Function, buildingSpawnFunction:Function, cannonSpawnFunction:Function)
		{
			_level = level;
			_planeSpawnFunction = planeSpawnFunction;
			_buildingSpawnFunction = buildingSpawnFunction;
			_cannonSpawnFunction = cannonSpawnFunction;
		}
		
		public function update(x:Number):void
		{
			_levelTime += FlxG.elapsed;
			
			for (var i:int = POS_THRESHOLDS.length - 1; i >= 0; --i)
			{
				if (x > POS_THRESHOLDS[i])
				{
					if ((i + 1) != _difficultyLevel)
					{
						_difficultyLevel = i + 1;
						trace("New difficulty level: ", _difficultyLevel);
					}
					break;
				}
			}
			
			// planes
			if ((x - _lastPlanePos) > POS_BETWEEN_PLANES[_difficultyLevel])
			{
				_lastPlanePos = x + (FlxU.random() * PLANE_RANDOM_TWEAK);
				_planeSpawnFunction();
			}
			
			// buildings
			if ((x - _lastBuildingPos) > POS_BETWEEN_BUILDINGS[_difficultyLevel])
			{
				_lastBuildingPos = x + (FlxU.random() * BUILDING_RANDOM_TWEAK);
				_buildingSpawnFunction();
			}
			
			// cannons
			if ((x - _lastCannonPos) > POS_BETWEEN_CANNONS[_difficultyLevel])
			{
				_lastCannonPos = x + (FlxU.random() * CANNON_RANDOM_TWEAK);
				_cannonSpawnFunction();
			}
		}
	}
}