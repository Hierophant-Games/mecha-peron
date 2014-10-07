package game 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class ScoreTracker 
	{
		public static const PLANE:uint 		= 0;
		public static const BUILDING:uint 	= 1;
		public static const SOLDIER:uint 	= 2;
		public static const CANNON:uint 	= 3;
		private static const TRACK_COUNT:uint 	= 4; // max
		
		private static const _names:Array = ["planesKilled", "buildingsKilled", "soldiersKilled", "cannonsKilled"];
		private static const _points:Array = [10, 20, 1, 20];
		private static var _killedCount:Array = [0, 0, 0, 0];
		
		public static function reset():void
		{
			for (var i:uint = 0; i < TRACK_COUNT; ++i)
			{
				_killedCount[i] = 0;
			}
			FlxG.score = 0;
		}
		
		/**
		 * Tell the tracker that some thing has been killed
		 * @param	type the kind of stuff that's killed (i.e., PLANE, BUILDING...)
		 */
		public static function killed(type:uint):void
		{
			++_killedCount[type];
			FlxG.score += _points[type];
		}
		
		public static function publish():void
		{
			if (FlxG.kong)
			{
				for (var i:uint = 0; i < TRACK_COUNT; ++i)
				{
					FlxG.kong.API.stats.submit(_names[i], _killedCount[i]);
				}
				FlxG.kong.API.stats.submit("points", FlxG.score);
			}
		}
	}
}