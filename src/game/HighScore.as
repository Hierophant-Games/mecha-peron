package game 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class HighScore 
	{
		public static function save(score:Number):void
		{
			var save:FlxSave = new FlxSave();
			save.bind("MechaPeronHighScore");
			save.write("score", score);
			
			// Submit score to the Kong API
			if (FlxG.kong)
			{
				// all kong stats must be positive integers,
				// so let's convert the float with 2 decimals to a simple integer
				// i.e.: if score was '1.23', we'll submit '123'. cool
				var kongScore:uint = uint(score * 100);
				FlxG.kong.API.stats.submit("score", kongScore);
			}
		}
		
		public static function load():Number
		{
			var save:FlxSave = new FlxSave();
			save.bind("MechaPeronHighScore");
			return save.read("score") as Number;
		}
	}
}